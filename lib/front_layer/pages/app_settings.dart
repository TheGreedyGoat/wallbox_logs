import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallbox_logs/front_layer/widgets/my_text_form_field.dart';
import 'package:wallbox_logs/riverpod/providers.dart';
import 'package:wallbox_logs/utility.dart';

/// Lets the user change the app's settings (ATM default kWh price only)
class AppSettingsPage extends ConsumerStatefulWidget {
  /// Lets the user change the app's settings (ATM default kWh price only)
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
                child: Icon(Icons.save),
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
    return Form(
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
        ],
      ),
    );
  }
}
