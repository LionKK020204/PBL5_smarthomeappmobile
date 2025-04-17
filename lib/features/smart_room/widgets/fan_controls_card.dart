import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../controllers/esp32_controllerFan.dart';

import '../../../core/core.dart';

class FanControlsCard extends StatelessWidget {
  const FanControlsCard({
    required this.room,
    super.key,
  });

  final SmartRoom room;

  @override
  Widget build(BuildContext context) {
    return SHCard(
      childrenPadding: const EdgeInsets.all(12),
      children: [
        _FanSwitcher(room: room),
        Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Icon(
                          SHIcons.waterDrop,
                          color: Colors.white38,
                          size: 20,
                        ),
                        Text(
                          'Air humidity',
                          style: GoogleFonts.montserrat(
                            fontSize: 10,
                            color: Colors.white60,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text('${room.airHumidity.toInt()}%'),
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        )
      ],
    );
  }
}


class _FanSwitcher extends StatefulWidget {
  const _FanSwitcher({
    required this.room,
  });

  final SmartRoom room;

  @override
  State<_FanSwitcher> createState() => _FanSwitcherState();
}

class _FanSwitcherState extends State<_FanSwitcher> {
  late bool isFanOn;
  late int FanIntensity;

  @override
  void initState() {
    super.initState();
    isFanOn = widget.room.fanCondition.isOn;
    FanIntensity = widget.room.fanCondition.value;
  }

  @override
  Widget build(BuildContext context) {
    final espController = ESP32ControllerFan(widget.room.esp32Ip);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Fan'),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: SHSwitcher(
                icon: const Icon(SHIcons.fan),
                value: isFanOn,
                onChanged: (value) {
                  setState(() {
                    isFanOn = value;
                    FanIntensity = value ? 50 : 0;
                  });
                  //espController.toggleFan(value, int.parse(widget.room.id));
                  //espController.setFanIntensity(FanIntensity, int.parse(widget.room.id));
                },
              ),
            ),
            const Spacer(),
            Text(
              '$FanIntensity˚',
              style: const TextStyle(fontSize: 28),
            ),
          ],
        ),
        Row(
          children: [
            Icon(SHIcons.fanMin),
            Expanded(
              child: Slider(
                value: FanIntensity.toDouble(),
                min: 0,
                max: 100,
                divisions: 100,
                label: FanIntensity.toString(),
                onChanged: (value) {
                  setState(() {
                    FanIntensity = value.toInt();
                    isFanOn = FanIntensity > 0;
                  });
                  //espController.toggleFan(isFanOn, int.parse(widget.room.id));
                  //espController.setFanIntensity(FanIntensity, int.parse(widget.room.id));
                },
              ),
            ),
            Icon(SHIcons.fanMax),
          ],
        )
      ],
    );
  }
}

