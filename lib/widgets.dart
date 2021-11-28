import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ponygold_courier/globals.dart' as globals;

class BottomBar extends StatefulWidget {
  final active;
  BottomBar({Key? key, this.active}) : super(key: key);

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int active = 0;

  onItemTab(int index) {
    if (index != widget.active) {
      setState(() {
        active = index;
      });

      switch (index) {
        case 0:
          Get.offAllNamed("/");
          break;
        case 1:
          Get.offAllNamed(
            "/current-orders",
          );
          break;
        case 2:
          Get.offAllNamed("/history-orders");
          break;
        case 3:
          Get.offAllNamed(
            "/profile",
          );
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: onItemTab,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory,
                color: widget.active == 0 ? globals.blue : globals.grey3),
            label: '',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.list_alt,
                  color: widget.active == 1 ? globals.blue : globals.grey3),
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.pending_actions,
                  color: widget.active == 2 ? globals.blue : globals.grey3),
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: widget.active == 3 ? globals.blue : globals.grey3,
              ),
              label: ''),
        ]);
  }
}
