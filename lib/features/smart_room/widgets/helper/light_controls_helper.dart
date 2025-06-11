import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../controllers/controllerLight.dart';
import '../../../../services/smartroom_provider.dart';

class LightControlsHelper {
  static void listenLightStatus({
    required State state,
    required String roomId,
    required void Function(bool isOn, int brightness) onStatusChanged,
  }) {
    final controller = state.context.read<ControllerLight>();
    final roomIntId = int.tryParse(roomId);
    if (roomIntId == null) return;

    controller.listenLightStatus(roomIntId, (status) {
      if (!state.mounted) return; // ✅ kiểm tra an toàn sau dispose

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
    if (roomIntId == null) return;

    final currentRoom = provider.getRoomById(roomId);
    final currentLight = currentRoom.lights;

    // Chỉ toggle nếu trạng thái ON/OFF thay đổi
    if (currentLight.isOn != isOn) {
      controller.toggleLight(isOn, roomIntId);
    }

    // Chỉ thay đổi độ sáng nếu brightness thay đổi
    if (currentLight.value != brightness) {
      controller.setLightBrightness(roomIntId, brightness);
    }

    // Cập nhật UI provider
    final updatedRoom = currentRoom.copyWith(
      lights: currentLight.copyWith(isOn: isOn, value: brightness),
    );
    provider.updateRoom(roomId, updatedRoom);
  }

}
