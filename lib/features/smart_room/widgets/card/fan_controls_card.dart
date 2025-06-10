import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../controllers/controllerFan.dart';
import '../../../../globals/globals.dart';
import '../../../../services/smartroom_provider.dart';
import '../../../../core/core.dart';
import '../helper/fan_controls_helper.dart';

class FanControlsCard extends StatefulWidget {
  const FanControlsCard({required this.room, super.key});
  final SmartRoom room;

  @override
  State<FanControlsCard> createState() => _FanControlsCardState();
}

class _FanControlsCardState extends State<FanControlsCard> {
  Timer? _debounceTimer;
  bool? _previousFanState;
  int? _previousFanSpeed;

  @override
  @override
  void initState() {
    super.initState();

    final provider = context.read<SmartRoomProvider>();
    final currentRoom = provider.getRoomById(widget.room.id);

    _previousFanState = currentRoom.fans.isOn;
    _previousFanSpeed = currentRoom.fans.value;

    FanControlsHelper.listenFanStatus(
      context: context,
      roomId: widget.room.id,
      mounted: mounted,
      onStatusChanged: (newState, newSpeed) {
        final provider = context.read<SmartRoomProvider>();
        final currentRoom = provider.getRoomById(widget.room.id);

        if (_previousFanState != newState) {
          final updatedRoom = currentRoom.copyWith(
            fans: currentRoom.fans.copyWith(isOn: newState, value: newSpeed),
          );
          provider.updateRoom(widget.room.id, updatedRoom);
          _previousFanState = newState;
          _previousFanSpeed = newSpeed;
        }
      },
    );
  }


  void _updateFanState({
    required bool isOn,
    required int value,
  }) {
    if (_previousFanState == isOn && _previousFanSpeed == value) return;

    FanControlsHelper.updateFanState(
      context: context,
      roomId: widget.room.id,
      isOn: isOn,
      value: value,
    );

    _previousFanState = isOn;
    _previousFanSpeed = value;
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<SmartRoomProvider>(
      builder: (context, provider, child) {
        final room = provider.getRoomById(widget.room.id);
        final isFanOn = room.fans.isOn;
        final fanIntensity = room.fans.value;

        return SHCard(
          childrenPadding: const EdgeInsets.all(12),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(' Fan                 '),
                  ),
                ),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '$fanIntensity%',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                SHSwitcher(
                  icon: const Icon(SHIcons.fan),
                  value: isFanOn,
                  onChanged: (value) {
                    final newSpeed = value ? 50 : 0;
                    _updateFanState(isOn: value, value: newSpeed);
                  },
                ),
              ],
            ),
            Row(
              children: [
                Icon(SHIcons.fanMin),
                Expanded(
                  child: Slider(
                    value: fanIntensity.toDouble(),
                    min: 0,
                    max: 100,
                    divisions: 100,
                    label: fanIntensity.toString(),
                    onChanged: (value) {
                      final int newSpeed = value.toInt();
                      final bool newState = newSpeed > 0;

                      _debounceTimer?.cancel();
                      _debounceTimer = Timer(
                        const Duration(milliseconds: 1000),
                            () => _updateFanState(
                          isOn: newState,
                          value: newSpeed,
                        ),
                      );
                    },
                  ),
                ),
                Icon(SHIcons.fanMax),
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
