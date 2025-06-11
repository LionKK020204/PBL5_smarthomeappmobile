import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../controllers/controllerFan.dart';
import '../../../../../controllers/controllerLight.dart';
import '../../../../../services/smartroom_provider.dart';


class RoomDeviceControllerHelper {
  static void listenLightStatus({
    required BuildContext context,
    required String roomId,
    required ValueChanged<bool> onStatusChanged,
  }) {
    final controller = context.read<ControllerLight>();
    controller.listenLightStatus(int.parse(roomId), (status) {
      final newValue = status.toUpperCase() == 'ON';
      onStatusChanged(newValue);

      final provider = context.read<SmartRoomProvider>();
      final room = provider.getRoomById(roomId);
      final updatedRoom = room.copyWith(
        lights: room.lights.copyWith(
          isOn: newValue,
          value: newValue ? 50 : 0,
        ),
      );
      provider.updateRoom(roomId, updatedRoom);
    });
  }

  static void listenFanStatus({
    required BuildContext context,
    required String roomId,
    required ValueChanged<bool> onStatusChanged,
  }) {
    final controller = context.read<ControllerFan>();
    controller.listenFanStatus(int.parse(roomId), (status) {
      final newValue = status.toUpperCase() == 'ON';
      onStatusChanged(newValue);

      final provider = context.read<SmartRoomProvider>();
      final room = provider.getRoomById(roomId);
      final updatedRoom = room.copyWith(
        fans: room.fans.copyWith(
          isOn: newValue,
          value: newValue ? 50 : 0,
        ),
      );
      provider.updateRoom(roomId, updatedRoom);
    });
  }

  static void updateLightState({
    required BuildContext context,
    required String roomId,
    required bool value,
  }) {
    final provider = context.read<SmartRoomProvider>();
    final currentRoom = provider.getRoomById(roomId);
    final lightController = context.read<ControllerLight>();

    lightController.toggleLight(value, int.parse(roomId));
    lightController.setLightBrightness(int.parse(roomId), value ? 50 : 0);

    final updatedRoom = currentRoom.copyWith(
      lights: currentRoom.lights.copyWith(
        isOn: value,
        value: value ? 50 : 0,
      ),
    );
    provider.updateRoom(roomId, updatedRoom);
  }

  static void updateFanState({
    required BuildContext context,
    required String roomId,
    required bool value,
  }) {
    final provider = context.read<SmartRoomProvider>();
    final currentRoom = provider.getRoomById(roomId);
    final fanController = context.read<ControllerFan>();

    fanController.toggleFan(value, int.parse(roomId));
    fanController.setFanSpeed(int.parse(roomId), value ? 50 : 0);

    final updatedRoom = currentRoom.copyWith(
      fans: currentRoom.fans.copyWith(
        isOn: value,
        value: value ? 50 : 0,
      ),
    );
    provider.updateRoom(roomId, updatedRoom);
  }
}
