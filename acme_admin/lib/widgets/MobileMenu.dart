import 'package:acme_admin/widgets/MenuInfo.dart';
import 'package:flutter/material.dart';

class MobileMenu extends StatelessWidget {
  const MobileMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return const Drawer(
      child: MenuInfo(),
    );
  }
}
