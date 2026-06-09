import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:wallbox_logs/front_layer/widgets/input_field_decoration.dart';
import 'package:wallbox_logs/front_layer/widgets/my_text_form_field.dart';
import 'package:wallbox_logs/mid_layer/services/user_master/user_master_data.dart';
import 'package:wallbox_logs/riverpod/providers.dart';

/// Main Page for creating a new or editing an existing Wallbox user
class UserEditing extends ConsumerStatefulWidget {
  /// if not null, this profiles data will be inserted into the form.
  /// Used to edit and override an existing user
  final UserMasterData? original;

  /// Main Page for creating a new or editing an existing Wallbox user
  /// - [original]: Used to edit and override an existing user
  const UserEditing({super.key, this.original});

  @override
  ConsumerState<UserEditing> createState() => _UserEditingState();
}

class _UserEditingState extends ConsumerState<UserEditing> {
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
    if (widget.original != null) {
      _fillIn(widget.original!);
    }
    _globalKey = GlobalKey<FormState>();
    _companyController = TextEditingController(text: company);
    Future(
      () => ref
          .read(widgetTreeProvider.notifier)
          .setCustomPage(
            ref
                .read(widgetTreeProvider)
                .copyWith(
                  floatingActionButton: FloatingActionButton(
                    child: Icon(Icons.save),
                    onPressed: () async {
                      if (_globalKey.currentState!.validate()) {
                        _globalKey.currentState!.save();
                        String action = await _checkExisting();
                        _showSnackBar(action);
                        print(UserMasterData.repo.getById(tagID ?? ''));
                      }
                    },
                  ),
                ),
          ),
    );
  }

  void _fillIn(UserMasterData user) {
    title = user.title;
    tagID = user.tagID;
    prename = user.prename;
    surname = user.surname;
    streetAndNumber = user.streetAndNumber;
    postcode = user.postCode;
    city = user.city;
    phone = user.phoneNumber;
    email = user.email;
    company = user.company;
    individualPriceInCent = user.individualPricePerkWhInCents;
  }

  final List<String> testStrings = UserMasterData.companies;
  @override
  Widget build(BuildContext context) {
    final double verticalFieldMagin = 10;
    final double horizontalMargin = 5.0;
    Widget _spacerH() => SizedBox(
      width: horizontalMargin,
    );

    Widget _spacerV() => SizedBox(
      height: verticalFieldMagin,
    );

    Widget _sectionHead(String label) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(
          height: 0,
          width: double.infinity,
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 2.0,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ),
        ),
        _spacerV(),
      ],
    );

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 8888888b.
                    // 888   Y88b
                    // 888    888
                    // 888   d88P .d88b.   .d88888 888  888
                    // 8888888P" d8P  Y8b d88" 888 888  888
                    // 888 T88b  88888888 888  888 888  888
                    // 888  T88b Y8b.     Y88b 888 Y88b 888
                    // 888   T88b "Y8888   "Y88888  "Y88888
                    //                         888
                    //                         888
                    //                         888
                    _sectionHead('Erforderlich'),
                    Row(
                      children: [
                        SizedBox(
                          width: 100,
                          child: InputFieldDecoration(
                            child: DropdownButtonFormField<Titles>(
                              hint: Text('Anrede'),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                              items: Titles.values
                                  .map<DropdownMenuItem<Titles>>(
                                    (e) => DropdownMenuItem<Titles>(
                                      value: e,
                                      child: Text(e.label),
                                      // label: e.label,
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {},
                            ),
                          ),
                        ),
                        _spacerH(),
                        MyTextFormField(
                          label: 'Vorname',
                          initialValue: prename,
                          wrapWithExpanded: true,
                          isRequired: true,
                          onSaved: (value) => setState(
                            () {
                              prename = value;
                            },
                          ),
                        ),
                        _spacerH(),
                        MyTextFormField(
                          label: 'Nachname',
                          initialValue: surname,
                          wrapWithExpanded: true,
                          isRequired: true,
                          onSaved: (value) => setState(
                            () {
                              surname = value;
                            },
                          ),
                        ),
                        _spacerH(),
                        MyTextFormField(
                          label: 'Tag-ID',
                          initialValue: tagID,
                          onSaved: (value) => setState(
                            () {
                              tagID = value;
                            },
                          ),
                          isRequired: true,
                          wrapWithExpanded: true,
                        ),
                      ],
                    ),

                    //        d8888      888
                    //       d88888      888
                    //      d88P888      888
                    //     d88P 888  .d88888 888d888  .d88b.  .d8888b  .d8888b
                    //    d88P  888 d88" 888 888P"   d8P  Y8b 88K      88K
                    //   d88P   888 888  888 888     88888888 "Y8888b. "Y8888b.
                    //  d8888888888 Y88b 888 888     Y8b.          X88      X88
                    // d88P     888  "Y88888 888      "Y8888   88888P'  88888P'
                    _sectionHead('Adresse'),
                    MyTextFormField(
                      label: 'Straße & Hausnummer',
                      initialValue: streetAndNumber,
                      onSaved: (value) {
                        setState(() {
                          streetAndNumber = value;
                        });
                      },
                    ),
                    _spacerV(),
                    Row(
                      children: [
                        MyTextFormField(
                          label: 'PLZ',
                          initialValue: postcode,
                          wrapWithExpanded: true,
                          inputType: InputType.integer,
                          characterLimit: 5,
                          customValidator: (value) {
                            return value != null &&
                                    value.isNotEmpty &&
                                    int.tryParse(value) == null
                                ? 'nur Zahlen erlaubt!'
                                : null;
                          },
                          onSaved: (value) => setState(
                            () {
                              postcode = value;
                            },
                          ),
                        ),
                        _spacerH(),
                        MyTextFormField(
                          label: 'Ort',
                          initialValue: city,
                          wrapWithExpanded: true,
                          characterLimit: 20,
                          onSaved: (value) => setState(
                            () {
                              city = value;
                            },
                          ),
                        ),
                        _spacerH(),
                      ],
                    ),
                    _spacerV(),

                    //  .d8888b.                    888                      888
                    // d88P  Y88b                   888                      888
                    // 888    888                   888                      888
                    // 888         .d88b.  88888b.  888888  8888b.   .d8888b 888888
                    // 888        d88""88b 888 "88b 888        "88b d88P"    888
                    // 888    888 888  888 888  888 888    .d888888 888      888
                    // Y88b  d88P Y88..88P 888  888 Y88b.  888  888 Y88b.    Y88b.
                    //  "Y8888P"   "Y88P"  888  888  "Y888 "Y888888  "Y8888P  "Y888
                    _sectionHead('Kontakt'),
                    Row(
                      children: [
                        MyTextFormField(
                          label: 'Telefon',
                          initialValue: phone,
                          inputType: InputType.integer,
                          wrapWithExpanded: true,
                          onSaved: (value) => setState(
                            () {
                              phone = value;
                            },
                          ),
                        ),
                        _spacerH(),
                        MyTextFormField(
                          label: 'email',
                          initialValue: email,
                          inputType: InputType.text,
                          wrapWithExpanded: true,
                          customValidator: (value) {
                            if (value == null || value.isEmpty) {
                              return null;
                            }
                            final splitAt = value.split('@');
                            if (splitAt.length != 2 ||
                                splitAt[0].isEmpty ||
                                splitAt[1].isEmpty ||
                                !splitAt[1].contains('.')) {
                              return 'ungültige Email-Adresse';
                            }
                            return null;
                          },
                          onSaved: (value) => setState(
                            () {
                              email = value;
                            },
                          ),
                        ),
                      ],
                    ),
                    _spacerV(),
                    //          888    888
                    //          888    888
                    //          888    888
                    //  .d88b.  888888 88888b.   .d88b.  888d888
                    // d88""88b 888    888 "88b d8P  Y8b 888P"
                    // 888  888 888    888  888 88888888 888
                    // Y88..88P Y88b.  888  888 Y8b.     888
                    //  "Y88P"   "Y888 888  888  "Y8888  888
                    _sectionHead('Sonstiges'),
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
                        _spacerH(),
                        MyTextFormField(
                          label: 'Preis cent/ kWh',
                          inputType: InputType.integer,
                          wrapWithExpanded: true,
                          initialValue: individualPriceInCent?.toString(),
                          customValidator: (value) {
                            int? val = int.tryParse(value!);
                            return val != null && val <= 0
                                ? 'Ungültige Eingabe'
                                : null;
                          },
                          onSaved: (value) => setState(
                            () {
                              individualPriceInCent = int.tryParse(value ?? '');
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 888               888
  // 888               888
  // 888               888
  // 88888b.   .d88b.  888 88888b.   .d88b.  888d888 .d8888b
  // 888 "88b d8P  Y8b 888 888 "88b d8P  Y8b 888P"   88K
  // 888  888 88888888 888 888  888 88888888 888     "Y8888b.
  // 888  888 Y8b.     888 888 d88P Y8b.     888          X88
  // 888  888  "Y8888  888 88888P"   "Y8888  888      88888P'
  //                       888
  //                       888
  //                       888
  Future<String> _checkExisting() async {
    UserMasterData? check = UserMasterData.repo.getById(tagID!);
    String action = 'nicht gespeichert';
    print(individualPriceInCent);
    if (check != null && (await _idExistsDialog(check))!) {
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

  // ignore: unused_element
  Future<String> _saveUser(UserMasterData user) async {
    final repo = UserMasterData.repo;
    if (repo.hasEntry(user.tagID)) {
      repo.update(user);
      return 'aktualisiert';
    } else {
      repo.create(user);
      return 'erstellt';
    }
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

  void _showSnackBar(String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Center(child: Text('Nutzerdaten wurden $action'))),
    );
  }
}
