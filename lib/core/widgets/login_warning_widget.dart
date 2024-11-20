import 'package:alerta_criminal/core/utils/navigator_util.dart';
import 'package:alerta_criminal/core/utils/string_util.dart';
import 'package:alerta_criminal/features/auth/screens/auth_screen.dart';
import 'package:flutter/material.dart';

class LoginWarningWidget extends StatefulWidget {
  const LoginWarningWidget({super.key, required this.canClose});

  final bool canClose;

  @override
  State<LoginWarningWidget> createState() {
    return _LoginWarningWidgetState();
  }
}

class _LoginWarningWidgetState extends State<LoginWarningWidget> {
  var visibility = true;

  void closeWarning() {
    setState(() {
      visibility = false;
    });
  }

  void navigateToAuthScreen(BuildContext context, bool isLogin) {
    navigate(context, false, AuthScreen(isLogin: isLogin));
  }

  @override
  Widget build(BuildContext context) {
    return visibility
        ? SizedBox(
            height: 160,
            child: Stack(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          getStrings(context).loginWarningMessage,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            OutlinedButton(
                              onPressed: () {
                                navigateToAuthScreen(context, true);
                              },
                              child: Text(
                                getStrings(context).loginWarningAccess,
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer
                              ),
                              onPressed: () {
                                navigateToAuthScreen(context, false);
                              },
                              child: Text(
                                getStrings(context).loginWarningCreate,
                                style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                      color: Theme.of(context).colorScheme.onPrimary,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                if (widget.canClose)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: closeWarning,
                      child: Icon(
                        Icons.close,
                        size: 18,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
              ],
            ),
          )
        : const SizedBox();
  }
}
