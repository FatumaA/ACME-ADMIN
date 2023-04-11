import 'package:acme_admin/constants/constants.dart';
import 'package:acme_admin/state/auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MenuInfo extends StatefulWidget {
  const MenuInfo({Key? key}) : super(key: key);

  @override
  State<MenuInfo> createState() => _MenuInfoState();
}

class _MenuInfoState extends State<MenuInfo> {
  bool activeUserIsAdmin = false,
      activeUserIsAgent = false,
      activeUserIsCustomer = false;
  @override
  void initState() {
    // super.initState();
    final userRole = checkUserRole(context);
    setActiveUserBool(userRole);
    super.initState();
  }

  bool setActiveUserBool(userRole) {
    if (userRole == 'admin') {
      return activeUserIsAdmin = true;
    } else if (userRole == 'agent') {
      return activeUserIsAgent = true;
    } else {
      return activeUserIsCustomer = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobileView = MediaQuery.of(context).size.width < 700;
    final activeUser = context.read<AuthStateLocal>().activeUser;
    return ListView(
      children: [
        Stack(
          children: [
            if (!isMobileView)
              UserAccountsDrawerHeader(
                currentAccountPicture:
                    Image.network('https://picsum.photos/300'),
                accountName: Text(
                  activeUser?.userMetadata!['name'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                accountEmail: Text(
                  activeUser?.email as String,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                // onDetailsPressed: () {
                //   context.go('dashboard/profile');
                // },
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(15),
                  ),
                ),
              ),
            if (isMobileView)
              Container(
                alignment: Alignment.topRight,
                padding: const EdgeInsets.all(10),
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    context.pop(context);
                  },
                  color: Colors.white,
                ),
              )
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        ListTile(
          title: !isMobileView ? const Text('Home') : const SizedBox.shrink(),
          leading: const Icon(Icons.home),
          onTap: () {
            context.go('/dashboard');
          },
        ),
        // const SizedBox(
        //   height: 16,
        // ),
        // if (!activeUserIsCustomer)
        //   ListTile(
        //     title: Text(activeUserIsAdmin ? 'Agents' : 'Customers'),
        //     leading: const Icon(Icons.people),
        //     onTap: () {
        //       context.go(activeUserIsAdmin ? '/agents' : '/customers');
        //     },
        //   ),
        // const SizedBox(
        //   // height: 100,
        //   height: 16,
        // ),
        // ListTile(
        //   title: const Text('Profile'),
        //   leading: const Icon(Icons.person),
        //   onTap: () {
        //     context.go('/profile');
        //   },
        // ),
        // const SizedBox(
        //   height: 16,
        // ),
        // ListTile(
        //   title: const Text(
        //     'Log out',
        //     style: TextStyle(color: Colors.red),
        //   ),
        //   leading: const Icon(
        //     Icons.logout,
        //     color: Colors.red,
        //   ),
        //   onTap: () {
        //     context.read<AuthStateLocal>().logout();
        //   },
        // ),
      ],
    );
  }
}
