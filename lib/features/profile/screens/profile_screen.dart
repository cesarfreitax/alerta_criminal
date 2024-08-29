import 'package:alerta_criminal/core/di/dependency_injection.dart';
import 'package:alerta_criminal/core/providers/user_notifier.dart';
import 'package:alerta_criminal/core/widgets/divisor_widget.dart';
import 'package:alerta_criminal/features/profile/widgets/user_profile_label_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _userDataUseCase = DependencyInjection.userDataUseCase;

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {


    final user = ref.watch(userProvider);

    return user != null ? FutureBuilder(future: _userDataUseCase.getUserData(user.uid), builder: (context, snapshot) {

      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return const Center(child: Text('Error loading user data.'));
      } else if (!snapshot.hasData || snapshot.data == null) {
        return const Center(child: Text('User data not found.'));
      }

      final userData = snapshot.data;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Text(
                  "Olá, ",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  userData!.nickname,
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                IconButton(onPressed: () {}, icon: const Icon(Icons.edit))
              ],
            ),
            Opacity(
              opacity: 0.8,
              child: Text(
                "Esse é o nome que ficará visível para outros usuários.",
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.w100,
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            const DivisorWidget(),
            UserProfileLabelWidget(
              label: "NAME",
              text: userData.name,
            ),
            const DivisorWidget(),
            UserProfileLabelWidget(
              label: "EMAIL",
              text: userData.email,
            ),
            const DivisorWidget(),
            UserProfileLabelWidget(
              label: "CPF",
              text: userData.cpf,
            ),
          ],
        ),
      );
    }) : const Center(child: Text(("No user logged in.")),);
  }
}
