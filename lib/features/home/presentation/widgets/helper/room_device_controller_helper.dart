// Refactored room_device_controller_helper.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../controllers/controllerFan.dart';
import '../../../../../controllers/controllerLight.dart';
import '../../../../../core/shared/domain/entities/smart_room.dart';
import '../../../../../services/smartroom_provider.dart';

class RoomDeviceControllerHelper {
  static void _listenStatus({
    required State state,
    required String roomId,
    required ValueChanged<bool> onStatusChanged,
    required bool Function(String) statusMapper,
    required SmartRoom Function(SmartRoom, bool) updateRoomFn,
    required void Function(int, void Function(String)) controllerListener,
  }) {
    final controller = state.context.read<SmartRoomProvider>();
    controllerListener(
      int.parse(roomId),
          (status) {
        final isOn = statusMapper(status);
        onStatusChanged(isOn);

        final room = controller.getRoomById(roomId);
        final updatedRoom = updateRoomFn(room, isOn);
        controller.updateRoom(roomId, updatedRoom);
      },
    );
  }

  static void listenLightStatus({
    required State state,
    required String roomId,
    required ValueChanged<bool> onStatusChanged,
  }) {
    _listenStatus(
      state: state,
      roomId: roomId,
      onStatusChanged: onStatusChanged,
      statusMapper: (status) => status.toUpperCase() == 'ON',
      updateRoomFn: (room, isOn) => room.copyWith(
        lights: room.lights.copyWith(isOn: isOn, value: isOn ? 50 : 0),
      ),
      controllerListener: state.context.read<ControllerLight>().listenLightStatus,
    );
  }

  static void listenFanStatus({
    required State state,
    required String roomId,
    required ValueChanged<bool> onStatusChanged,
  }) {
    _listenStatus(
      state: state,
      roomId: roomId,
      onStatusChanged: onStatusChanged,
      statusMapper: (status) => status.toUpperCase() == 'ON',
      updateRoomFn: (room, isOn) => room.copyWith(
        fans: room.fans.copyWith(isOn: isOn, value: isOn ? 50 : 0),
      ),
      controllerListener: state.context.read<ControllerFan>().listenFanStatus,
    );
  }

  static void _updateState({
    required BuildContext context,
    required String roomId,
    required bool value,
    required void Function(int, bool) toggle,
    required void Function(int, int) setValue,
    required SmartRoom Function(SmartRoom) updateRoomFn,
  }) {
    final provider = context.read<SmartRoomProvider>();
    final currentRoom = provider.getRoomById(roomId);

    toggle(int.parse(roomId), value);
    setValue(int.parse(roomId), value ? 50 : 0);

    provider.updateRoom(roomId, updateRoomFn(currentRoom));
  }

  static void updateLightState({
    required BuildContext context,
    required String roomId,
    required bool value,
  }) {
    _updateState(
      context: context,
      roomId: roomId,
      value: value,
      toggle: context.read<ControllerLight>().toggleLight,
      setValue: context.read<ControllerLight>().setLightBrightness,
      updateRoomFn: (room) => room.copyWith(
        lights: room.lights.copyWith(isOn: value, value: value ? 50 : 0),
      ),
    );
  }

  static void updateFanState({
    required BuildContext context,
    required String roomId,
    required bool value,
  }) {
    _updateState(
      context: context,
      roomId: roomId,
      value: value,
      toggle: context.read<ControllerFan>().toggleFan,
      setValue: context.read<ControllerFan>().setFanSpeed,
      updateRoomFn: (room) => room.copyWith(
        fans: room.fans.copyWith(isOn: value, value: value ? 50 : 0),
      ),
    );
  }
}
