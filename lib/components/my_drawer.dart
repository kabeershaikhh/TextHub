import 'package:flutter/material.dart';

import '../services/auth/auth_service.dart';
import '../pages/settings_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  void logout(){
    final auth= AuthService();
    auth.signOut();
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      child: Column(

        children: [
          // App  Icon
          DrawerHeader(
              child: Center(
                child: Image.asset(
                  "assets/logo.png",
                  height: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
              )
          ),

          // home list tile
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: ListTile(
              title: const Text("HOME"),
              leading: const Icon(Icons.home),
              onTap: (){
                Navigator.pop(context);
              },
            ),
          ),

          //settings tile
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: ListTile(
              title: const Text("SETTINGS"),
              leading: const Icon(Icons.settings),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage()));
              },
            ),
          ),

          // to put logout at the bottom of the screen
          // const Spacer(),

          // logout tile
          Padding(
            padding: const EdgeInsets.only(left: 20.0, bottom: 10),
            child: ListTile(
              title: const Text("LOGOUT"),
              leading: const Icon(Icons.logout),
              onTap: logout,
            ),
          ),
        ],
      ),
    );
  }
}
