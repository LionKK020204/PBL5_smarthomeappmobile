import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/controllerLight.dart';
import '../../../core/core.dart';

class LightIntensitySliderCard extends StatefulWidget {
  const LightIntensitySliderCard({
    required this.room,
    super.key,
  });

  final SmartRoom room;

  @override
  State<LightIntensitySliderCard> createState() => _LightIntensitySliderCardState();
}

class _LightIntensitySliderCardState extends State<LightIntensitySliderCard> {
  late int lightIntensity;
  late bool isLightOn;

  @override
  void initState() {
    super.initState();
    lightIntensity =  widget.room.lights.value;
    isLightOn = widget.room.lights.isOn;

    final lightController = context.read<ControllerLight>(); // 👈 lấy từ Provider
    _getLightStatus(lightController);
  }

  Future<void> _getLightStatus(ControllerLight controller) async {
    controller.listenLightStatus(int.parse(widget.room.id), (status) {
      if (mounted) {
        setState(() {
          isLightOn = status.toUpperCase() == 'ON';
        });
      }
      controller.setLightBrightness(int.parse(widget.room.id) , lightIntensity);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<ControllerLight>(); // 👈 lấy từ Provider

    return SHCard(
      childrenPadding: const EdgeInsets.all(12),
      children: [
        // Switcher + % hiển thị
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text('Light intensity'),
              ),
            ),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '$lightIntensity%',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
            SHSwitcher(
              value: isLightOn,
              onChanged: (value) {
                setState(() {
                  isLightOn = value;
                  lightIntensity = value ? 50 : 0;
                });
                // Gửi tín hiệu đến ESP32
                controller.toggleLight(value, int.parse(widget.room.id));
                controller.setLightBrightness(int.parse(widget.room.id), lightIntensity);

              },
              icon: const Icon(SHIcons.lightBulbOutline),
            ),
          ],
        ),

        // Slider
        Row(
          children: [
            const Icon(SHIcons.lightMin),
            Expanded(
              child: Slider(
                value: lightIntensity.toDouble(),
                min: 0,
                max: 100,
                divisions: 100,
                label: lightIntensity.toString(),
                onChanged: (value) {
                  setState(() {
                    lightIntensity = value.toInt();
                    isLightOn = lightIntensity > 0;
                  });
                  // Gửi tín hiệu đến ESP32
                  controller.toggleLight(isLightOn, int.parse(widget.room.id));
                  controller.setLightBrightness(int.parse(widget.room.id), lightIntensity);
                },
              ),
            ),
            const Icon(SHIcons.lightMax),
          ],
        ),
      ],
    );
  }
}
