import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallbox_logs/back_layer/appdata.dart';

/// controls the app's state
class AppDataNotifier extends Notifier<AppData> {
  @override
  build() {
    return AppData.instance;
  }

  /// Set the price to use for users that dont have an individual price set
  void setDefaultPrice(int newPrice) =>
      state = state.copyWith(defaultPricePerkWHInCents: newPrice);

  void setCompanyPrice(String key, int cents) {
    Map<String, int> newMap = {};
    for (final key in state.companyPrices.keys) {
      newMap[key] = state.companyPrices[key]!;
    }
    newMap[key] = cents;
    state = state.copyWith(companyPrices: newMap);
  }

  // @override
  // bool updateShouldNotify(AppData previous, AppData next) {
  //   bool shouldNotify = super.updateShouldNotify(previous, next);
  //   if (shouldNotify) {
  //     AppData.repo.createOrUpdate(next);
  //     // MyLocalDatabase.writeFile('app_data.json', jsonEncode(next.toJson()));
  //   }
  //   return shouldNotify;
  // }
}
