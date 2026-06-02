import 'package:wallbox_logs/back_layer/model_repos/model_repository.dart';
import 'package:wallbox_logs/back_layer/model_repos/simulation_repo/user_master/simulation_repo.dart';
import 'package:wallbox_logs/mid_layer/models/database_model.dart';

class AppData extends DatabaseModel {
  static const _repoID = 'app_data';
  static const priceKey = 'defaultPrice';
  final int defaultPricePerkWhInCents;

  static AppData? get instance => repo.cache.values.firstOrNull;
  static int get defaultPriceInCents =>
      instance?.defaultPricePerkWhInCents ?? 100;
  AppData({this.defaultPricePerkWhInCents = 100});

  AppData copyWith({int? defaultPricePerkWHInCents}) => AppData(
    defaultPricePerkWhInCents:
        defaultPricePerkWHInCents ?? this.defaultPricePerkWhInCents,
  );

  operator ==(Object? other) =>
      other is AppData &&
      other.defaultPricePerkWhInCents == defaultPricePerkWhInCents;
  @override
  int get hashCode => defaultPricePerkWhInCents.hashCode;

  static final SimulationRepo<AppData> repo = SimulationRepo('app_data');

  @override
  String get repoID => _repoID;

  Map<String, dynamic> toJson() => {priceKey: defaultPricePerkWhInCents};
  factory AppData.fromJson(Map<String, dynamic> json) =>
      AppData(defaultPricePerkWhInCents: json[priceKey]);
}
