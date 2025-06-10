// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../../../controllers/controllerLight.dart';
// import '../../../core/core.dart';
// import 'dart:async';
//
// import '../../../services/smartroom_provider.dart';
//
// class LightIntensitySliderCard extends StatefulWidget {
//   const LightIntensitySliderCard({
//     required this.room,
//     super.key,
//   });
//
//   final SmartRoom room;
//
//   @override
//   State<LightIntensitySliderCard> createState() => _LightIntensitySliderCardState();
// }
//
// class _LightIntensitySliderCardState extends State<LightIntensitySliderCard> {
//   late int lightIntensity;
//   late bool isLightOn;
//   Timer? _debounceTimer;
//   bool? _previousLightState;
//   int? _previousBrightness;
//
//   @override
//   void initState() {
//     super.initState();
//
//     final provider = context.read<SmartRoomProvider>();
//     final currentRoom = provider.getRoomById(widget.room.id);
//
//     lightIntensity = currentRoom.lights.value;
//     isLightOn = currentRoom.lights.isOn;
//
//     //lightIntensity = widget.room.lights.value;
//     //isLightOn = widget.room.lights.isOn;
//
//     final lightController = context.read<ControllerLight>();
//     _getLightStatus(lightController);
//
//     // Lưu giá trị ban đầu để kiểm tra sau này
//     _previousLightState = isLightOn;
//     _previousBrightness = lightIntensity;
//   }
//
//   Future<void> _getLightStatus(ControllerLight controller) async {
//     controller.listenLightStatus(int.parse(widget.room.id), (status) {
//       if (mounted) {
//         final newState = status.toUpperCase() == 'ON';
//         if (isLightOn != newState) {
//           setState(() {
//             isLightOn = newState;
//             _previousLightState = newState;
//           });
//         }
//       }
//     });
//   }
//
//   void _sendLightCommandIfChanged(ControllerLight controller) {
//     final roomId = int.parse(widget.room.id);
//
//     if (_previousLightState != isLightOn) {
//       controller.toggleLight(isLightOn, roomId);
//       _previousLightState = isLightOn;
//     }
//
//     if (_previousBrightness != lightIntensity) {
//       controller.setLightBrightness(roomId, lightIntensity);
//       _previousBrightness = lightIntensity;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = context.read<ControllerLight>();
//
//     return SHCard(
//       childrenPadding: const EdgeInsets.all(12),
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Flexible(
//               child: FittedBox(
//                 fit: BoxFit.scaleDown,
//                 child: Text('Light intensity'),
//               ),
//             ),
//             Flexible(
//               child: FittedBox(
//                 fit: BoxFit.scaleDown,
//                 child: Text(
//                   '$lightIntensity%',
//                   style: const TextStyle(fontSize: 20),
//                 ),
//               ),
//             ),
//             SHSwitcher(
//               value: isLightOn,
//               onChanged: (value) {
//                 setState(() {
//                   isLightOn = value;
//                   lightIntensity = value ? 50 : 0;
//                 });
//
//                 // Gửi lệnh nếu cần
//                 _sendLightCommandIfChanged(controller);
//
//                 // Cập nhật vào Provider
//                 final provider = context.read<SmartRoomProvider>();
//                 final room = provider.getRoomById(widget.room.id);
//                 final updatedRoom = room.copyWith(
//                   lights: room.lights.copyWith(
//                       isOn: isLightOn,
//                       value: lightIntensity
//                   ),
//                 );
//                 provider.updateRoom(widget.room.id, updatedRoom);
//               },
//               icon: const Icon(SHIcons.lightBulbOutline),
//             ),
//           ],
//         ),
//         Row(
//           children: [
//             const Icon(SHIcons.lightMin),
//             Expanded(
//               child: Slider(
//                 value: lightIntensity.toDouble(),
//                 min: 0,
//                 max: 100,
//                 divisions: 100,
//                 label: lightIntensity.toString(),
//                 onChanged: (value) {
//                   setState(() {
//                     lightIntensity = value.toInt();
//                     isLightOn = lightIntensity > 0;
//                   });
//
//                   // Debounce để hạn chế gửi liên tục
//                   _debounceTimer?.cancel();
//                   _debounceTimer = Timer(const Duration(milliseconds: 1000), () {
//                     _sendLightCommandIfChanged(controller);
//
//                     // Cập nhật vào Provider
//                     final provider = context.read<SmartRoomProvider>();
//                     final room = provider.getRoomById(widget.room.id);
//                     final updatedRoom = room.copyWith(
//                       lights: room.lights.copyWith(
//                           isOn: isLightOn,
//                           value: lightIntensity
//                       ),
//                     );
//                     provider.updateRoom(widget.room.id, updatedRoom);
//                   });
//                 },
//               ),
//             ),
//             const Icon(SHIcons.lightMax),
//           ],
//         ),
//       ],
//     );
//   }
//
//   @override
//   void dispose() {
//     _debounceTimer?.cancel();
//     super.dispose();
//   }
// }


import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/controllerLight.dart';
import '../../../core/core.dart';
import '../../../services/smartroom_provider.dart';

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

    final controller = context.read<ControllerLight>();
    _listenLightStatus(controller);
  }

  void _listenLightStatus(ControllerLight controller) {
    controller.listenLightStatus(int.parse(widget.room.id), (status) {
      if (!mounted) return;

      final provider = context.read<SmartRoomProvider>();
      final room = provider.getRoomById(widget.room.id);

      final newState = status.toUpperCase() == 'ON';
      final newBrightness = newState ? 50 : 0;

      // cập nhật nếu thay đổi
      if (_previousLightState != newState) {
        final updatedRoom = room.copyWith(
          lights: room.lights.copyWith(
              isOn: newState,
              value: newBrightness
          ),
        );
        provider.updateRoom(widget.room.id, updatedRoom);
        _previousLightState = newState;
        _previousBrightness = newBrightness;
      }
    });
  }

  void _updateLightState({
    required bool isOn,
    required int brightness,
  }) {
    final controller = context.read<ControllerLight>();
    final provider = context.read<SmartRoomProvider>();
    final roomId = int.parse(widget.room.id);

    if (_previousLightState != isOn) {
      controller.toggleLight(isOn, roomId);
      _previousLightState = isOn;
    }

    if (_previousBrightness != brightness) {
      controller.setLightBrightness(roomId, brightness);
      _previousBrightness = brightness;
    }

    final room = provider.getRoomById(widget.room.id);
    final updatedRoom = room.copyWith(
      lights: room.lights.copyWith(
        isOn: isOn,
        value: brightness,
      ),
    );
    provider.updateRoom(widget.room.id, updatedRoom);
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
                    _updateLightState(isOn: value, brightness: newBrightness);
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
                          brightness: newBrightness,
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
