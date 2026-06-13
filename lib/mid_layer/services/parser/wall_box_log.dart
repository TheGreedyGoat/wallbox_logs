import 'package:wallbox_logs/mid_layer/data/log_file_data.dart';
import 'package:wallbox_logs/mid_layer/models/transaction/wall_box_transaction.dart';
import 'package:wallbox_logs/mid_layer/services/parser/wall_box_line/wall_box_line.dart';
import 'package:wallbox_logs/mid_layer/services/parser/wall_box_transaction_block/wall_box_transaction_block.dart';

enum LineType { start, stop, mv }

Map<LineType, List<LineType>> successors = {
  LineType.start: [LineType.mv],
  LineType.stop: [LineType.start],
  LineType.mv: [LineType.mv, LineType.stop],
};

enum DataType {
  date(r'\d{4}(\-\d{2}){2} \d{2}(:\d{2}){2}'),
  power(r'\d+\.\d{2,3}'),
  tagID(r'[0-9A-Z]{5,}')
  ;

  final String regExSource;
  const DataType(this.regExSource);
}

RegExp startExp = RegExp(r'txstart');
RegExp stopExp = RegExp(r'txstop');
RegExp mvExp = RegExp(r'mv');

class WallBoxLog {
  static Future<WallBoxLog> fromFileData(LogFileData file) async {
    String content = await file.content;
    print('WallboxLog creator recieved content with ${content.length} chars');
    return WallBoxLog(content);
  }

  WallBoxLog(String source) {
    final split = source.split('\n');
    List<WallBoxTransactionBlock> blocks = List.empty(growable: true);
    for (int i = 0; i < split.length; i++) {
      MainLine? start;
      MainLine? stop;
      final List<MVLine> mvs = List.empty(growable: true);
      int j = i;
      for (; j < split.length; j++) {
        bool shouldBreak = false;
        WallboxLine? parsed = WallboxLine.tryParse(split[j]);
        if (parsed == null) continue;
        switch (parsed.type) {
          case LineType.start:
            assert(start == null, '$i, $j');
            start = parsed as MainLine;
            break;
          case LineType.mv:
            mvs.add(parsed as MVLine);
            break;
          case LineType.stop:
            stop = parsed as MainLine;
            shouldBreak = true;
            break;
        }
        if (shouldBreak) {
          break;
        }
      }
      blocks.add(
        WallBoxTransactionBlock(start: start, mvLines: mvs, stop: stop),
      );
      i = j;
    }
    this.blocks = blocks.toList(growable: false);
  }
  late final List<WallBoxTransactionBlock> blocks;

  @override
  String toString() => blocks.fold(
    '',
    (previousValue, element) => '${previousValue}${element.toString()}\n',
  );

  List<WallBoxTransaction> createTransactions() {
    List<WallBoxTransaction> result = List.empty(growable: true);
    for (final block in blocks) {
      WallBoxTransaction? fromBlock = block.tryGetTransaction;
      if (fromBlock != null) {
        result.add(fromBlock);
        WallBoxTransaction.repo.createOrUpdate(fromBlock);
      }
    }
    return result;
  }
}
