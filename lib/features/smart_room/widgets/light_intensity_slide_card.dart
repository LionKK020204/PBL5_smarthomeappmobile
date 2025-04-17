import 'package:flutter/material.dart';

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
  late SmartRoom room;
  late int lightIntensity;
  late bool isLightOn;

  @override
  void initState() {
    super.initState();
    room = widget.room;
    lightIntensity = room.lights.value;
    isLightOn = room.lights.isOn;
  }

  @override
  Widget build(BuildContext context) {
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
                // ex: espController.toggleLight(value, room.id);
                //     espController.setLightIntensity(lightIntensity, room.id);
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
                  // ex: espController.toggleLight(isLightOn, room.id);
                  //     espController.setLightIntensity(lightIntensity, room.id);
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
