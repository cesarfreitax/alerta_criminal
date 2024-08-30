import 'package:alerta_criminal/core/di/dependency_injection.dart';
import 'package:alerta_criminal/core/providers/user_notifier.dart';
import 'package:alerta_criminal/core/utils/auth_util.dart';
import 'package:alerta_criminal/core/utils/message_util.dart';
import 'package:alerta_criminal/core/utils/string_util.dart';
import 'package:alerta_criminal/core/widgets/divisor_widget.dart';
import 'package:alerta_criminal/features/profile/widgets/user_profile_label_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

final _userDataUseCase = DependencyInjection.userDataUseCase;

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return user != null
        ? FutureBuilder(
            future: _userDataUseCase.getUserData(user.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox();
              } if (snapshot.hasError) {
                showSnackBarError(getStrings(context).couldNotGetUserDataErrorMessage, context);
              } else if (!snapshot.hasData || snapshot.data == null) {
                showSnackBarError(getStrings(context).userNotFoundMessage, context);
              }

              final userData = snapshot.data;

              return Skeletonizer(
                enabled: !snapshot.hasData,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
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
                            userData!.nickname,
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                              onPressed: () {}, icon: const Icon(Icons.edit))
                        ],
                      ),
                      const SizedBox(height: 8),
                      Opacity(
                        opacity: 0.8,
                        child: Text(
                          "Esse é o nome que ficará visível para outros usuários.",
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                fontWeight: FontWeight.w100,
                              ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const SizedBox(
                        height: 16,
                      ),
                      const SizedBox(height: 8),
                      const DivisorWidget(),
                      const SizedBox(height: 8),
                      UserProfileLabelWidget(
                        label: "NAME",
                        text: userData.name,
                      ),
                      const SizedBox(height: 8),
                      const DivisorWidget(),
                      const SizedBox(height: 8),
                      UserProfileLabelWidget(
                        label: "EMAIL",
                        text: userData.email,
                      ),
                      const SizedBox(height: 8),
                      const DivisorWidget(),
                      UserProfileLabelWidget(
                        label: "CPF",
                        text: userData.cpf,
                      ),
                      const SizedBox(height: 8),
                      const DivisorWidget(),
                      const SizedBox(height: 8),
                      ElevatedButton(onPressed: () {}, child: const Text("Alterar senha"), style: ElevatedButton.styleFrom(shape: BeveledRectangleBorder()),)
                    ],
                  ),
                ),
              );
            })
        : const Center(
            child: Text(("No user logged in.")),
          );
  }
}
