// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
//
// import '../../../controllers/controllerFan.dart';
// import '../../../core/core.dart';
// import '../../../globals/globals.dart';
// import '../../../services/mqtt_service.dart';
// import '../../../services/smartroom_provider.dart';
//
// class FanControlsCard extends StatefulWidget {
//   const FanControlsCard({required this.room, super.key});
//
//   final SmartRoom room;
//
//   @override
//   State<FanControlsCard> createState() => _FanControlsCardState();
// }
//
// class _FanControlsCardState extends State<FanControlsCard> {
//   late bool isFanOn;
//   late int fanIntensity;
//   Timer? _debounceTimer;
//   bool? _previousFanState;
//   int? _previousFanSpeed;
//
//   @override
//   void initState() {
//     super.initState();
//
//     final provider = context.read<SmartRoomProvider>();
//     final currentRoom = provider.getRoomById(widget.room.id);
//
//     isFanOn = currentRoom.fans.isOn;
//     fanIntensity = currentRoom.fans.value;
//
//     //isFanOn = widget.room.fans.isOn;
//     //fanIntensity = widget.room.fans.value;
//
//     final controller = context.read<ControllerFan>();
//
//     if (int.parse(widget.room.id) == 1 || int.parse(widget.room.id) == 3) {
//       _getFanStatus(controller);
//     }
//     // Lưu giá trị ban đầu để kiểm tra sau này
//     _previousFanState = isFanOn;
//     _previousFanSpeed = fanIntensity;
//   }
//
//   Future<void> _getFanStatus(ControllerFan controller) async {
//     controller.listenFanStatus(int.parse(widget.room.id), (status) {
//       if (mounted) {
//         final newState = status.toUpperCase() == 'ON';
//         if (isFanOn != newState) {
//           setState(() {
//             isFanOn = newState;
//             _previousFanState = newState;
//           });
//         }
//       }
//     });
//   }
//
//   void _sendFanCommandIfChanged(ControllerFan controller) {
//     final roomId = int.parse(widget.room.id);
//     if (_previousFanState != isFanOn) {
//       controller.toggleFan(isFanOn, roomId);
//       _previousFanState = isFanOn;
//     }
//     if (_previousFanSpeed != fanIntensity) {
//       controller.setFanSpeed(roomId, fanIntensity);
//       _previousFanSpeed = fanIntensity;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     //final controller = context.read<ControllerFan>();
//     return Consumer<SmartRoomProvider>(
//       builder: (context, provider, child) {
//         final room = provider.getRoomById(widget.room.id);
//         final controller = context.read<ControllerFan>();
//
//         return SHCard(
//           childrenPadding: const EdgeInsets.all(12),
//           children: [
//             // Row: Title - Value - Switch
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Flexible(
//                   child: FittedBox(
//                     fit: BoxFit.scaleDown,
//                     child: Text(' Fan                 '),
//                   ),
//                 ),
//                 Flexible(
//                   child: FittedBox(
//                     fit: BoxFit.scaleDown,
//                     child: Text(
//                       '${room.fans.value}%',
//                       style: const TextStyle(fontSize: 20),
//                     ),
//                   ),
//                 ),
//                 SHSwitcher(
//                   icon: const Icon(SHIcons.fan),
//                   value: room.fans.isOn,
//                   onChanged: (value) {
//                     setState(() {
//                       isFanOn = value;
//                       fanIntensity = value ? 50 : 0;
//                     });
//
//                     // Gửi lệnh nếu cần
//                     _sendFanCommandIfChanged(controller);
//
//                     // Cập nhật vào Provider
//                     final provider = context.read<SmartRoomProvider>();
//                     final room = provider.getRoomById(widget.room.id);
//                     final updatedRoom = room.copyWith(
//                       fans: room.fans.copyWith(
//                         isOn: isFanOn,
//                         value: fanIntensity,
//                       ),
//                     );
//                     provider.updateRoom(widget.room.id, updatedRoom);
//                   },
//                 ),
//               ],
//             ),
//             // Row: Slider
//             Row(
//               children: [
//                 Icon(SHIcons.fanMin),
//                 Expanded(
//                   child: Slider(
//                     value: fanIntensity.toDouble(),
//                     min: 0,
//                     max: 100,
//                     divisions: 100,
//                     label: fanIntensity.toString(),
//                     onChanged: (value) {
//                       setState(() {
//                         fanIntensity = value.toInt();
//                         isFanOn = fanIntensity > 0;
//                       });
//
//                       _debounceTimer?.cancel();
//                       _debounceTimer = Timer(
//                         const Duration(milliseconds: 1000),
//                         () {
//                           _sendFanCommandIfChanged(controller);
//
//                           // cập nhật provider
//                           final provider = context.read<SmartRoomProvider>();
//                           final room = provider.getRoomById(widget.room.id);
//                           final updatedRoom = room.copyWith(
//                             fans: room.fans.copyWith(
//                               isOn: isFanOn,
//                               value: fanIntensity,
//                             ),
//                           );
//                           provider.updateRoom(widget.room.id, updatedRoom);
//                         },
//                       );
//                     },
//                   ),
//                 ),
//                 Icon(SHIcons.fanMax),
//               ],
//             ),
//           ],
//         );
//       },
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
import '../../../controllers/controllerFan.dart';
import '../../../globals/globals.dart';
import '../../../services/smartroom_provider.dart';
import '../../../core/core.dart';

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
  void initState() {
    super.initState();

    final provider = context.read<SmartRoomProvider>();
    final currentRoom = provider.getRoomById(widget.room.id);

    _previousFanState = currentRoom.fans.isOn;
    _previousFanSpeed = currentRoom.fans.value;

    final controller = context.read<ControllerFan>();
    _listenFanStatus(controller);

  }

  void _listenFanStatus(ControllerFan controller) {
    final roomId = int.parse(widget.room.id);
    if (roomId == 1 || roomId == 3) {
      controller.listenFanStatus(roomId, (status) {
        if (!mounted) return;

        final provider = context.read<SmartRoomProvider>();
        final currentRoom = provider.getRoomById(widget.room.id);

        final newState = status.toUpperCase() == 'ON';
        final newSpeed = newState ? 50 : 0;

        if (_previousFanState != newState) {
          final updatedRoom = currentRoom.copyWith(
            fans: currentRoom.fans.copyWith(
                isOn: newState,
                value: newSpeed
            ),
          );
          provider.updateRoom(widget.room.id, updatedRoom);
          _previousFanState = newState;
          _previousFanSpeed = newSpeed;

        }
      });
    }
  }


  void _updateFanState({
    required bool isOn,
    required int value,
  }) {
    final controller = context.read<ControllerFan>();
    final provider = context.read<SmartRoomProvider>();
    final roomId = int.parse(widget.room.id);

    if (_previousFanState != isOn) {
      controller.toggleFan(isOn, roomId);
      _previousFanState = isOn;
    }
    if (_previousFanSpeed != value) {
      controller.setFanSpeed(roomId, value);
      _previousFanSpeed = value;
    }

    final room = provider.getRoomById(widget.room.id);
    final updatedRoom = room.copyWith(
      fans: room.fans.copyWith(isOn: isOn, value: value),
    );
    provider.updateRoom(widget.room.id, updatedRoom);
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
