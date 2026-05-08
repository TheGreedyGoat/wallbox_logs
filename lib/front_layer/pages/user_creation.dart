import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:wallbox_logs/front_layer/widgets/my_text_form_field.dart';
import 'package:wallbox_logs/mid_layer/db_models/user_master/user_master_data.dart';

class UserCreation extends StatefulWidget {
  final UserMasterData? userMasterData;
  const UserCreation({super.key, this.userMasterData});

  @override
  State<UserCreation> createState() => _UserCreationState();
}

class _UserCreationState extends State<UserCreation> {
  late final GlobalKey<FormState> _globalKey;
  late final TextEditingController _companyController;

  @override
  void initState() {
    super.initState();
    _globalKey = GlobalKey<FormState>();
    _companyController = TextEditingController();
  }

  final List<String> testStrings = UserMasterData.companies;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Form(
            key: _globalKey,
            child: Column(
              children: [
                MyTextFormField(
                  label: 'Tag-ID',
                  isRequired: true,
                  customValidator: (value) {},
                ),
                // Anrede, Name
                Row(
                  children: [
                    DropdownMenuFormField<Titles>(
                      label: Text('Anrede'),
                      width: 120,
                      initialSelection: Titles.div,
                      dropdownMenuEntries: Titles.values
                          .map<DropdownMenuEntry<Titles>>(
                            (e) => DropdownMenuEntry<Titles>(
                              value: e,
                              label: e.label,
                            ),
                          )
                          .toList(),
                    ),

                    MyTextFormField(
                      label: 'Vorname',
                      expand: true,
                      isRequired: true,
                    ),
                    MyTextFormField(
                      label: 'Nachname',
                      expand: true,
                      isRequired: true,
                    ),
                  ],
                ),
                MyTextFormField(label: 'Straße & Hausnummer'),
                Row(
                  children: [
                    MyTextFormField(
                      label: 'PLZ',
                      expand: true,
                      inputType: InputType.number,
                      maxLength: 5,
                    ),
                    MyTextFormField(
                      label: 'Ort',
                      expand: true,
                      maxLength: 20,
                    ),
                  ],
                ),
                Row(
                  children: [
                    MyTextFormField(
                      label: 'Telefon',
                      inputType: InputType.number,
                      expand: true,
                    ),
                    MyTextFormField(
                      label: 'email',
                      inputType: InputType.text,
                      expand: true,
                      customValidator: (value) {
                        if (value == null || value.isEmpty) {
                          return null;
                        }
                        final splitAt = value!.split('@');
                        if (splitAt.length != 2 ||
                            splitAt[0].isEmpty ||
                            splitAt[1].isEmpty ||
                            !splitAt[1].contains('.')) {
                          return 'ungültige Email-Adresse';
                        }
                      },
                    ),
                  ],
                ),
                Text('Ahead'),
                Row(
                  children: [
                    Expanded(
                      child: TypeAheadField<String>(
                        controller: _companyController,
                        builder: (context, controller, focusNode) {
                          return MyTextFormField(
                            controller: controller,
                            focusNode: focusNode,
                            autofocus: true,
                            label: 'Unternehmen',
                          );
                        },
                        itemBuilder: (context, value) {
                          return ListTile(
                            title: Text(value),
                          );
                        },
                        onSelected: (value) {
                          setState(() {
                            _companyController.value = TextEditingValue(
                              text: value,
                            );
                          });
                        },

                        suggestionsCallback: (search) => testStrings,
                      ),
                    ),

                    MyTextFormField(
                      label: 'Preis cent/ kWh',
                      inputType: InputType.number,
                      expand: true,
                    ),
                  ],
                ),
              ],
            ),
          ),

          ///
          Expanded(child: Container()),
          FilledButton(
            onPressed: () {
              if (_globalKey.currentState!.validate()) {
                _globalKey.currentState!.save();
              }
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}
