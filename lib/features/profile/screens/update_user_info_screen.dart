import 'dart:async';

import 'package:alerta_criminal/core/di/dependency_injection.dart';
import 'package:alerta_criminal/core/dialog/loading_screen.dart';
import 'package:alerta_criminal/core/util/auth_util.dart';
import 'package:alerta_criminal/core/util/keyboard_util.dart';
import 'package:alerta_criminal/core/util/message_util.dart';
import 'package:alerta_criminal/features/profile/enum/update_user_info_enum.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/util/string_util.dart';

class _UpdateUserInfoScreenConfig {
  final String title;
  final Icon prefixIcon;
  final String inputLabelText;
  final String confirmInputLabelText;
  final String successMessage;
  final String? Function(String?) validator;
  final Future<void> Function() updateAction;
  final void Function(BuildContext) handleSuccess;
  final Widget actionWidget;

  _UpdateUserInfoScreenConfig(
    this.title,
    this.prefixIcon,
    this.inputLabelText,
    this.confirmInputLabelText,
    this.successMessage,
    this.validator,
    this.updateAction,
    this.handleSuccess,
    this.actionWidget,
  );
}

class UpdateUserInfoScreen extends StatefulWidget {
  UpdateUserInfoScreen({super.key, required UpdateUserInfoEnum infoType}) : _infoType = infoType;

  final UpdateUserInfoEnum _infoType;
  final _formKey = GlobalKey<FormState>();
  final _newValueController = TextEditingController();
  final _confirmNewValueController = TextEditingController();
  bool isRecoverPasswordTimeout = false;

  @override
  State<UpdateUserInfoScreen> createState() {
    return _UpdateUserInfoScreenState();
  }
}

class _UpdateUserInfoScreenState extends State<UpdateUserInfoScreen> {
  late Timer timer;
  int remainingSeconds = 60;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(screenConfig.title),
        actions: [
          screenConfig.actionWidget,
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Form(
          key: widget._formKey,
          child: Column(
            spacing: 16,
            children: [
              inputTxtField(widget._newValueController, context, screenConfig.inputLabelText),
              if (widget._infoType == UpdateUserInfoEnum.password)
                inputTxtField(widget._confirmNewValueController, context, screenConfig.confirmInputLabelText),
              if (widget.isRecoverPasswordTimeout) recoverPasswordCountdown(context)
            ],
          ),
        ),
      ),
    );
  }

  TextFormField inputTxtField(TextEditingController inputController, BuildContext context, String inputLabelText) {
    return TextFormField(
      controller: inputController,
      keyboardType: widget._infoType == UpdateUserInfoEnum.nickname ? TextInputType.name : null,
      obscureText: widget._infoType == UpdateUserInfoEnum.password,
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
        prefixIcon: screenConfig.prefixIcon,
      ),
      validator: screenConfig.validator,
    );
  }

  Padding saveButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: IconButton(
        icon: const Icon(Icons.check),
        onPressed: () async {
          await update(context);
        },
      ),
    );
  }

  Padding sendButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: TextButton(
        child: Text(
          "Enviar",
          style: Theme.of(context).textTheme.labelMedium!.copyWith(
              color: widget.isRecoverPasswordTimeout ? Theme.of(context).colorScheme.primary.withOpacity(0.5) : null),
        ),
        onPressed: () async {
          widget.isRecoverPasswordTimeout ? null : await update(context);
        },
      ),
    );
  }

  Widget recoverPasswordCountdown(BuildContext context) {
    return Text("Aguarde $remainingSeconds segundos para enviar novamente.");
  }

  Future<void> update(BuildContext context) async {
    final formIsInvalid = !widget._formKey.currentState!.validate();
    if (formIsInvalid) {
      return;
    }

    widget._formKey.currentState!.save();

    closeKeyboard(context);
    final loadingScreen = LoadingScreen.instance();
    loadingScreen.show(context: context);

    try {
      await screenConfig.updateAction();
      if (!context.mounted) {
        return;
      }
      screenConfig.handleSuccess(context);
    } on FirebaseAuthException catch (e) {
      handleErrorOnUpdateUserInfo(e, context);
    }
    loadingScreen.hide();
  }

  void handleErrorOnUpdateUserInfo(FirebaseAuthException e, BuildContext context) {
    showSnackBarError(e.message.toString(), context);
  }

  void handleSuccessOnNickname(BuildContext context) {
    Navigator.pop(context, widget._newValueController.text);
    showSnackBarSuccess(screenConfig.successMessage, context);
  }

  void handleSuccessOnUpdatingPassword(BuildContext context) {
    logout();
    Navigator.pop(context);
    showSnackBarSuccess(screenConfig.successMessage, context);
  }

  void handleSuccessOnRecoveringPassword(BuildContext context) {
    showSnackBarSuccess(screenConfig.successMessage, context);
    setState(() => widget.isRecoverPasswordTimeout = true);
  }

  _UpdateUserInfoScreenConfig get screenConfig {
    return switch (widget._infoType) {
      UpdateUserInfoEnum.nickname => _UpdateUserInfoScreenConfig(
          getStrings(context).changeNickname,
          const Icon(Icons.person),
          getStrings(context).nickname,
          "",
          getStrings(context).nicknameUpdatedSuccessfullyMessage,
          nicknameValidator,
          updateNickname,
          handleSuccessOnNickname,
          saveButton(context),
        ),
      UpdateUserInfoEnum.password => _UpdateUserInfoScreenConfig(
          getStrings(context).changePasswordScreenTitle,
          const Icon(Icons.lock),
          getStrings(context).password,
          getStrings(context).confirmPassword,
          getStrings(context).passwordUpdatedSuccessfullyMessage,
          passwordValidator,
          updatePassword,
          handleSuccessOnUpdatingPassword,
          saveButton(context),
        ),
      UpdateUserInfoEnum.recoverPassword => _UpdateUserInfoScreenConfig(
          getStrings(context).recoverPasswordScreenTitle,
          const Icon(Icons.email),
          getStrings(context).emailAddress,
          "",
          getStrings(context).emailRecoverSent,
          emailValidator,
          sendEmailToRecoverPassword,
          handleSuccessOnRecoveringPassword,
          sendButton(context),
        ),
    };
  }

  Future<void> updatePassword() async => await getCurrentUser()!.updatePassword(widget._newValueController.text);

  Future<void> updateNickname() async => await getCurrentUser()!.updateDisplayName(widget._newValueController.text);

  Future<void> sendEmailToRecoverPassword() async {
    await firebaseAuthInstance.sendPasswordResetEmail(email: widget._newValueController.text);
    startCountdown();
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
    if (widget._newValueController.text != widget._confirmNewValueController.text) {
      return getStrings(context).passwordConfirmationInvalidMessage;
    }
    return null;
  }

  String? emailValidator(String? email) {
    final emailIsNotValid = !EmailValidator.validate(email ?? "");
    if (emailIsNotValid) {
      return getStrings(context).emailInvalidMessage;
    }
    return null;
  }

  void startCountdown() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        setState(() {
          if (remainingSeconds > 0) {
            remainingSeconds--;
          } else {
            widget.isRecoverPasswordTimeout = false;
            timer.cancel();
          }
        });
      },
    );
  }
}
