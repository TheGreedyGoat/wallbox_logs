import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallbox_logs/front_layer/widgets/user_details.dart';
import 'package:wallbox_logs/mid_layer/models/user_master/user_master_data.dart';
import 'package:wallbox_logs/riverpod/providers.dart';

/// Displays the main informations about he given [profile].
/// Can be expanded for an overview over corresponing transactions
class UserListTileConsumer extends ConsumerStatefulWidget {
  /// The source for the displayed data
  final UserMasterData profile;

  /// Displays the main informations about he given [profile].
  /// Can be expanded for an overview over corresponing transactions
  /// - [profile]: The source for the displayed data
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

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: false,
      leading: Icon(
        isExpanded ? Icons.arrow_drop_down : Icons.arrow_right_sharp,
      ),
      trailing: IconButton(
        onPressed: () => ref
            .read(widgetTreeProvider.notifier)
            .setUserEditingPage(widget.profile),
        icon: Icon(Icons.edit),
      ),
      title: SelectableText(
        'Name: ${widget.profile.fullName}, tagID: ${widget.profile.tagID}',
      ),
      subtitle: Text(
        'Totaler Verbrauch: {profiletoStringAsFixed(3)} kWh',
      ),

      children: [UserTransactionsWidget(user: widget.profile)],
      onExpansionChanged: (value) => setState(() {
        isExpanded = value;
      }),
    );
  }
}
