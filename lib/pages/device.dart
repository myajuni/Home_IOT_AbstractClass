import 'package:flutter/material.dart';
import 'package:project/utils/extensions/color_ext.dart';
import 'package:project/models/device_base.dart';
import 'package:project/models/devices/washer.dart';
import 'package:project/models/devices/light.dart';
import 'package:project/models/devices/air_conditioner.dart';
import 'package:project/models/devices/tv.dart';

class DevicePage extends StatefulWidget {
  final DeviceBase device; // DeviceBase 객체로 변경

  const DevicePage({Key? key, required this.device}) : super(key: key);

  @override
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  late bool flag = widget.device.status;

  Widget _buildDeviceControlBase(List<Widget> content) {
    return SizedBox(
      height: 100,
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...content,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_left),
                ),
                const Text('1'),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_right),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAlertMessage() {
    return SizedBox(
      height: 60,
      child: Card(
        color: Colors.red.lighten(50),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
          child: Row(
            children: [
              const Icon(Icons.warning),
              const SizedBox(width: 16.0),
              const Text('이 기기는 점검이 필요해요'),
              Expanded(child: Container()),
              Text('확인 하기', style: TextStyle(color: Colors.blue.darken())),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeviceSpecificControls() {
    if (widget.device is Washer) {
      return _buildDeviceControlBase([
        const Text(
          '단계',
          style: TextStyle(fontSize: 16.0),
        ),
        Text('남은 시간: ${(widget.device as Washer).remainingTime}분'),
      ]);
    } else if (widget.device is AirConditioner) {
      return _buildDeviceControlBase([
        const Text(
          '온도 조절',
          style: TextStyle(fontSize: 16.0),
        ),
        Text('현재 온도: ${(widget.device as AirConditioner).temperature}°C'),
      ]);
    } else if (widget.device is Light) {
      return _buildDeviceControlBase([
        const Text(
          '밝기 설정',
          style: TextStyle(fontSize: 16.0),
        ),
        Text('현재 밝기: ${(widget.device as Light).brightness}%'),
      ]);
    } else if (widget.device is TV) {
      return _buildDeviceControlBase([
        const Text(
          '볼륨 설정',
          style: TextStyle(fontSize: 16.0),
        ),
        Text('현재 볼륨: ${(widget.device as TV).volume}'),
      ]);
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.device.name),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings))
        ],
      ),
      body: Column(
        children: [
          if (widget.device is Washer && (widget.device as Washer).remainingTime == 0)
            _buildAlertMessage(),
          Image(
            image: AssetImage('images/${widget.device.type.toLowerCase()}.png'),
            width: 80,
            height: 80,
            fit: BoxFit.contain,
          ),
          Row(
            children: [
              Expanded(child: Container()),
              Switch(
                value: flag,
                onChanged: (value) {
                  setState(() {
                    flag = value;
                    if (flag) {
                      widget.device.turnOn();
                    } else {
                      widget.device.turnOff();
                    }
                  });
                },
              ),
            ],
          ),
          _buildDeviceSpecificControls(),
        ],
      ),
    );
  }
}
