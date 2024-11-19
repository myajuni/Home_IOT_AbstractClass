// lib/models/devices/tv.dart
import 'package:project/models/device_base.dart';

class TV extends DeviceBase {
  int volume; // Current volume level

  TV({
    required String name,
    required bool status,
    required this.volume,
  }) : super(name: name, status: status, type: "TV");

  void setVolume(int level) {
    volume = level;
  }

  @override
  String getStatus() {
    return status ? 'On (볼륨: $volume)' : 'Off';
  }
}