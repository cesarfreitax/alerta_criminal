import 'package:alerta_criminal/core/providers/user_notifier.dart';
import 'package:alerta_criminal/core/utils/auth_util.dart';
import 'package:alerta_criminal/data/models/user_model.dart';
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
  UserModel? user;
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
    user = ref.watch(userProvider);
    if (user != null) {

    }
    return Scaffold(
      appBar: currentScreenIndex == 0 ? null : appBar(),
      body: IndexedStack(
        index: currentScreenIndex,
        children: screenOptions,
      ),
      bottomNavigationBar: bottomNavBar(context),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: screenTitle(),
      actions: [
        if (isProfileScreen() && user != null) logoutBtn(),
      ],
    );
  }

  IconButton logoutBtn() => const IconButton(onPressed: logout, icon: Icon(Icons.logout_rounded));

  Text screenTitle() => Text(currentScreenIndex == 1 ? "Notifications" : "Profile");

  BottomNavigationBar bottomNavBar(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        homeNavItem(),
        notificationsNavItem(),
        profileNavItem(),
      ],
      currentIndex: currentScreenIndex,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      onTap: onItemTapped,
    );
  }

  BottomNavigationBarItem homeNavItem() {
    return const BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      );
  }

  BottomNavigationBarItem notificationsNavItem() {
    return const BottomNavigationBarItem(
        icon: Icon(Icons.notifications),
        label: 'Notifications',
      );
  }

  BottomNavigationBarItem profileNavItem() {
    return const BottomNavigationBarItem(
        icon: Icon(Icons.account_circle),
        label: 'Profile',
      );
  }
}
