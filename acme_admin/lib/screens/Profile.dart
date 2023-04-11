import 'package:acme_admin/widgets/SideMenu.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: const [
          // Expanded(child: SideMenu()),
          Expanded(child: Text('Profile home widget')),
        ],
      ),
    );
  }
}
