// lib/models/devices/washer.dart
import 'package:project/models/device_base.dart';

class Washer extends DeviceBase {
  int remainingTime; // Minutes left in the current cycle

  Washer({
    required String name,
    required bool status,
    required this.remainingTime,
  }) : super(name: name, status: status, type: "Washer");

  @override
  String getStatus() {
    return status
        ? 'On ($remainingTime 남음)'
        : 'Off';
  }
}
