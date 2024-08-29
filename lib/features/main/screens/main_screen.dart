import 'package:alerta_criminal/core/providers/user_notifier.dart';
import 'package:alerta_criminal/core/utils/auth_util.dart';
import 'package:alerta_criminal/features/home/screens/home_screen.dart';
import 'package:alerta_criminal/features/profile/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../notifications/screens/notifications_screen.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() {
    return _MainScreenState();
  }
}

class _MainScreenState extends ConsumerState<MainScreen> {
  var currentScreenIndex = 0;

  static const List<Widget> screenOptions = <Widget>[
    HomeScreen(),
    NotificationsScreen(),
    ProfileScreen(),
  ];

  void onItemTapped(int index) {
    setState(() {
      currentScreenIndex = index;
    });
  }

  bool isProfileScreen() => currentScreenIndex == 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: currentScreenIndex == 0
          ? null
          : AppBar(
              title:
                  Text(currentScreenIndex == 1 ? "Notifications" : "Profile"),
              actions: [
                if (isProfileScreen() && ref.watch(userProvider) != null)
                  const IconButton(onPressed: logout, icon: Icon(Icons.logout_rounded))
              ],
            ),
      body: IndexedStack(
        index: currentScreenIndex,
        children: screenOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
        currentIndex: currentScreenIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        onTap: onItemTapped,
      ),
    );
  }
}
