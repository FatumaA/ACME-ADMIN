import 'package:acme_admin/screens/Dashboard.dart';
import 'package:acme_admin/screens/Profile.dart';
import 'package:acme_admin/screens/ShowList.dart';
import 'package:acme_admin/screens/Ticket.dart';
import 'package:acme_admin/state/auth.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BasePage extends StatefulWidget {
  const BasePage({
    Key? key,
  }) : super(key: key);

  @override
  _BasePageState createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  PageController page = PageController();
  SideMenuController sideMenu = SideMenuController();
  @override
  void initState() {
    sideMenu.addListener((p0) {
      page.jumpToPage(p0);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final activeUser = context.read<AuthStateLocal>().activeUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('ACME Admin'),
        centerTitle: true,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SideMenu(
            controller: sideMenu,
            style: SideMenuStyle(
              itemOuterPadding: const EdgeInsets.symmetric(vertical: 8.0),
              displayMode: SideMenuDisplayMode.auto,
              hoverColor: Colors.blue[100],
              selectedColor: Colors.lightBlue,
              selectedTitleTextStyle: const TextStyle(color: Colors.white),
              selectedIconColor: Colors.white,
            ),
            footer: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'ACME Admin',
                style: TextStyle(fontSize: 15),
              ),
            ),
            items: [
              SideMenuItem(
                priority: 0,
                title: 'Dashboard',
                onTap: (page, _) {
                  sideMenu.changePage(page);
                },
                icon: const Icon(Icons.home),
              ),
              if (!(activeUser?.userMetadata!['user_role'] == 'customer'))
                SideMenuItem(
                  priority: 1,
                  title: activeUser?.userMetadata!['user_role'] == 'admin'
                      ? 'Agents'
                      : 'Customers',
                  onTap: (page, _) {
                    sideMenu.changePage(page);
                  },
                  icon: const Icon(Icons.people),
                ),
              if (!(activeUser?.userMetadata!['user_role'] == 'admin'))
                SideMenuItem(
                  priority: 2,
                  title: 'Tickets',
                  onTap: (page, _) {
                    sideMenu.changePage(page);
                  },
                  icon: const Icon(Icons.note),
                ),
              SideMenuItem(
                priority: 3,
                title: 'Profile',
                onTap: (page, _) {
                  sideMenu.changePage(page);
                },
                icon: const Icon(Icons.person),
              ),
              SideMenuItem(
                priority: 4,
                title: 'Logout',
                onTap: (_, __) async {
                  // await AuthStateLocal().logout();
                  // return context.read<AuthStateLocal>().activeSession;
                },
                icon: const Icon(Icons.logout),
              ),
            ],
          ),
          Expanded(
            child: PageView(
              controller: page,
              children: [
                Container(
                  color: Colors.white,
                  child: const Center(
                    child: Dashboard(),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: const Center(
                    child: ShowList(),
                  ),
                ),
                if (!(activeUser?.userMetadata!['user_role'] == 'admin'))
                  Container(
                    color: Colors.white,
                    child: const Center(
                      child: Ticket(),
                    ),
                  ),
                Container(
                  color: Colors.white,
                  child: const Profile(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
