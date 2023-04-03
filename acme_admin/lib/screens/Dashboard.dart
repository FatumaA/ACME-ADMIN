import 'package:acme_admin/constants/constants.dart';
import 'package:acme_admin/state/auth.dart';
import 'package:acme_admin/widgets/SideMenu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // final activeUser = supaClient.auth.currentUser;
  bool activeUserIsAdmin = false;
  bool activeUserIsAgent = false;
  bool activeUserIsCustomer = false;

  @override
  void initState() {
    super.initState();
    checkUserRole();
  }

  Future<void> checkUserRole() async {
    // await for for the widget to mount
    await Future.delayed(Duration.zero);

    final activeUser = supaClient.auth.currentUser;
    if (activeUser?.userMetadata?['user_role'] == 'admin') {
      activeUserIsAdmin = true;
    } else if (activeUser?.userMetadata?['user_role'] == 'agent') {
      activeUserIsAgent = true;
    } else {
      activeUserIsCustomer = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('Admin Dashboard'),
      drawer: const SideMenu(),
    );
  }
}
