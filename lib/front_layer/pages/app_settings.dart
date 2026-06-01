import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallbox_logs/front_layer/widgets/my_text_form_field.dart';
import 'package:wallbox_logs/main.dart';
import 'package:wallbox_logs/mid_layer/models/transaction/wall_box_transaction.dart';
import 'package:wallbox_logs/mid_layer/models/user_master/user_master_data.dart';
import 'package:wallbox_logs/riverpod/providers.dart';
import 'package:wallbox_logs/utility.dart';

class AppSettingsPage extends ConsumerStatefulWidget {
  const AppSettingsPage({super.key});

  @override
  ConsumerState<AppSettingsPage> createState() => _AppSettingsPageState();
}

class _AppSettingsPageState extends ConsumerState<AppSettingsPage> {
  late final GlobalKey<FormState> _globalKey;
  @override
  void initState() {
    super.initState();
    _globalKey = GlobalKey<FormState>();
    final notifier = ref.read(widgetTreeProvider.notifier);

    Future(
      () => notifier.setCustomPage(
        ref
            .read(widgetTreeProvider)
            .copyWith(
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  if (_globalKey.currentState!.validate()) {
                    _globalKey.currentState!.save();
                  }
                },
              ),
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: _globalKey,
        child: Column(
          children: [
            MyTextFormField(
              initialValue: Utility.centsToEuros(
                ref.read(appDataProvider).defaultPricePerkWhInCents,
              ).toStringAsFixed(2),
              isRequired: true,
              label: 'Standart-Preis/ kWh (€)',
              inputType: InputType.double,
              onSaved: (value) {
                ref
                    .read(appDataProvider.notifier)
                    .setDefaultPrice(Utility.euroToCents(double.parse(value!)));
              },
              customValidator: (value) {
                return double.tryParse(value ?? 'k') == null
                    ? 'ungültiger Preis'
                    : null;
              },
            ),
            ElevatedButton(
              onPressed: () async {
                await WallBoxTransaction.repo.clear();
                await preload();
              },
              child: Text('reset Transactions (DEBUG)'),
            ),
            ElevatedButton(
              onPressed: () async {
                await UserMasterData.repo.clear();
                await preload();
              },
              child: Text('reset UMD (DEBUG)'),
            ),
          ],
        ),
      ),
    );
  }
}
