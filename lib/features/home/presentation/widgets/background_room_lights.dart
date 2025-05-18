import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ui_common/ui_common.dart';

import '../../../../controllers/controllerFan.dart';
import '../../../../controllers/controllerLight.dart';
import '../../../../core/core.dart';
import '../../../../globals/globals.dart';

class BackgroundRoomCard extends StatefulWidget {
  const BackgroundRoomCard({
    required this.room,
    required this.translation,
    super.key,
  });

  final SmartRoom room;
  final double translation;

  @override
  State<BackgroundRoomCard> createState() => _BackgroundRoomCardState();
}

class _BackgroundRoomCardState extends State<BackgroundRoomCard> {
  late bool isLightOn;
  late bool isFanOn;

  @override
  void initState() {
    super.initState();

    isLightOn = widget.room.lights.isOn;
    isFanOn = widget.room.fanCondition.isOn;

    final lightController = context.read<ControllerLight>();
    final fanController = context.read<ControllerFan>();

    _listenLightStatus(lightController);
    _listenFanStatus(fanController);
  }

  void _listenLightStatus(ControllerLight controller) {
    controller.listenLightStatus(int.parse(widget.room.id), (status) {
      if (mounted) {
        setState(() {
          isLightOn = status.toUpperCase() == 'ON';
        });
      }
    });
  }

  void _listenFanStatus(ControllerFan controller) {
    controller.listenFanStatus(int.parse(widget.room.id), (status) {
      if (mounted) {
        setState(() {
          isFanOn = status.toUpperCase() == 'ON';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final env = context.watch<GlobalEnvironmentData>();
    final lightController = context.read<ControllerLight>();
    final fanController = context.read<ControllerFan>();

    return Transform(
      transform: Matrix4.translationValues(0, 80 * widget.translation, 0),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: SHColors.trackColor,
          borderRadius: BorderRadius.all(Radius.circular(12)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 12,
              offset: Offset(-7, 7),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _RoomInfoRow(
              icon: const Icon(SHIcons.thermostat),
              label: const Text('Temperature'),
              data: '${env.temperature.toInt()}°',
            ),
            height4,
            _RoomInfoRow(
              icon: const Icon(SHIcons.waterDrop),
              label: const Text('Air Humidity'),
              data: '${env.humidity.toInt()}%',
            ),
            height4,
            const _RoomInfoRow(
              icon: Icon(SHIcons.timer),
              label: Text('Timer'),
              data: null,
            ),
            height12,
            const SHDivider(),
            Padding(
              padding: EdgeInsets.all(12.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _DeviceIconSwitcher(
                    icon: const Icon(SHIcons.lightBulbOutline),
                    label: const Text('Lights'),
                    value: isLightOn,
                    onTap: (value) {
                      setState(() {
                        isLightOn = value;
                      });
                      lightController.toggleLight(value, int.parse(widget.room.id));
                      lightController.setLightBrightness(int.parse(widget.room.id), value ? 50 : 0);
                    },
                  ),
                  _DeviceIconSwitcher(
                    icon: const Icon(SHIcons.fan),
                    label: const Text('Fan'),
                    value: isFanOn,
                    onTap: (value) {
                      setState(() {
                        isFanOn = value;
                      });
                      fanController.toggleFan(value, int.parse(widget.room.id));
                      fanController.setFanSpeed(int.parse(widget.room.id), value ? 50 : 0);
                    },
                  ),
                  _DeviceIconSwitcher(
                    onTap: (value) {},
                    icon: const Icon(SHIcons.music),
                    label: const Text('Music'),
                    value: widget.room.musicInfo.isOn,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeviceIconSwitcher extends StatelessWidget {
  const _DeviceIconSwitcher({
    required this.onTap,
    required this.label,
    required this.icon,
    required this.value,
  });

  final Text label;
  final Icon icon;
  final bool value;
  final ValueChanged<bool> onTap;

  @override
  Widget build(BuildContext context) {
    final color = value ? SHColors.selectedColor : SHColors.textColor;
    return InkWell(
      onTap: () => onTap(!value),
      child: Column(
        children: [
          IconTheme(
            data: IconThemeData(color: color, size: 24.sp),
            child: icon,
          ),
          const SizedBox(height: 4),
          DefaultTextStyle(
            style: context.bodySmall.copyWith(color: color),
            child: label,
          ),
          Text(
            value ? 'ON' : 'OFF',
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _RoomInfoRow extends StatelessWidget {
  const _RoomInfoRow({
    required this.icon,
    required this.label,
    required this.data,
  });

  final Icon icon;
  final Text label;
  final String? data;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        width32,
        IconTheme(
          data: context.iconTheme.copyWith(size: 18.sp),
          child: icon,
        ),
        width4,
        Expanded(
          child: DefaultTextStyle(
            style: context.bodySmall.copyWith(
              color: data == null ? context.textColor.withOpacity(.6) : null,
            ),
            child: label,
          ),
        ),
        if (data != null)
          Text(
            data!,
            style: GoogleFonts.montserrat(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
            ),
          )
        else
          Row(
            children: [
              const BlueLightDot(),
              width4,
              Text(
                'OFF',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w800,
                  fontSize: 12.sp,
                  color: SHColors.textColor.withOpacity(.6),
                ),
              ),
            ],
          ),
        width32,
      ],
    );
  }
}
