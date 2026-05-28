import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallbox_logs/back_layer/appdata.dart';
import 'package:wallbox_logs/back_layer/my_local_database.dart';

class AppDataNotifier extends Notifier<AppData> {
  @override
  build() {
    final cache = AppData.repo.cache;
    return cache.isEmpty
        ? AppData(defaultPricePerkWhInCents: 100)
        : cache.values.toList()[0];
  }

  void setDefaultPrice(int newPrice) =>
      state = state.copyWith(defaultPricePerkWHInCents: newPrice);

  @override
  bool updateShouldNotify(AppData previous, AppData next) {
    bool shouldNotify = super.updateShouldNotify(previous, next);
    if (shouldNotify) {
      AppData.repo.createOrUpdate(next);
      // MyLocalDatabase.writeFile('app_data.json', jsonEncode(next.toJson()));
    }
    return shouldNotify;
  }
}
