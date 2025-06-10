import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../controllers/controllerLight.dart';
import '../../../../core/core.dart';
import '../../../../services/smartroom_provider.dart';
import '../helper/light_controls_helper.dart';

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
  Timer? _debounceTimer;
  bool? _previousLightState;
  int? _previousBrightness;

  @override
  void initState() {
    super.initState();
    final provider = context.read<SmartRoomProvider>();
    final currentRoom = provider.getRoomById(widget.room.id);
    _previousLightState = currentRoom.lights.isOn;
    _previousBrightness = currentRoom.lights.value;

    LightControlsHelper.listenLightStatus(
      context: context,
      roomId: widget.room.id,
      mounted: mounted,
      onStatusChanged: (newState, newBrightness) {
        final provider = context.read<SmartRoomProvider>();
        final currentRoom = provider.getRoomById(widget.room.id);

        if (_previousLightState != newState) {
          final updatedRoom = currentRoom.copyWith(
            lights: currentRoom.lights.copyWith(isOn: newState, value: newBrightness),
          );
          provider.updateRoom(widget.room.id, updatedRoom);
          _previousLightState = newState;
          _previousBrightness = newBrightness;
        }
      },
    );
  }


  void _updateLightState({required bool isOn, required int value}) {
    if (_previousLightState == isOn && _previousBrightness == value) return;

    LightControlsHelper.updateLightState(
      context: context,
      roomId: widget.room.id,
      isOn: isOn,
      brightness: value,
    );

    _previousLightState = isOn;
    _previousBrightness = value;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SmartRoomProvider>(
      builder: (context, provider, child) {
        final room = provider.getRoomById(widget.room.id);
        final isLightOn = room.lights.isOn;
        final brightness = room.lights.value;

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
                      '$brightness%',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                SHSwitcher(
                  icon: const Icon(SHIcons.lightBulbOutline),
                  value: isLightOn,
                  onChanged: (value) {
                    final newBrightness = value ? 50 : 0;
                    _updateLightState(isOn: value, value: newBrightness);
                  },
                ),
              ],
            ),
            Row(
              children: [
                const Icon(SHIcons.lightMin),
                Expanded(
                  child: Slider(
                    value: brightness.toDouble(),
                    min: 0,
                    max: 100,
                    divisions: 100,
                    label: brightness.toString(),
                    onChanged: (value) {
                      final int newBrightness = value.toInt();
                      final bool newState = newBrightness > 0;

                      _debounceTimer?.cancel();
                      _debounceTimer = Timer(
                        const Duration(milliseconds: 1000),
                            () => _updateLightState(
                          isOn: newState,
                          value: newBrightness,
                        ),
                      );
                    },
                  ),
                ),
                const Icon(SHIcons.lightMax),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
