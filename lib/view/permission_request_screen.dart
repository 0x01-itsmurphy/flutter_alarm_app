import 'package:flutter/material.dart';
import 'package:flutter_alarm_app/provider/permission_provider.dart';
import 'package:provider/provider.dart';

class PermissionRequestScreen extends StatelessWidget {
  const PermissionRequestScreen({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Consumer<PermissionProvider>(
      builder: (context, provider, _) {
        if (provider.isGrantedAll()) {
          if (provider.isIgnoreBatteryGranted()) {
            return child;
          }
        }
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                    'Please allow all the permission to trigger the alarm.'),
                Text('permission ${provider.isGrantedAll()}'),
                Text('permission ${provider.isIgnoreBatteryGranted()}'),
                // Text('permission ${provider.isStorageGranted()}'),
                TextButton(
                    onPressed: provider.requestSystemAlertWindow,
                    child: Text(provider.isGrantedAll() == true
                        ? 'System Alert Granted'
                        : 'Grant System Alert')),
                TextButton(
                    onPressed: provider.ignoreBatteryOptimizations,
                    child: Text(
                      provider.isIgnoreBatteryGranted() == true
                          ? 'Ignore Battery Granted'
                          : "Grant Ignore Battery",
                    )),
              ],
            ),
          ),
        );
      },
    );
  }
}
