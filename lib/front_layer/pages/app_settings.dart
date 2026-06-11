import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallbox_logs/front_layer/widgets/editable_data_field.dart';
import 'package:wallbox_logs/front_layer/widgets/filter_widgets/my_text_field.dart';
import 'package:wallbox_logs/front_layer/widgets/my_container.dart';
import 'package:wallbox_logs/front_layer/widgets/my_text_form_field.dart';
import 'package:wallbox_logs/front_layer/widgets/section_title.dart';
import 'package:wallbox_logs/mid_layer/services/user_master/user_master_data.dart';
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
    final companyPrices = ref.watch(appDataProvider).companyPrices;
    return Form(
      key: _globalKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionTitle(title: 'Daten'),

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
                      .setDefaultPrice(
                        Utility.euroToCents(double.parse(value!)),
                      );
                },
                customValidator: (value) {
                  return double.tryParse(value ?? 'k') == null
                      ? 'ungültiger Preis'
                      : null;
                },
              ),

              MyContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final company in companyPrices.keys)
                      _companyPriceField(
                        company,
                        Utility.costsDisplay(companyPrices[company]!, false),
                      ),
                    for (final company in UserMasterData.companies)
                      if (!companyPrices.keys.contains(company))
                        _companyPriceField(company, ''),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _companyPriceField(String company, String value) => Padding(
    padding: const EdgeInsets.only(top: 8.0),
    child: EditableDataField(
      unit: '€',
      label: company,
      inputFormatters: [
        Utility.doubleFormatter(2),
      ],
      initialValue: value,
      onSaved: (value) {
        double parsed = double.parse(
          value.replaceAll(',', '.'),
        );
        ref
            .read(appDataProvider.notifier)
            .setCompanyPrice(
              company,
              (parsed * 100).floor(),
            );
      },
    ),
  );
}
