// lib/models/devices/air_conditioner.dart
import 'package:project/models/device_base.dart';

class AirConditioner extends DeviceBase {
  int temperature; // Current temperature setting

  AirConditioner({
    required String name,
    required bool status,
    required this.temperature,
  }) : super(name: name, status: status, type: "airconditioner");

  void setTemperature(int temp) {
    temperature = temp;
  }

  @override
  String getStatus() {
    return status ? '$temperature°C' : 'Off';
  }
}