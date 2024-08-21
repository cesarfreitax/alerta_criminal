import 'package:alerta_criminal/core/utils/message_util.dart';
import 'package:alerta_criminal/core/utils/string_util.dart';
import 'package:alerta_criminal/core/widgets/widgets.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/di/dependency_injection.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  final formKey = GlobalKey<FormState>();
  var isLogin = false;
  var isAuthenticating = false;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final authService = DependencyInjection.authService;

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
      }
      toggleAuthentication(false);
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) return;
      handleAuthError(e);
    }
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
                if (!isLogin)
                  nameTextFormField(context),
                verticalSpacing(height: 16),
                emailTextFormField(context),
                verticalSpacing(height: 16),
                passwordTextFormField(context),
                verticalSpacing(height: 16),
                submitButton(context),
                verticalSpacing(height: 16),
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
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator())
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
                      Radius.circular(30),
                    ),
                  ),
                  prefixIcon: const Icon(Icons.lock),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty ||
                      value.length < 6) {
                    return getStrings(context).passwordInvalidMessage;
                  }
                  return null;
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
                      Radius.circular(30),
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
                        Radius.circular(30),
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
