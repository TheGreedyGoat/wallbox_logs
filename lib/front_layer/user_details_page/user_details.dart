import 'package:flutter/material.dart';
import 'package:wallbox_logs/mid_layer/data/user_data.dart';
import 'package:wallbox_logs/utility.dart';

class UserDetails extends StatelessWidget {
  final UserData profile;
  const UserDetails({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Table(
        children: [
          TableRow(
            decoration: BoxDecoration(
              border: BorderDirectional(bottom: BorderSide(width: 1)),
            ),
            children: [Text("Start"), Text("Ende"), Text("Verbrauch")],
          ),
          for (var process in profile.completedChargingProcesses)
            TableRow(
              decoration: BoxDecoration(
                color:
                    profile.completedChargingProcesses.indexOf(process) % 2 == 0
                    ? null
                    : Colors.blue[200],
              ),
              children: [
                Text(
                  '${Utility.niceDateString(process.startDate)}, ${Utility.niceTimeString(process.startDate)}',
                ),
                Text(
                  '${Utility.niceDateString(process.stopDate!)}, ${Utility.niceTimeString(process.stopDate!)}',
                ),
                Text('${process.powerUsageKiloWh.toStringAsFixed(2)} kWh'),
              ],
            ),
        ],
      ),
    );
  }
}
