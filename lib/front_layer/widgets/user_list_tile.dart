import 'package:flutter/material.dart';
import 'package:wallbox_logs/front_layer/pages/user_creation.dart';
import 'package:wallbox_logs/front_layer/widgets/user_details.dart';
import 'package:wallbox_logs/mid_layer/models/user_master/user_master_data.dart';

class UserListTile extends StatelessWidget {
  final UserMasterData profile;
  final bool isExpanded;
  final void Function(bool isExdended) onExpansionChanged;
  // final
  const UserListTile({
    required this.profile,
    required this.onExpansionChanged,
    this.isExpanded = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: isExpanded,
      trailing: IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return UserEditing();
              },
            ),
          );
        },
        icon: Icon(Icons.edit),
      ),
      title: SelectableText(
        'Name: ${profile.fullName}, tagID: ${profile.tagID}',
      ),
      subtitle: Text(
        'Totaler Verbrauch: {profiletoStringAsFixed(3)} kWh',
      ),

      children: [UserDetails(profile: profile)],
      onExpansionChanged: (value) => onExpansionChanged(value),
    );
  }
}
