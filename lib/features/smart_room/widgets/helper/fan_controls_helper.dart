import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../controllers/controllerFan.dart';
import '../../../../services/smartroom_provider.dart';

class FanControlsHelper {
  static void listenFanStatus({
    required State state,
    required String roomId,
    required void Function(bool isOn, int speed) onStatusChanged,
  }) {
    final controller = state.context.read<ControllerFan>();
    final roomIntId = int.tryParse(roomId);
    if (roomIntId == null) return;

    // Giới hạn phòng áp dụng
    if (roomIntId == 1 || roomIntId == 3) {
      controller.listenFanStatus(roomIntId, (status) {
        if (!state.mounted) return; // An toàn sau dispose
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
    if (roomIntId == null) return;

    final room = provider.getRoomById(roomId);
    final currentFan = room.fans;

    // Gửi lệnh khi thay đổi
    if (currentFan.isOn != isOn) {
      controller.toggleFan(isOn, roomIntId);
    }

    if (currentFan.value != value) {
      controller.setFanSpeed(roomIntId, value);
    }

    // Cập nhật provider
    final updatedRoom = room.copyWith(
      fans: currentFan.copyWith(isOn: isOn, value: value),
    );
    provider.updateRoom(roomId, updatedRoom);
  }
}
