import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../globals/globals.dart';
import '../../../core/core.dart';

class TemperatureAirHumidityCard extends StatelessWidget {
  const TemperatureAirHumidityCard({
    required this.room,
    super.key,
  });
  final SmartRoom room;

  @override
  Widget build(BuildContext context) {
    final env = context.watch<GlobalEnvironmentData>();

    return SHCard(
      childrenPadding: const EdgeInsets.all(12),
      children: [
        Row(
          children: [
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Icon(
                      SHIcons.thermostat,
                      color: Colors.white38,
                      size: 20,
                    ),
                    Text(
                      'Temperature',
                      style: GoogleFonts.montserrat(
                        fontSize: 15,
                        color: Colors.white60,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text('${env.temperature.toInt()}°'),
                  ],
                ),
              ),
            ),
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Icon(
                      SHIcons.waterDrop,
                      color: Colors.white38,
                      size: 20,
                    ),
                    Text(
                      'Air humidity',
                      style: GoogleFonts.montserrat(
                        fontSize: 15,
                        color: Colors.white60,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text('${env.humidity.toInt()}%'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
