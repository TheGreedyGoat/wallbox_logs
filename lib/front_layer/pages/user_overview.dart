import 'package:flutter/material.dart';
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
  late final List<UserMasterData> profiles;

  @override
  void initState() {
    super.initState();
    profiles = UserMasterData.repo.getAll();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MyListView(
        children: [
          for (int i = 0; i < profiles.length; i++)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: UserListTile(
                profile: profiles[i],
                userTagID: profiles[i].tagID,
              ),
            ),
        ],
      ),
    );
  }
}
