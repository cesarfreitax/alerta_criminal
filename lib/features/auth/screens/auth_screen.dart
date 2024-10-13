import 'package:alerta_criminal/core/utils/auth_util.dart';
import 'package:alerta_criminal/core/utils/formatter_util.dart';
import 'package:alerta_criminal/core/utils/message_util.dart';
import 'package:alerta_criminal/core/utils/navigator_util.dart';
import 'package:alerta_criminal/core/utils/string_util.dart';
import 'package:alerta_criminal/data/models/user_model.dart';
import 'package:alerta_criminal/features/main/screens/main_screen.dart';
import 'package:alerta_criminal/features/profile/screens/update_user_info_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:validadores/Validador.dart';

import '../../../core/di/dependency_injection.dart';
import '../../profile/enum/update_user_info_enum.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key, required this.isLogin});

  final bool isLogin;

  @override
  ConsumerState<AuthScreen> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
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
    final isRegister = !isLogin;
    if (isRegister) {
      nameController.dispose();
      cpfController.dispose();
    }
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void toggleAuthType() {
    if (!isLogin) {
      nameController.dispose();
      cpfController.dispose();
    }
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

    UserCredential? userCredential;

    try {
      if (isLogin) {
        userCredential = await login();
      } else {
        userCredential = await register();
        await saveUserData();
      }
      toggleAuthentication(false);
      if (!context.mounted || userCredential == null) {
        return;
      }
      navigate(context, true, const MainScreen());
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) return;
      handleAuthError(e);
    }
  }

  Future<void> saveUserData() async {
    final userData = UserModel(
        userId: getCurrentUser()!.uid, name: nameController.text, email: emailController.text, cpf: cpfController.text);
    await DependencyInjection.userDataUseCase.saveUserData(userData);
    await getCurrentUser()!.updateDisplayName(nameController.text.split(" ").first);
  }

  void handleAuthError(FirebaseAuthException e) {
    showSnackBarError(
      e.message ?? getStrings(context).authenticationFailed,
      context,
    );
    toggleAuthentication(false);
  }

  Future<UserCredential?> login() async => await authService.signIn(emailController.text, passwordController.text);

  Future<UserCredential> register() async {
    return await authService.signUp(emailController.text, passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: screenTitle(context),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: form(context),
        ),
      ),
    );
  }

  Text screenTitle(BuildContext context) {
    return Text(isLogin ? getStrings(context).loginTitle : getStrings(context).registerTitle);
  }

  Form form(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        spacing: 16,
        children: [
          if (!isLogin) nameTextFormField(context),
          emailTextFormField(context),
          if (!isLogin) cpfTextFormField(context),
          passwordTextFormField(context),
          if (isLogin) recoverPasswordButton(context),
          submitButton(context),
          changeAuthTypeButton(context),
        ],
      ),
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
        if (value == null || value.trim().isEmpty || value.split(' ').length < 2) {
          return getStrings(context).fullNameInvalidMessage;
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
            .add(Validar.OBRIGATORIO, msg: getStrings(context).cpfErrorMessageGeneric)
            .minLength(11)
            .maxLength(11)
            .valido(value, clearNoNumber: true);
      },
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

  SizedBox submitButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: !isAuthenticating ? submit : null,
        child: isAuthenticating
            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator())
            : Text(isLogin ? getStrings(context).signInButton : getStrings(context).signUpButton),
      ),
    );
  }

  TextButton changeAuthTypeButton(BuildContext context) {
    return TextButton(
      onPressed: toggleAuthType,
      child: Text(
        isLogin ? getStrings(context).signUpText : getStrings(context).signInText,
        style: Theme.of(context).textTheme.labelMedium,
        textAlign: TextAlign.center,
      ),
    );
  }

  TextButton recoverPasswordButton(BuildContext context) {
    return TextButton(
      onPressed: recoverPassword,
      child: Text(
        getStrings(context).forgotPassword,
        style: Theme.of(context).textTheme.labelMedium,
        textAlign: TextAlign.center,
      ),
    );
  }

  recoverPassword() => navigate(context, false, UpdateUserInfoScreen(infoType: UpdateUserInfoEnum.recoverPassword,));
}
