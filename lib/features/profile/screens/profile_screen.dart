import 'package:alerta_criminal/core/providers/user_notifier.dart';
import 'package:alerta_criminal/core/utils/auth_util.dart';
import 'package:alerta_criminal/core/utils/string_util.dart';
import 'package:alerta_criminal/core/widgets/divisor_widget.dart';
import 'package:alerta_criminal/core/widgets/login_warning_widget.dart';
import 'package:alerta_criminal/data/models/user_model.dart';
import 'package:alerta_criminal/features/profile/enum/update_user_info_enum.dart';
import 'package:alerta_criminal/features/profile/screens/update_user_info_screen.dart';
import 'package:alerta_criminal/features/profile/widgets/user_profile_label_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() {
    return _ProfileScreenState();
  }
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  String? nickname;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    return user != null
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    nicknameWidget(context),
                    const SizedBox(height: 4),
                    nicknameInfoWidget(context),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                const DivisorWidget(),
                nameWidget(context, user),
                const DivisorWidget(),
                emailWidget(context, user),
                const DivisorWidget(),
                cpfWidget(context, user),
                const DivisorWidget(),
                const SizedBox(
                  height: 16,
                ),
                changePasswordWidget(context),
              ],
            ),
          )
        : const Center(child: LoginWarningWidget(canClose: false));
  }

  SizedBox changePasswordWidget(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: () async => handleUpdateUserInfo(UpdateUserInfoEnum.password),
        child: Text(
          textAlign: TextAlign.center,
          getStrings(context).changePassword,
          style: Theme.of(context).textTheme.labelMedium!.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  UserProfileLabelWidget cpfWidget(BuildContext context, UserModel user) {
    return UserProfileLabelWidget(
      label: getStrings(context).cpfProfileLabel,
      text: user.cpf,
    );
  }

  UserProfileLabelWidget emailWidget(BuildContext context, UserModel user) {
    return UserProfileLabelWidget(
      label: getStrings(context).emailProfileLabel,
      text: user.email,
    );
  }

  UserProfileLabelWidget nameWidget(BuildContext context, UserModel user) {
    return UserProfileLabelWidget(
      label: getStrings(context).nameProfileLabel,
      text: user.name,
    );
  }

  Text nicknameInfoWidget(BuildContext context) {
    return Text(
      getStrings(context).nicknameInfo,
      style: Theme.of(context)
          .textTheme
          .bodySmall!
          .copyWith(fontWeight: FontWeight.w100, color: Theme.of(context).colorScheme.primary.withOpacity(0.6)),
    );
  }

  Row nicknameWidget(BuildContext context) {
    return Row(
      children: [
        Text(
          getStrings(context).hello,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          nickname ?? getCurrentUser()!.displayName!,
          style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontWeight: FontWeight.bold),
        ),
        changeNicknameBtnWidget(context),
      ],
    );
  }

  IconButton changeNicknameBtnWidget(BuildContext context) {
    return IconButton(
      onPressed: () async => handleUpdateUserInfo(UpdateUserInfoEnum.nickname),
      icon: const Icon(Icons.edit),
    );
  }

  void handleUpdateUserInfo(UpdateUserInfoEnum infoType) async {
    final newValue = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (ctx) => UpdateUserInfoScreen(
          infoType: infoType,
        ),
      ),
    );

    if (infoType == UpdateUserInfoEnum.password || newValue == null) {
      return;
    }

    updateNickname(newValue);
  }

  updateNickname(String newNickname) => setState(() => nickname = newNickname);
}
