import 'package:wallbox_logs/back_layer/model_repos/simulation_repo/user_master/simulation_repo.dart';
import 'package:wallbox_logs/mid_layer/services/database_model.dart';

/// Stores informations about the app's general state (For now only the general price per kWh)
class AppData extends DatabaseModel {
  static const _repoID = 'app_data';
  static const _priceKey = 'defaultPrice';

  /// The price per kWh used if a user doesn't have an individual price set.
  /// All prices are written in cents internally
  final int defaultPricePerkWhInCents;

  /// readonly non-riverpod accesss to the currently active [AppData] State
  static AppData? get instance => repo.cache.values.firstOrNull;

  /// The price per kWh of the active AppData State used if a user doesn't have an individual price set.
  /// All prices are written in cents internally
  static int get defaultPriceInCents =>
      instance?.defaultPricePerkWhInCents ?? 100;

  /// Stores informations about the app's general state (For now only the general price per kWh)
  /// - [defaultPricePerkWhInCents] : The price per kWh used if a user doesn't have an individual price set.
  ///   - All prices are written in cents internally
  AppData({this.defaultPricePerkWhInCents = 100});

  /// create a copy of this. All unset parameters will be inherited from the current instance
  AppData copyWith({int? defaultPricePerkWHInCents}) => AppData(
    defaultPricePerkWhInCents:
        defaultPricePerkWHInCents ?? this.defaultPricePerkWhInCents,
  );

  @override
  operator ==(Object other) =>
      other is AppData &&
      other.defaultPricePerkWhInCents == defaultPricePerkWhInCents;
  @override
  int get hashCode => defaultPricePerkWhInCents.hashCode;

  /// reference to the repository
  static final SimulationRepo<AppData> repo = SimulationRepo('app_data');

  @override
  String get repoID => _repoID;

  /// Converts this into a json readable map
  Map<String, dynamic> toJson() => {_priceKey: defaultPricePerkWhInCents};

  /// Converts a json readable map into an [AppData] instance
  factory AppData.fromJson(Map<String, dynamic> json) =>
      AppData(defaultPricePerkWhInCents: json[_priceKey]);
}
