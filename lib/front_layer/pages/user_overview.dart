import 'package:flutter/material.dart';
import 'package:wallbox_logs/front_layer/widgets/user_details.dart';
import 'package:wallbox_logs/front_layer/widgets/my_list_view.dart';
import 'package:wallbox_logs/front_layer/widgets/user_list_tile.dart';
import 'package:wallbox_logs/mid_layer/models/user_master/user_master_data.dart';

/// Presents all charging data sorted by Users
class UserOverview extends StatefulWidget {
  /// Presents all charging data sorted by Users
  const UserOverview({super.key});
  @override
  State<UserOverview> createState() => _UserOverviewState();
}

class _UserOverviewState extends State<UserOverview> {
  late final Future<List<UserMasterData>> futureProfiles;

  @override
  void initState() {
    super.initState();
    futureProfiles = UserMasterData.repo.getAll();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder(
        future: futureProfiles,
        builder: (context, snapshot) {
          final profiles = snapshot.data;
          if (snapshot.connectionState != ConnectionState.done) {
            return CircularProgressIndicator();
          } else if (profiles == null) {
            return Text('Etwas ist schief gelaufen');
          } else {
            return MyListView(
              children: [
                for (int i = 0; i < profiles.length; i++)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: UserListTileConsumer(
                      profile: profiles[i],
                    ),
                  ),
              ],
            );
          }
        },
      ),
    );
  }
}
