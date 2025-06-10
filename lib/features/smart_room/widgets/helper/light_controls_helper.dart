import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../controllers/controllerLight.dart';
import '../../../../services/smartroom_provider.dart';



class LightControlsHelper {
  static void listenLightStatus({
    required BuildContext context,
    required String roomId,
    required bool mounted,
    required void Function(bool isOn, int brightness) onStatusChanged,
  }) {
    final controller = context.read<ControllerLight>();
    final roomIntId = int.tryParse(roomId);
    if (roomIntId == null) return;

    controller.listenLightStatus(roomIntId, (status) {
      if (!mounted) return;
      final isOn = status.toUpperCase() == 'ON';
      final brightness = isOn ? 50 : 0;
      onStatusChanged(isOn, brightness);
    });
  }


  static void updateLightState({
    required BuildContext context,
    required String roomId,
    required bool isOn,
    required int brightness,
  }) {
    final controller = context.read<ControllerLight>();
    final provider = context.read<SmartRoomProvider>();
    final roomIntId = int.tryParse(roomId);
    final room = provider.getRoomById(roomId);

    controller.toggleLight(isOn, roomIntId!);
    controller.setLightBrightness(roomIntId, brightness);

    final updatedRoom = room.copyWith(
      lights: room.lights.copyWith(isOn: isOn, value: brightness),
    );
    provider.updateRoom(roomId, updatedRoom);
  }
}
