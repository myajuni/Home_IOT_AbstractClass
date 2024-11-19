abstract class DeviceBase {
  String name;
  bool status; // true for "on", false for "off"
  String type; // e.g., "Washer", "Light", etc.

  DeviceBase({required this.name, required this.status, required this.type});

  void turnOn() {
    status = true;
  }

  void turnOff() {
    status = false;
  }

  String getStatus() {
    return status ? 'On' : 'Off';
  }
}