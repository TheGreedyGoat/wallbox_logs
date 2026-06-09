import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallbox_logs/back_layer/appdata.dart';

/// controls the app's state
class AppDataNotifier extends Notifier<AppData> {
  @override
  build() {
    final cache = AppData.repo.cache;
    return cache.isEmpty
        ? AppData(defaultPricePerkWhInCents: 100)
        : cache.values.toList()[0];
  }

  /// Set the price to use for users that dont have an individual price set
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
