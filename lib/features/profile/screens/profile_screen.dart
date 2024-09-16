import 'package:alerta_criminal/core/providers/user_notifier.dart';
import 'package:alerta_criminal/core/utils/string_util.dart';
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.start,
              // spacing: 8,
              children: [
                const SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    Row(
                      children: [
                        Text(
                          getStrings(context).hello,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          user.nickname,
                          style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontWeight: FontWeight.bold),
                        ),
                        IconButton(onPressed: () {}, icon: const Icon(Icons.edit))
                      ],
                    ),
                    Text(
                      getStrings(context).nicknameInfo,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.w100, color: Theme.of(context).colorScheme.primary.withOpacity(0.6)),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                const DivisorWidget(),
                UserProfileLabelWidget(
                  label: getStrings(context).nameProfileLabel,
                  text: user.name,
                ),
                const DivisorWidget(),
                UserProfileLabelWidget(
                  label: getStrings(context).emailProfileLabel,
                  text: user.email,
                ),
                const DivisorWidget(),
                UserProfileLabelWidget(
                  label: getStrings(context).cpfProfileLabel,
                  text: user.cpf,
                ),
                const DivisorWidget(),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    textAlign: TextAlign.center,
                    getStrings(context).changePassword,
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          )
        : const LoginWarningWidget(canClose: false);
  }
}
