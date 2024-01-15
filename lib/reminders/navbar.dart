import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});
  @override
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        selectedItemColor: Colors.green[500],
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.solidBell,
              size: 20,
            ),
            label: 'Zakaži novi',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.list,
              size: 20,
            ),
            label: 'Lista',
          ),
        ],
        backgroundColor: Colors.black38,
        onTap: (int idx) {
          switch (idx) {
            case 0:
              break;
            case 1:
              break;
          }
        });
  }
}
