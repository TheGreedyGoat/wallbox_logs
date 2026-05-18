import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallbox_logs/front_layer/pages/user_creation.dart';
import 'package:wallbox_logs/front_layer/widgets/user_details.dart';
import 'package:wallbox_logs/mid_layer/models/user_master/user_master_data.dart';
import 'package:wallbox_logs/riverpod/models/page_state.dart';
import 'package:wallbox_logs/riverpod/providers.dart';
import 'package:wallbox_logs/riverpod/widget_tree_notifier.dart';

class UserListTileConsumer extends ConsumerStatefulWidget {
  final UserMasterData profile;
  // final
  const UserListTileConsumer({
    required this.profile,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserListTileConsumerState();
}

class _UserListTileConsumerState extends ConsumerState<UserListTileConsumer> {
  bool isExpanded = false;
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: false,
      leading: Icon(
        isExpanded ? Icons.arrow_drop_down : Icons.arrow_right_sharp,
      ),
      trailing: IconButton(
        onPressed: () {
          ref
              .read(widgetTreeProvider.notifier)
              .setCustom(
                PageState(
                  page: UserEditing(original: widget.profile),
                  title: 'Bearbeiten',
                  icon: Icon(Icons.mode_edit_rounded),
                  showSideBar: false,
                ),
              );
        },
        icon: Icon(Icons.edit),
      ),
      title: SelectableText(
        'Name: ${widget.profile.fullName}, tagID: ${widget.profile.tagID}',
      ),
      subtitle: Text(
        'Totaler Verbrauch: {profiletoStringAsFixed(3)} kWh',
      ),

      children: [UserDetails(profile: widget.profile)],
      onExpansionChanged: (value) => setState(() {
        isExpanded = value;
      }),
    );
  }
}
