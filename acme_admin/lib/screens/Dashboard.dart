import 'package:acme_admin/widgets/MenuInfo.dart';
import 'package:acme_admin/widgets/SideMenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: const [
          // Expanded(child: SideMenu()),
          // SideMenu(),
          Text('Dashboard home widget'),
          // Expanded(child: Text('Dashboard home widget')),
        ],
      ),
    );
  }
}
