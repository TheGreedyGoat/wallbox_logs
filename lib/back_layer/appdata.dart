import 'dart:convert';

import 'package:wallbox_logs/back_layer/model_repos/simulation_repo/user_master/simulation_repo.dart';
import 'package:wallbox_logs/back_layer/my_local_database.dart';
import 'package:wallbox_logs/mid_layer/services/database_model.dart';
import 'package:wallbox_logs/mid_layer/services/user_master/user_master_data.dart';

/// Stores informations about the app's general state (For now only the general price per kWh)
class AppData {
  static const _filename = 'appdata.json';
  static const _subPath = 'app_data';
  static const _defaultPriceKey = 'defaultPrice';
  static const _compPriceKey = 'companyPricesKeys';

  static AppData _instance = AppData();

  /// The price per kWh used if a user doesn't have an individual price set.
  /// All prices are written in cents internally
  final int defaultPricePerkWhInCents;

  final Map<String, int> companyPrices;

  /// readonly non-riverpod accesss to the currently active [AppData] State
  static AppData get instance => _instance;

  /// The price per kWh of the active AppData State used if a user doesn't have an individual price set.
  /// All prices are written in cents internally
  static int get defaultPriceInCents => instance.defaultPricePerkWhInCents;

  static int companyPrice(String? company) =>
      instance.companyPrices[company ?? ''] ?? defaultPriceInCents;

  /// Stores informations about the app's general state (For now only the general price per kWh)
  /// - [defaultPricePerkWhInCents] : The price per kWh used if a user doesn't have an individual price set.
  ///   - All prices are written in cents internally
  AppData({
    this.defaultPricePerkWhInCents = 100,
    this.companyPrices = const {
      'cdemy': 80,
      'Inventarkreisel': 40,
      'SpaceX': 10000000,
    },
  }) {
    _save();
  }

  Future<void> _save() async {
    _instance = this;
    print(toJson());
    MyLocalDatabase.writeFile(_filename, jsonEncode(toJson()), _subPath);
  }

  static Future<void> load() async {
    try {
      final content = await MyLocalDatabase.readFile(_filename, _subPath);
      _instance = AppData.fromJson(jsonDecode(content));
    } catch (e) {
      print('Error while reading appData: $e');
      _instance = AppData();
    }
  }

  /// create a copy of this. All unset parameters will be inherited from the current instance
  AppData copyWith({
    int? defaultPricePerkWHInCents,
    Map<String, int>? companyPrices,
  }) => AppData(
    defaultPricePerkWhInCents:
        defaultPricePerkWHInCents ?? this.defaultPricePerkWhInCents,
    companyPrices: companyPrices ?? this.companyPrices,
  );

  @override
  operator ==(Object other) =>
      other is AppData &&
      other.defaultPricePerkWhInCents == defaultPricePerkWhInCents &&
      other.companyPrices == companyPrices;
  @override
  int get hashCode => defaultPricePerkWhInCents.hashCode;

  String get repoID => _subPath;

  /// Converts this into a json readable map
  Map<String, dynamic> toJson() => {
    _defaultPriceKey: defaultPricePerkWhInCents,
    _compPriceKey: companyPrices,
  };

  /// Converts a json readable map into an [AppData] instance
  factory AppData.fromJson(Map<String, dynamic> json) => AppData(
    defaultPricePerkWhInCents: json[_defaultPriceKey],
    companyPrices: Map<String, int>.from(json[_compPriceKey] ?? {}),
  );
}
// json[_compPriceKey].keys