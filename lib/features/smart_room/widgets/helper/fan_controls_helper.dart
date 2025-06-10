import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../controllers/controllerFan.dart';
import '../../../../services/smartroom_provider.dart';



class FanControlsHelper {
  static void listenFanStatus({
    required BuildContext context,
    required String roomId,
    required bool mounted,
    required void Function(bool isOn, int speed) onStatusChanged,
  }) {
    final controller = context.read<ControllerFan>();
    final roomIntId = int.tryParse(roomId);
    if (roomIntId == 1 || roomIntId == 3) {
      controller.listenFanStatus(roomIntId!, (status) {
        if (!mounted) return;
        final isOn = status.toUpperCase() == 'ON';
        final speed = isOn ? 50 : 0;
        onStatusChanged(isOn, speed);
      });
    }
  }

  static void updateFanState({
    required BuildContext context,
    required String roomId,
    required bool isOn,
    required int value,
  }) {
    final controller = context.read<ControllerFan>();
    final provider = context.read<SmartRoomProvider>();
    final roomIntId = int.tryParse(roomId);
    final room = provider.getRoomById(roomId);

    controller.toggleFan(isOn, roomIntId!);
    controller.setFanSpeed(roomIntId, value);

    final updatedRoom = room.copyWith(
      fans: room.fans.copyWith(isOn: isOn, value: value),
    );
    provider.updateRoom(roomId, updatedRoom);
  }
}
