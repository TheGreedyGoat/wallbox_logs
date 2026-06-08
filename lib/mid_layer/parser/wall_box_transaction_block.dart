import 'package:wallbox_logs/back_layer/model_repos/simulation_repo/user_master/simulation_repo.dart';
import 'package:wallbox_logs/mid_layer/models/database_model.dart';
import 'package:wallbox_logs/mid_layer/models/transaction/wall_box_transaction.dart';
import 'package:wallbox_logs/mid_layer/parser/wall_box_line.dart';

class WallBoxTransactionBlock implements DatabaseModel {
  WallBoxTransactionBlock({this.start, required this.mvLines, this.stop});
  final MainLine? start;
  List<MVLine> mvLines;
  final MainLine? stop;

  static final SimulationRepo<WallBoxTransactionBlock> inCompleteRepo =
      SimulationRepo<WallBoxTransactionBlock>('incomplete_blocks');

  @override
  String toString() {
    return 'Start: ${start ?? '/'}\n   num mv: ${mvLines.length},\n   Stop: ${stop ?? '/'}\n';
  }

  bool get isCompleted => start != null && stop != null;

  WallBoxTransaction? get tryGetTransaction {
    WallBoxTransactionBlock block = checkForMerge();
    return block.isCompleted
        ? WallBoxTransaction(
            start: block.start!.toEvent,
            stop: block.stop!.toEvent,
          )
        : null;
  }

  bool _canMergeAtStart(WallBoxTransactionBlock other) {
    if (start != null || other.stop != null) return false;
    final ownEnd = mvLines.last;
    final otherEnd = other.mvLines.first;

    return ownEnd.timeStamp.difference(otherEnd.timeStamp).abs() <=
        Duration(minutes: 16);
  }

  bool _canMergeAtEnd(WallBoxTransactionBlock other) {
    if (stop != null || other.start != null) return false;
    final ownEnd = mvLines.first;
    final otherEnd = other.mvLines.last;

    return ownEnd.timeStamp.difference(otherEnd.timeStamp).abs() <=
        Duration(minutes: 16);
  }

  WallBoxTransactionBlock? tryMerge(WallBoxTransactionBlock other) {
    if (_canMergeAtStart(other)) {
      return WallBoxTransactionBlock(
        start: other.start,
        mvLines: [...other.mvLines, ...mvLines],
        stop: stop,
      );
    } else if (_canMergeAtEnd(other)) {
      return WallBoxTransactionBlock(
        start: start,
        mvLines: [...mvLines, ...other.mvLines],
        stop: other.stop,
      );
    }
  }

  WallBoxTransactionBlock checkForMerge() {
    if (isCompleted) return this;
    final incomplete = inCompleteRepo.getAll();
    for (int i = 0; i < incomplete.length; i++) {
      WallBoxTransactionBlock? maybeMerged = tryMerge(incomplete[i]);
      if (maybeMerged != null) return maybeMerged;
    }
    return this;
  }

  @override
  String get repoID => DateTime.now().millisecondsSinceEpoch.toString();
}
