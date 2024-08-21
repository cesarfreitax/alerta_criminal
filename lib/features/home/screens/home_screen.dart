import 'package:alerta_criminal/core/di/dependency_injection.dart';
import 'package:alerta_criminal/core/utils/string_util.dart';
import 'package:alerta_criminal/features/home/widgets/map_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getStrings(context).map),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: DependencyInjection.authService.signOut,
          )
        ],
      ),
      body: const MapWidget(),
    );
  }
}
