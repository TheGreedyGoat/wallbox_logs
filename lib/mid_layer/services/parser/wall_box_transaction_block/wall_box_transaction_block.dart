import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wallbox_logs/back_layer/model_repos/simulation_repo/user_master/simulation_repo.dart';
import 'package:wallbox_logs/mid_layer/services/database_model.dart';
import 'package:wallbox_logs/mid_layer/services/transaction/wall_box_transaction.dart';
import 'package:wallbox_logs/mid_layer/services/parser/wall_box_line/wall_box_line.dart';

part 'wall_box_transaction_block.freezed.dart';
part 'wall_box_transaction_block.g.dart';

/// Represents  either a full charging process with a start and an end or an incomplete one (when it got interrupted by an end of the log file)
@freezed
@JsonSerializable()
class WallBoxTransactionBlock
    with _$WallBoxTransactionBlock
    implements DatabaseModel {
  /// Represents  either a full charging process with a start and an end or an incomplete one (when it got interrupted by an end of the log file)
  /// - [start] :  stores data of the transactions beginning
  /// - [mvLines] : The interim log lines
  /// - [stop] : stores data of the transactions ending
  WallBoxTransactionBlock({this.start, required this.mvLines, this.stop});

  ///stores data of the transactions beginning
  @override
  final MainLine? start;

  /// The interim log lines
  @override
  List<MVLine> mvLines;

  /// stores data of the transactions ending
  @override
  final MainLine? stop;

  /// The repository to store any blocks that lack a start or an end
  static final SimulationRepo<WallBoxTransactionBlock> inCompleteRepo =
      SimulationRepo<WallBoxTransactionBlock>('incomplete_blocks');

  @override
  String toString() {
    return 'Start: ${start ?? '/'}\n   num mv: ${mvLines.length},\n   Stop: ${stop ?? '/'}\n';
  }

  /// returns true, if this has a start and an end set
  bool get isCompleted => start != null && stop != null;

  /// if this is incomplete, we try to find the matching 'other end' of the block to merge with.
  ///
  /// If it is complete or we successfully merged, we create a new WallBoxTransaction
  WallBoxTransaction? get tryGetTransaction {
    WallBoxTransactionBlock block = _checkForMerge();
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

  WallBoxTransactionBlock? _tryMerge(WallBoxTransactionBlock other) {
    if (_canMergeAtStart(other)) {
      inCompleteRepo.delete(
        other.repoID,
        () async => true,
      );
      return WallBoxTransactionBlock(
        start: other.start,
        mvLines: [...other.mvLines, ...mvLines],
        stop: stop,
      );
    } else if (_canMergeAtEnd(other)) {
      inCompleteRepo.delete(
        other.repoID,
        () async => true,
      );
      return WallBoxTransactionBlock(
        start: start,
        mvLines: [...mvLines, ...other.mvLines],
        stop: other.stop,
      );
    }
    return null;
  }

  WallBoxTransactionBlock _checkForMerge() {
    if (isCompleted) return this;
    final incomplete = inCompleteRepo.getAll();
    for (int i = 0; i < incomplete.length; i++) {
      WallBoxTransactionBlock? maybeMerged = _tryMerge(incomplete[i]);
      if (maybeMerged != null) return maybeMerged;
    }
    inCompleteRepo.createOrUpdate(this);
    return this;
  }

  @override
  String get repoID => DateTime.now().millisecondsSinceEpoch.toString();

  ///
  factory WallBoxTransactionBlock.fromJson(Map<String, Object?> json) =>
      _$WallBoxTransactionBlockFromJson(json);

  ///
  Map<String, Object?> toJson() => _$WallBoxTransactionBlockToJson(this);

  bool equals(Object other) =>
      other is WallBoxTransactionBlock &&
      _equalLines(start, other.start) &&
      _equalLines(stop, other.stop) &&
      _equalMVLines(mvLines, other.mvLines);

  static bool _equalLines(MainLine? a, MainLine? b) {
    return a == null && b == null || (a != null && b != null && a.equals(b));
  }

  static bool _equalMVLines(List<MVLine> a, List<MVLine> b) {
    if (a.length != b.length) return false;

    for (int i = 0; i < a.length; i++) {
      if (!a[i].equals(b[i])) return false;
    }
    return true;
  }
}
