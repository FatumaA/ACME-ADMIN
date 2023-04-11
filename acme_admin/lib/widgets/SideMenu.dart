import 'package:flutter/material.dart';
import 'package:acme_admin/widgets/MenuInfo.dart';

class SideMenu extends StatefulWidget {
  // final Widget? child;
  const SideMenu({Key? key}) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    final isMobileView = MediaQuery.of(context).size.width < 700;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      width: !isMobileView
          ? (MediaQuery.of(context).size.width / 3)
          : (MediaQuery.of(context).size.width / 10),
      child: const MenuInfo(),
    );
  }
}
