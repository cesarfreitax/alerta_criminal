import 'package:alerta_criminal/core/dialog/loading_screen.dart';
import 'package:alerta_criminal/core/utils/auth_util.dart';
import 'package:alerta_criminal/core/utils/keyboard_util.dart';
import 'package:alerta_criminal/core/utils/message_util.dart';
import 'package:alerta_criminal/data/update_user_info_enum.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/string_util.dart';

class _UpdateUserInfoScreenConfig {
  final String title;
  final Icon prefixIcon;
  final String inputLabelText;
  final String confirmInputLabelText;
  final String successMessage;
  final String? Function(String?) validator;
  final Future<void> Function(String) update;

  _UpdateUserInfoScreenConfig(
    this.title,
    this.prefixIcon,
    this.inputLabelText,
    this.confirmInputLabelText,
    this.successMessage,
    this.validator,
    this.update,
  );
}

class UpdateUserInfoScreen extends StatefulWidget {
  UpdateUserInfoScreen({super.key, required UpdateUserInfoEnum infoType}) : _infoType = infoType;

  final UpdateUserInfoEnum _infoType;
  final _formKey = GlobalKey<FormState>();
  final _newValueController = TextEditingController();
  final _confirmNewValueController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(screenConfig.title),
        actions: [
          saveBtn(context),
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
    final formIsInvalid = !widget._formKey.currentState!.validate();
    if (formIsInvalid) {
      return;
    }

    widget._formKey.currentState!.save();

    closeKeyboard(context);
    final loadingScreen = LoadingScreen.instance();
    loadingScreen.show(context: context);

    try {
      await screenConfig.update(widget._newValueController.text);
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
    switch (widget._infoType) {
      case UpdateUserInfoEnum.nickname:
        Navigator.pop(context, widget._newValueController.text);
      case UpdateUserInfoEnum.password:
        logout();
        Navigator.pop(context);
    }

    showSnackBarSuccess(screenConfig.successMessage, context);
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
          updateNickname),
      UpdateUserInfoEnum.password => _UpdateUserInfoScreenConfig(
          getStrings(context).changePasswordScreenTitle,
          const Icon(Icons.lock),
          getStrings(context).password,
          getStrings(context).confirmPassword,
          getStrings(context).passwordUpdatedSuccessfullyMessage,
          passwordValidator,
          updatePassword),
    };
  }

  Future<void> updatePassword(String newValue) async =>
      await getCurrentUser()!.updatePassword(newValue);

  Future<void> updateNickname(String newValue) async =>
      await getCurrentUser()!.updateDisplayName(newValue);

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
}
