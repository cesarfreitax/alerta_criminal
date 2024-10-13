import 'package:alerta_criminal/core/di/dependency_injection.dart';
import 'package:alerta_criminal/core/dialog/loading_screen.dart';
import 'package:alerta_criminal/core/utils/auth_util.dart';
import 'package:alerta_criminal/core/utils/keyboard_util.dart';
import 'package:alerta_criminal/core/utils/message_util.dart';
import 'package:alerta_criminal/data/update_user_info_enum.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/string_util.dart';

class UpdateUserInfoScreen extends StatefulWidget {
  UpdateUserInfoScreen({super.key, required this.infoType});

  final UpdateUserInfoEnum infoType;
  final formKey = GlobalKey<FormState>();
  final newValueController = TextEditingController();
  final confirmNewValueController = TextEditingController();

  @override
  State<UpdateUserInfoScreen> createState() {
    return _UpdateUserInfoScreenState();
  }
}

class _UpdateUserInfoScreenState extends State<UpdateUserInfoScreen> {
  @override
  void initState() {
    super.initState();
  }

  String get screenTitle {
    return switch (widget.infoType) {
      UpdateUserInfoEnum.nickname => getStrings(context).changeNickname,
      UpdateUserInfoEnum.password => getStrings(context).changePasswordScreenTitle
    };
  }

  Icon get prefixIcon {
    return switch (widget.infoType) {
      UpdateUserInfoEnum.nickname => const Icon(Icons.person),
      UpdateUserInfoEnum.password => const Icon(Icons.lock)
    };
  }

  String get inputLabelText {
    return switch (widget.infoType) {
      UpdateUserInfoEnum.nickname => getStrings(context).nickname,
      UpdateUserInfoEnum.password => getStrings(context).password
    };
  }

  String get confirmInputLabelText {
    return switch (widget.infoType) {
      UpdateUserInfoEnum.nickname => "",
      UpdateUserInfoEnum.password => getStrings(context).confirmPassword
    };
  }

  String get successMessage {
    return switch (widget.infoType) {
      UpdateUserInfoEnum.nickname => 'Apelido atualizado com sucesso!',
      UpdateUserInfoEnum.password => 'Senha atualizada com sucesso!'
    };
  }

  String? Function(String?) get validator {
    return switch (widget.infoType) {
      UpdateUserInfoEnum.nickname => nicknameValidator,
      UpdateUserInfoEnum.password => passwordValidator
    };
  }

  update(String newValue) async {
    switch (widget.infoType) {
      case UpdateUserInfoEnum.nickname:
        await firebaseAuthInstance.currentUser!.updateDisplayName(newValue);
      case UpdateUserInfoEnum.password:
        await firebaseAuthInstance.currentUser!.updatePassword(newValue);
    }
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text(screenTitle),
        actions: [
          saveBtn(context),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Form(
          key: widget.formKey,
          child: Column(
            spacing: 16,
            children: [
              inputTxtField(widget.newValueController, context, inputLabelText),
              if (widget.infoType == UpdateUserInfoEnum.password)
                inputTxtField(widget.confirmNewValueController, context, confirmInputLabelText),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField inputTxtField(TextEditingController inputController, BuildContext context, String inputLabelText) {
    return TextFormField(
      controller: inputController,
      keyboardType: widget.infoType == UpdateUserInfoEnum.nickname ? TextInputType.name : null,
      obscureText: widget.infoType == UpdateUserInfoEnum.password,
      enableSuggestions: false,
      autocorrect: false,
      textCapitalization: TextCapitalization.none,
      decoration: InputDecoration(
        labelText: inputLabelText,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
        ),
        prefixIcon: prefixIcon,
      ),
      validator: validator,
    );
  }

  Padding saveBtn(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: IconButton(
        icon: const Icon(Icons.check),
        onPressed: () async {
          await save(context);
        },
      ),
    );
  }

  Future<void> save(BuildContext context) async {
    final formIsInvalid = !widget.formKey.currentState!.validate();
    if (formIsInvalid) {
      return;
    }

    widget.formKey.currentState!.save();

    closeKeyboard(context);
    final loadingScreen = LoadingScreen.instance();
    loadingScreen.show(context: context);

    try {
      await update(widget.newValueController.text);
      if (!context.mounted) {
        return;
      }
      handleSuccessOnUpdateUserInfo(context);
    } on FirebaseAuthException catch (e) {
      handleErrorOnUpdateUserInfo(e, context);
    }
    loadingScreen.hide();
  }

  void handleErrorOnUpdateUserInfo(FirebaseAuthException e, BuildContext context) {
    showSnackBarError(e.message.toString(), context);
  }

  void handleSuccessOnUpdateUserInfo(BuildContext context) {
    switch (widget.infoType) {
      case UpdateUserInfoEnum.nickname:
        Navigator.pop(context, widget.newValueController.text);
      case UpdateUserInfoEnum.password:
        logout();
        Navigator.pop(context);
    }

    showSnackBarSuccess(successMessage, context);
  }

  String? nicknameValidator(String? nickname) {
    if (nickname == null || nickname.trim().isEmpty || nickname.trim().length < 3) {
      return getStrings(context).nicknameValidatorMessage;
    }
    return null;
  }

  String? passwordValidator(String? password) {
    if (password == null || password.trim().isEmpty || password.length < 6) {
      return getStrings(context).passwordInvalidMessage;
    }
    if (widget.newValueController.text != widget.confirmNewValueController.text) {
      return getStrings(context).passwordConfirmationInvalidMessage;
    }
    return null;
  }
}
