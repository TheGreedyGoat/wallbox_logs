import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:wallbox_logs/front_layer/widgets/my_text_form_field.dart';
import 'package:wallbox_logs/mid_layer/models/database_model.dart';
import 'package:wallbox_logs/mid_layer/models/user_master/user_master_data.dart';

class UserCreation extends StatefulWidget {
  final UserMasterData? userMasterData;
  const UserCreation({super.key, this.userMasterData});

  @override
  State<UserCreation> createState() => _UserCreationState();
}

class _UserCreationState extends State<UserCreation> {
  late final GlobalKey<FormState> _globalKey;
  late final TextEditingController _companyController;

  String? tagID,
      prename,
      surname,
      streetAndNumber,
      postcode,
      city,
      phone,
      email,
      company;
  Titles title = Titles.div;
  int? individualPriceInCent;

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
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,

          children: [
            Flexible(
              child: Form(
                key: _globalKey,
                child: Column(
                  children: [
                    MyTextFormField(
                      label: 'Tag-ID',
                      initialValue: tagID,
                      onSaved: (value) => setState(
                        () {
                          tagID = value;
                        },
                      ),
                      isRequired: true,
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
                          initialValue: prename,
                          expand: true,
                          isRequired: true,
                          onSaved: (value) => setState(
                            () {
                              prename = value;
                            },
                          ),
                        ),
                        MyTextFormField(
                          label: 'Nachname',
                          initialValue: surname,
                          expand: true,
                          isRequired: true,
                          onSaved: (value) => setState(
                            () {
                              surname = value;
                            },
                          ),
                        ),
                      ],
                    ),
                    MyTextFormField(
                      label: 'Straße & Hausnummer',
                      initialValue: streetAndNumber,
                      onSaved: (value) {
                        setState(() {
                          streetAndNumber = value;
                        });
                      },
                    ),
                    Row(
                      children: [
                        MyTextFormField(
                          label: 'PLZ',
                          initialValue: postcode,
                          expand: true,
                          inputType: InputType.number,
                          maxLength: 5,
                          customValidator: (value) {
                            if (value != null &&
                                value.isNotEmpty &&
                                int.tryParse(value) == null) {
                              return 'nur Zahlen erlaubt!';
                            }
                          },
                          onSaved: (value) => setState(
                            () {
                              postcode = value;
                            },
                          ),
                        ),
                        MyTextFormField(
                          label: 'Ort',
                          initialValue: city,
                          expand: true,
                          maxLength: 20,
                          onSaved: (value) => setState(
                            () {
                              city = value;
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        MyTextFormField(
                          label: 'Telefon',
                          initialValue: phone,
                          inputType: InputType.number,
                          expand: true,
                          onSaved: (value) => setState(
                            () {
                              phone = value;
                            },
                          ),
                        ),
                        MyTextFormField(
                          label: 'email',
                          initialValue: email,
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
                          onSaved: (value) => setState(
                            () {
                              email = value;
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TypeAheadField<String>(
                            controller: _companyController,
                            builder: (context, controller, focusNode) {
                              return MyTextFormField(
                                controller: controller,
                                focusNode: focusNode,
                                label: 'Unternehmen',
                                initialValue: company,
                                onSaved: (value) => setState(
                                  () {
                                    company = value;
                                  },
                                ),
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
                          initialValue: individualPriceInCent.toString(),
                          customValidator: (value) {
                            int? val = int.tryParse(value!);
                            if (val != null && val <= 0) {
                              return 'Ungültige Eingabe';
                            }
                          },
                          onSaved: (value) => setState(
                            () {
                              individualPriceInCent = int.tryParse(value!);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            for (var e in [
              tagID,
              title,
              prename,
              surname,
              streetAndNumber,
              postcode,
              city,
              phone,
              email,
              company,
              individualPriceInCent,
            ])
              Flexible(child: Text(e.toString())),
            Flexible(child: Container()),
            Flexible(
              child: FilledButton(
                onPressed: () async {
                  if (_globalKey.currentState!.validate()) {
                    _globalKey.currentState!.save();
                    String action = await _checkExisting();
                    _showSnackBar(action);
                  }
                },
                child: Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Center(child: Text('Nutzerdaten wurden $action'))),
    );
  }

  Future<String> _checkExisting() async {
    print('saving...');
    DatabaseModel? check = UserMasterData.repo.getById(tagID!);
    String action = 'nicht gespeichert';
    // user chose to override
    if (check != null &&
        check is UserMasterData &&
        (await _idExistsDialog(check))!) {
      UserMasterData.repo.update(
        check.copyWith(
          title: title,
          prename: prename,
          surname: surname,
          streetAndNumber: streetAndNumber,
          postCode: postcode,
          city: city,
          phoneNumber: phone,
          email: email,
          company: company,
          individualPricePerkWhInCents: individualPriceInCent,
        ),
      );
      action = 'aktualisiert';
    } else if (check == null) {
      UserMasterData.repo.create(
        UserMasterData(
          tagID: tagID!,
          title: title,
          prename: prename,
          surname: surname,
          streetAndNumber: streetAndNumber,
          postCode: postcode,
          city: city,
          phoneNumber: phone,
          email: email,
          company: company,
          individualPricePerkWhInCents: individualPriceInCent,
        ),
      );
      action = 'erstellt';
    }
    return action;
  }

  Future<bool?> _idExistsDialog(UserMasterData existing) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Die Tag-ID ${existing.tagID} extistiert bereits für den/ die Nutzer*in ${existing.fullName}. Soll das Profil überschrieben werden?',
          ),

          actions: [
            Column(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text('Überschreiben'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text('Abbrechen'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // Future<bool> _keepTransactionsDialog
}
