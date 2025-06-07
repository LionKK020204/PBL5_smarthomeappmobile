import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../controllers/controllerFan.dart';
import '../../../core/core.dart';
import '../../../globals/globals.dart';
import '../../../services/mqtt_service.dart';

class FanControlsCard extends StatefulWidget {
  const FanControlsCard({
    required this.room,
    super.key,
  });

  final SmartRoom room;

  @override
  State<FanControlsCard> createState() => _FanControlsCardState();

}

class _FanControlsCardState extends State<FanControlsCard> {
  late bool isFanOn;
  late int fanIntensity;

  @override
  void initState() {
    super.initState();
    isFanOn = widget.room.fanCondition.isOn;
    fanIntensity = widget.room.fanCondition.value;

    final controller = context.read<ControllerFan>();

    if (int.parse(widget.room.id) == 1 || int.parse(widget.room.id) == 3){
      _getFanStatus(controller);

    }
  }

  Future<void> _getFanStatus(ControllerFan controller) async {
    controller.listenFanStatus(int.parse(widget.room.id), (status) {
      if (mounted) {
        setState(() {
          isFanOn = status.toUpperCase() == 'ON';
        });
      }
      controller.setFanSpeed(int.parse(widget.room.id), fanIntensity);
    });
  }
  @override
  Widget build(BuildContext context) {
    final controller = context.read<ControllerFan>();

    return SHCard(
      childrenPadding: const EdgeInsets.all(12),
      children: [
        // Row: Title - Value - Switch
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
                setState(() {
                  isFanOn = value;
                  fanIntensity = value ? 50 : 0;
                });
                controller.toggleFan(value, int.parse(widget.room.id));
                controller.setFanSpeed(int.parse(widget.room.id), fanIntensity);
              },
            ),
          ],
        ),
        // Row: Slider
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
                  setState(() {
                    fanIntensity = value.toInt();
                    isFanOn = fanIntensity > 0;
                  });
                  controller.toggleFan(isFanOn, int.parse(widget.room.id));
                  controller.setFanSpeed(
                      int.parse(widget.room.id), fanIntensity);
                },
              ),
            ),
            Icon(SHIcons.fanMax),
          ],
        ),
      ],
    );


  }
}
// class _FanSwitcher extends StatefulWidget {
//   const _FanSwitcher({
//     required this.room,
//   });
//
//   final SmartRoom room;
//
//   @override
//   State<_FanSwitcher> createState() => _FanSwitcherState();
// }
//
// class _FanSwitcherState extends State<_FanSwitcher> {
//   late bool isFanOn;
//   late int fanIntensity;
//   late ControllerFan controller;
//
//   @override
//   void initState() {
//     super.initState();
//     isFanOn = widget.room.fanCondition.isOn;
//     fanIntensity = widget.room.fanCondition.value;
//
//     controller = context.read<ControllerFan>();
//
//     getFanStatus();
//   }
//
//   Future<void> getFanStatus() async {
//     controller.listenFanStatus(
//       int.parse(widget.room.id),
//           (status) {
//         if (mounted) {
//           setState(() {
//             isFanOn = status.toUpperCase() == 'ON';
//           });
//           controller.setFanSpeed(int.parse(widget.room.id), fanIntensity);
//         }
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = context.read<ControllerFan>();
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Row: Title - Value - Switch
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Flexible(
//               child: FittedBox(
//                 fit: BoxFit.scaleDown,
//                 child: Text('Fan speed'),
//               ),
//             ),
//             Flexible(
//               child: FittedBox(
//                 fit: BoxFit.scaleDown,
//                 child: Text(
//                   '$fanIntensity%',
//                   style: const TextStyle(fontSize: 20),
//                 ),
//               ),
//             ),
//             SHSwitcher(
//               icon: const Icon(SHIcons.fan),
//               value: isFanOn,
//               onChanged: (value) {
//                 setState(() {
//                   isFanOn = value;
//                   fanIntensity = value ? 50 : 0;
//                 });
//                 controller.toggleFan(value, int.parse(widget.room.id));
//                 controller.setFanSpeed(int.parse(widget.room.id), fanIntensity);
//               },
//             ),
//           ],
//         ),
//         // Row: Slider
//         Row(
//           children: [
//             Icon(SHIcons.fanMin),
//             Expanded(
//               child: Slider(
//                 value: fanIntensity.toDouble(),
//                 min: 0,
//                 max: 100,
//                 divisions: 100,
//                 label: fanIntensity.toString(),
//                 onChanged: (value) {
//                   setState(() {
//                     fanIntensity = value.toInt();
//                     isFanOn = fanIntensity > 0;
//                   });
//                   controller.toggleFan(isFanOn, int.parse(widget.room.id));
//                   controller.setFanSpeed(int.parse(widget.room.id), fanIntensity);
//                 },
//               ),
//             ),
//             Icon(SHIcons.fanMax),
//           ],
//         ),
//       ],
//     );
//   }
// }
