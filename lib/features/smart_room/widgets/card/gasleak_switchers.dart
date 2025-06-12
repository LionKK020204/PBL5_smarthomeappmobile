import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../controllers/controllerGasleak.dart';
import '../../../../globals/globals.dart';
import '../../../../core/core.dart';

class GasLeakInfoCard extends StatefulWidget {
  const GasLeakInfoCard({
    required this.room,
    super.key,
  });

  final SmartRoom room;

  @override
  State<GasLeakInfoCard> createState() => _GasLeakInfoCardState();
}

class _GasLeakInfoCardState extends State<GasLeakInfoCard> {
  //bool _hasShownWarning = false;

  @override
  Widget build(BuildContext context) {
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
              Icons.warning,
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
                Consumer<ControllerGasLeak>(
                  builder: (context, controller, child) {
                    final gas = controller.gasValue;

                    return Text(
                      '${gas.toStringAsFixed(1)} ppm',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: gas > 1200 ? Colors.red : Colors.white,
                      ),
                    );
                  },
                ),

              ],
            )
          ],
        ),
      ],
    );
  }
}
