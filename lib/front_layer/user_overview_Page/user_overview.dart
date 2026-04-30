import 'package:flutter/material.dart';
import 'package:wallbox_logs/front_layer/user_details_page/user_details.dart';
import 'package:wallbox_logs/front_layer/widgets/my_list_view.dart';
import 'package:wallbox_logs/mid_layer/data/user_data.dart';

class UserOverview extends StatefulWidget {
  const UserOverview({super.key});
  @override
  State<UserOverview> createState() => _UserOverviewState();
}

class _UserOverviewState extends State<UserOverview> {
  int? selectedTile;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MyListView(
        children: [
          for (int i = 0; i < UserData.profiles.length; i++)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: userListTile(
                UserData.profiles[i],
                selectedTile == i,
                i,
                context,
              ),
            ),
        ],
      ),
    );
  }

  Widget userListTile(
    UserData profile,
    bool expand,
    int index,
    BuildContext context,
  ) {
    print('$index, $expand');
    return ExpansionTile(
      initiallyExpanded: expand,

      title: Text(
        'Karten-ID: ${profile.id2}',
      ),
      subtitle: Text(
        'Totaler Verbrauch: ${profile.totalConsumptionKWH.toStringAsFixed(3)} kWh',
      ),

      children: [UserDetails(profile: profile)],
      onExpansionChanged: (bool value) {
        if (value) {
          setState(() {
            selectedTile = index;
          });
        }
      },
    );
  }
}
