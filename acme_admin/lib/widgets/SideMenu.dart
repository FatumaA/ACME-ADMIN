import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  late bool _isDrawerOpen;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _isDrawerOpen = MediaQuery.of(context).size.width > 601;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Row(
            children: [
              UserAccountsDrawerHeader(
                currentAccountPicture:
                    Image.network('https://picsum.photos/300'),
                accountName: Text('ddd'),
                accountEmail: Text('email'),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  // shape: BoxShape.circle,
                ),
              ),
              ListTile(
                title: const Icon(Icons.close),
                onTap: () => context.pop(),
              ),
            ],
          ),
          ListTile(
            title: Text('Item 1'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Item 2'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Item 3'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
