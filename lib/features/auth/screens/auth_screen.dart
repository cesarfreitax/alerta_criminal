import 'package:alerta_criminal/core/utils/auth_util.dart';
import 'package:alerta_criminal/core/utils/formatter_util.dart';
import 'package:alerta_criminal/core/utils/message_util.dart';
import 'package:alerta_criminal/core/utils/navigator_util.dart';
import 'package:alerta_criminal/core/utils/string_util.dart';
import 'package:alerta_criminal/data/models/user_model.dart';
import 'package:alerta_criminal/features/home/screens/home_screen.dart';
import 'package:alerta_criminal/features/main/screens/main_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:validadores/Validador.dart';

import '../../../core/di/dependency_injection.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, required this.isLogin});

  final bool isLogin;

  @override
  State<AuthScreen> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  late bool isLogin;
  final formKey = GlobalKey<FormState>();
  var isAuthenticating = false;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final cpfController = TextEditingController();
  final passwordController = TextEditingController();
  final authService = DependencyInjection.authService;

  @override
  void initState() {
    isLogin = widget.isLogin;
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void toggleAuthType() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  void toggleAuthentication(bool isAuthing) {
    setState(() {
      isAuthenticating = isAuthing;
    });
  }

  void submit() async {
    final formIsInvalid = !formKey.currentState!.validate();
    if (formIsInvalid) {
      return;
    }

    formKey.currentState!.save();
    toggleAuthentication(true);

    try {
      if (isLogin) {
        await login();
      } else {
        await register();
        saveUserData();
      }
      toggleAuthentication(false);
      if (!context.mounted) {
        return;
      }
      navigate(context, true, const MainScreen());
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) return;
      handleAuthError(e);
    }
  }

  void saveUserData() {
    final userData = UserModel(
        userId: getCurrentUser()!.uid,
        nickname: nameController.text.split(" ").first,
        name: nameController.text,
        email: emailController.text,
        cpf: cpfController.text);
    DependencyInjection.userDataUseCase.saveUserData(userData);
  }

  void handleAuthError(FirebaseAuthException e) {
    showSnackBarError(
      e.message ?? getStrings(context).authenticationFailed,
      context,
    );
    toggleAuthentication(false);
  }

  Future<void> login() async =>
      await authService.signIn(emailController.text, passwordController.text);

  Future<void> register() async {
    await authService.signUp(emailController.text, passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLogin
            ? getStrings(context).loginTitle
            : getStrings(context).registerTitle),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                if (!isLogin) nameTextFormField(context),
                const SizedBox(
                  height: 16,
                ),
                emailTextFormField(context),
                const SizedBox(
                  height: 16,
                ),
                if (!isLogin) cpfTextFormField(context),
                const SizedBox(
                  height: 16,
                ),
                passwordTextFormField(context),
                const SizedBox(
                  height: 16,
                ),
                submitButton(context),
                const SizedBox(
                  height: 16,
                ),
                changeAuthTypeButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextButton changeAuthTypeButton(BuildContext context) {
    return TextButton(
      onPressed: toggleAuthType,
      child: Text(
        isLogin
            ? getStrings(context).signUpText
            : getStrings(context).signInText,
        style: Theme.of(context).textTheme.labelMedium,
        textAlign: TextAlign.center,
      ),
    );
  }

  SizedBox submitButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: !isAuthenticating ? submit : null,
        child: isAuthenticating
            ? const SizedBox(
                height: 20, width: 20, child: CircularProgressIndicator())
            : Text(isLogin
                ? getStrings(context).signInButton
                : getStrings(context).signUpButton),
      ),
    );
  }

  TextFormField passwordTextFormField(BuildContext context) {
    return TextFormField(
      controller: passwordController,
      obscureText: true,
      textCapitalization: TextCapitalization.none,
      enableSuggestions: false,
      autocorrect: false,
      decoration: InputDecoration(
        labelText: getStrings(context).password,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
        ),
        prefixIcon: const Icon(Icons.lock),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty || value.length < 6) {
          return getStrings(context).passwordInvalidMessage;
        }
        return null;
      },
    );
  }

  TextFormField cpfTextFormField(BuildContext context) {
    return TextFormField(
      controller: cpfController,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        CpfInputFormatter(),
      ],
      decoration: InputDecoration(
        labelText: getStrings(context).cpf,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
        ),
        prefixIcon: const Icon(Icons.credit_card),
      ),
      validator: (value) {
        return Validador()
            .add(Validar.CPF, msg: getStrings(context).cpfErrorMessageInvalid)
            .add(Validar.OBRIGATORIO,
                msg: getStrings(context).cpfErrorMessageGeneric)
            .minLength(11)
            .maxLength(11)
            .valido(value, clearNoNumber: true);
      },
    );
  }

  TextFormField emailTextFormField(BuildContext context) {
    return TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      textCapitalization: TextCapitalization.none,
      decoration: InputDecoration(
        labelText: getStrings(context).emailAddress,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
        ),
        prefixIcon: const Icon(Icons.email),
      ),
      validator: (value) {
        final emailIsNotValid = !EmailValidator.validate(value ?? "");
        if (emailIsNotValid) {
          return getStrings(context).emailInvalidMessage;
        }
        return null;
      },
    );
  }

  TextFormField nameTextFormField(BuildContext context) {
    return TextFormField(
      controller: nameController,
      keyboardType: TextInputType.name,
      textCapitalization: TextCapitalization.none,
      decoration: InputDecoration(
        labelText: getStrings(context).fullName,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
        ),
        prefixIcon: const Icon(Icons.person),
      ),
      validator: (value) {
        if (value == null ||
            value.trim().isEmpty ||
            value.split(' ').length < 2) {
          return getStrings(context).fullNameInvalidMessage;
        }
        return null;
      },
    );
  }
}
