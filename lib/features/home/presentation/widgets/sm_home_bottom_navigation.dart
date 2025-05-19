import 'package:flutter/material.dart';

import '../../../../controllers/controllerDoor.dart';
import '../../../../core/core.dart';

class SmHomeBottomNavigationBar extends StatefulWidget {
  const SmHomeBottomNavigationBar({
    super.key,
    required this.roomSelectorNotifier,
    required this.controllerDoor,
  });

  final ValueNotifier<int> roomSelectorNotifier;
  final ControllerDoor controllerDoor;

  @override
  State<SmHomeBottomNavigationBar> createState() => _SmHomeBottomNavigationBarState();

}

class _SmHomeBottomNavigationBarState extends State<SmHomeBottomNavigationBar> {
  bool isDoorOpen = false;

  @override
  void initState() {
    super.initState();
    widget.controllerDoor.listenDoorStatus((status) {
      setState(() {
        isDoorOpen = status.trim().toUpperCase() == 'OPEN';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ValueListenableBuilder<int>(
        valueListenable: widget.roomSelectorNotifier,
        builder: (_, value, child) => AnimatedOpacity(
          duration: kThemeAnimationDuration,
          opacity: value != -1 ? 0 : 1,
          child: AnimatedContainer(
            duration: kThemeAnimationDuration,
            transform: Matrix4.translationValues(0, value != -1 ? -30.0 : 0.0, 0),
            child: BottomNavigationBar(
              selectedItemColor: SHColors.textColor,
              unselectedItemColor: SHColors.textColor,
              onTap: (index) {
                if (index == 0) {
                  final shouldOpen = !isDoorOpen;
                  widget.controllerDoor.toggleDoor(shouldOpen);
                } else if (index == 1) {
                  //MAIN ...
                } else if (index == 2) {
                  //SETTINGS ...
                }
              },
              items: [
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      isDoorOpen ? SHIcons.unlock : SHIcons.lock,
                      color: SHColors.textColor,
                    ),
                  ),
                  label: isDoorOpen ? 'LOCK' : 'UNLOCK',
                ),
                const BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(SHIcons.home, color: SHColors.textColor),
                  ),
                  label: 'MAIN',
                ),
                const BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(SHIcons.settings, color: SHColors.textColor),
                  ),
                  label: 'SETTINGS',
                ),
              ],
            ),
          ),
        ),
      ),

        // child: BottomNavigationBar(
        //   selectedItemColor: SHColors.textColor,
        //   unselectedItemColor: SHColors.textColor,
        //   items: const [
        //     BottomNavigationBarItem(
        //
        //       icon: Padding(
        //         padding: EdgeInsets.all(8),
        //         child: Icon(SHIcons.lock, color: SHColors.textColor,),
        //       ),
        //       label: 'UNLOCK',
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Padding(
        //         padding: EdgeInsets.all(8),
        //         child: Icon(SHIcons.home, color: SHColors.textColor,),
        //       ),
        //       label: 'MAIN' ,
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Padding(
        //         padding: EdgeInsets.all(8),
        //         child: Icon(SHIcons.settings, color: SHColors.textColor,),
        //       ),
        //       label: 'SETTINGS',
        //     ),
        //   ],
        // ),
      
    );
  }
}
