import 'package:alerta_criminal/core/providers/user_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/login_warning_widget.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(context, ref) {
    final user = ref.watch(userProvider);

    return user != null ? const Center(
      child: Text("Notifications Screen"),
    ) : const Center(child: LoginWarningWidget(canClose: false));
  }
}
