import 'package:alerta_criminal/core/providers/user_notifier.dart';
import 'package:alerta_criminal/core/widgets/divisor_widget.dart';
import 'package:alerta_criminal/core/widgets/login_warning_widget.dart';
import 'package:alerta_criminal/features/profile/widgets/user_profile_label_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return user != null
        ? Padding(
      padding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        // spacing: 8,
        children: [
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                "Olá, ",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(width: 4,),
              Text(
                user.nickname,
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.edit))
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
            text: user.name,
          ),
          const DivisorWidget(),
          UserProfileLabelWidget(
            label: "EMAIL",
            text: user.email,
          ),
          const DivisorWidget(),
          UserProfileLabelWidget(
            label: "CPF",
            text: user.cpf,
          ),
          const DivisorWidget(),
          ElevatedButton(onPressed: () {}, child: const Text("Alterar senha"), style: ElevatedButton.styleFrom(shape: BeveledRectangleBorder()),)
        ],
      ),
    )
        : const LoginWarningWidget(canClose: false);
  }
}
