import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../globals/globals.dart';
import '../../../core/core.dart';

class GasLeakInfoCard extends StatelessWidget {
  const GasLeakInfoCard({
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
        const Text(
          'Gas Sensor',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            const Icon(
              Icons.warning, // bạn có thể thay bằng SHIcons.gasSensor nếu có
              color: Colors.orangeAccent,
              size: 28,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Gas concentration',
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    color: Colors.white60,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                // Text(
                //    '${env.gasLevel.toStringAsFixed(1)} ppm',
                //   style: const TextStyle(
                //     fontSize: 24,
                //     fontWeight: FontWeight.bold,
                //     color: Colors.white,
                //   ),
                // ),
              ],
            )
          ],
        ),
      ],
    );
  }
}
