import 'package:flutter/material.dart';
import 'package:project/pages/device.dart';
import 'package:project/models/devices/washer.dart';
import 'package:project/models/devices/light.dart';
import 'package:project/models/devices/air_conditioner.dart';
import 'package:project/models/devices/tv.dart';
import 'package:project/models/device_base.dart';
import 'package:project/utils/extensions/color_ext.dart';

class _DeviceCard extends StatefulWidget {
  final DeviceBase device;

  const _DeviceCard(this.device);

  @override
  State<_DeviceCard> createState() => _DeviceCardState();
}

class _DeviceCardState extends State<_DeviceCard> {
  late bool flag = widget.device.status;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: flag ? Colors.white : Colors.black.lighten(50),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => DevicePage(device: widget.device),
            ),
          );
        },
        child: SizedBox(
          width: 140,
          height: 140,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image(
                      image: AssetImage('images/${widget.device.type.toLowerCase()}.png'),
                      fit: BoxFit.cover,
                      width: 80,
                      height: 80,
                      colorBlendMode: BlendMode.multiply,
                      color:
                          flag ? Colors.transparent : Colors.black.lighten(50),
                    ),
                    Text(widget.device.name),
                    Text(widget.device.getStatus()),
                  ],
                ),
                Positioned(
                  top: 0.0,
                  right: 0.0,
                  child: SizedBox(
                    width: 45,
                    height: 30,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: Switch(
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
                        value: flag,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<DeviceBase> devices = [
    Washer(name: "세탁기", status: true, remainingTime: 45),
    Light(name: "조명", status: true, brightness: 80),
    AirConditioner(name: "에어컨", status: false, temperature: 22),
    TV(name: "TV", status: true, volume: 15),
  ];

  Widget _buildRoutineButton({required String label}) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(30))),
          width: 60,
          height: 60,
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              label,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  TextEditingController tec = TextEditingController();
  List<String> routines = [];

  Widget _buildRoutineSection() {
    return Column(
      children: [
        _buildSectionHeader([
          const Text('스마트 모드'),
        ]),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextButton(
                  onPressed: () {},
                  child: _buildRoutineButton(label: '취침 모드')),
              const SizedBox(width: 16),
              TextButton(
                  onPressed: () {},
                  child: _buildRoutineButton(label: '절약 모드')),
              const SizedBox(width: 16),
              ...routines.map(
                (e) => TextButton(
                    onPressed: () {},
                    child: _buildRoutineButton(label: '$e 모드')),
              ),
              TextButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('모드 추가'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(controller: tec),
                              ],
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    tec.clear();
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('닫기')),
                              TextButton(
                                  onPressed: () {
                                    setState(() {
                                      routines.add(tec.value.text);
                                    });
                                    tec.clear();
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('추가')),
                            ],
                          );
                        });
                  },
                  child: const Column(
                    children: [Icon(Icons.add), Text('추가')],
                  ))
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey.withAlpha(73)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24.0, 16.0, 0, 16.0),
        child: Row(
          children: children,
        ),
      ),
    );
  }

  Widget _buildDeviceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader([const Text('거실')]),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Wrap(
            direction: Axis.horizontal,
            spacing: 12.0,
            runSpacing: 12.0,
            children: devices
                .map((device) => _DeviceCard(device))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Row(
        children: [
          const Text('우리집'),
          IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_drop_down))
        ],
      ),
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
      ],
    );
  }

  Widget _buildMarketingZone() {
    return Container(
      height: 160.0,
      decoration: const BoxDecoration(color: Colors.grey),
      child: const Center(
        child: Text('Marketing zone'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        _buildAppBar(),
        _buildRoutineSection(),
        _buildDeviceSection(),
      ]),
    );
  }
}
