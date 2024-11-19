// lib/models/devices/light.dart
import 'package:project/models/device_base.dart';

class Light extends DeviceBase {
  int brightness; // Brightness level (0-100)

  Light({
    required String name,
    required bool status,
    required this.brightness,
  }) : super(name: name, status: status, type: "Light");

  void setBrightness(int level) {
    brightness = level;
  }

  @override
  String getStatus() {
    return status ? 'On (밝기: $brightness%)' : 'Off';
  }
}