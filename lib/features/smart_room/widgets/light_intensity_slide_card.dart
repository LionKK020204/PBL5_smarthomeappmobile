import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/controllerLight.dart';
import '../../../core/core.dart';
import 'dart:async';

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
  Timer? _debounceTimer;
  bool? _previousLightState;
  int? _previousBrightness;

  @override
  void initState() {
    super.initState();
    lightIntensity = widget.room.lights.value;
    isLightOn = widget.room.lights.isOn;

    final lightController = context.read<ControllerLight>();
    _getLightStatus(lightController);

    // Lưu giá trị ban đầu để kiểm tra sau này
    _previousLightState = isLightOn;
    _previousBrightness = lightIntensity;
  }

  Future<void> _getLightStatus(ControllerLight controller) async {
    controller.listenLightStatus(int.parse(widget.room.id), (status) {
      if (mounted) {
        final newState = status.toUpperCase() == 'ON';
        if (isLightOn != newState) {
          setState(() {
            isLightOn = newState;
            _previousLightState = newState;
          });
        }
      }
    });
  }

  void _sendLightCommandIfChanged(ControllerLight controller) {
    final roomId = int.parse(widget.room.id);

    if (_previousLightState != isLightOn) {
      controller.toggleLight(isLightOn, roomId);
      _previousLightState = isLightOn;
    }

    if (_previousBrightness != lightIntensity) {
      controller.setLightBrightness(roomId, lightIntensity);
      _previousBrightness = lightIntensity;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<ControllerLight>();

    return SHCard(
      childrenPadding: const EdgeInsets.all(12),
      children: [
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

                // Gửi lệnh nếu cần
                _sendLightCommandIfChanged(controller);
              },
              icon: const Icon(SHIcons.lightBulbOutline),
            ),
          ],
        ),
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

                  // Debounce để hạn chế gửi liên tục
                  _debounceTimer?.cancel();
                  _debounceTimer = Timer(const Duration(milliseconds: 1000), () {
                    _sendLightCommandIfChanged(controller);
                  });
                },
              ),
            ),
            const Icon(SHIcons.lightMax),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
