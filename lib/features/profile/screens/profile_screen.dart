import 'package:alerta_criminal/core/di/dependency_injection.dart';
import 'package:alerta_criminal/core/providers/user_notifier.dart';
import 'package:alerta_criminal/core/utils/string_util.dart';
import 'package:alerta_criminal/core/widgets/divisor_widget.dart';
import 'package:alerta_criminal/core/widgets/login_warning_widget.dart';
import 'package:alerta_criminal/features/profile/screens/change_nickname_screen.dart';
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                const SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                          firebaseAuthInstance.currentUser!.displayName!,
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          onPressed: () async {
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                                    builder: (ctx) => ChangeNicknameScreen()));

                          },
                          icon: const Icon(Icons.edit),
                        )
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      getStrings(context).nicknameInfo,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.w100,
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.6)),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                const SizedBox(height: 8),
                const DivisorWidget(),
                const SizedBox(height: 8),
                UserProfileLabelWidget(
                  label: getStrings(context).nameProfileLabel,
                  text: user.name,
                ),
                const SizedBox(height: 8),
                const DivisorWidget(),
                const SizedBox(height: 8),
                UserProfileLabelWidget(
                  label: getStrings(context).emailProfileLabel,
                  text: user.email,
                ),
                const SizedBox(height: 8),
                const DivisorWidget(),
                const SizedBox(height: 8),
                UserProfileLabelWidget(
                  label: getStrings(context).cpfProfileLabel,
                  text: user.cpf,
                ),
                const SizedBox(height: 8),
                const DivisorWidget(),
                const SizedBox(height: 8),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    textAlign: TextAlign.center,
                    getStrings(context).changePassword,
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          )
        : const Center(child: LoginWarningWidget(canClose: false));
  }
}
