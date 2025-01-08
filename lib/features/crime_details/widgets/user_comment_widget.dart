import 'package:alerta_criminal/core/di/dependency_injection.dart';
import 'package:alerta_criminal/core/util/auth_util.dart';
import 'package:alerta_criminal/core/util/date_util.dart';
import 'package:flutter/material.dart';

import '../../../data/models/crime_commentary_model.dart';

class UserCommentWidget extends StatefulWidget {
  const UserCommentWidget({super.key, required this.isPreview, required this.comment, required this.crimeId});

  final bool isPreview;
  final CrimeCommentaryModel comment;
  final String crimeId;

  @override
  State<UserCommentWidget> createState() {
    return _UserCommentWidgetState();
  }
}

class _UserCommentWidgetState extends State<UserCommentWidget> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        spacing: 4,
        children: [
          Text(
            widget.comment.cachedUsername,
            style: Theme.of(context).textTheme.labelSmall!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            widget.comment.date.getDifferenceFromNow(context),
            style: Theme.of(context)
                .textTheme
                .labelSmall!
                .copyWith(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5)),
          ),
        ],
      ),
      subtitle: Text(
        widget.comment.text,
        style: Theme.of(context).textTheme.labelSmall,
      ),
      trailing: widget.isPreview
          ? null
          : GestureDetector(
              onTap: () => toggleLike(),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 4,
                children: [
                  Image.asset(
                    alreadyLiked() ? 'assets/like_filled.png' : 'assets/like_outlined.png',
                    scale: 1.5,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  Text(widget.comment.likes.length.toString())
                ],
              ),
            ),
    );
  }

  bool alreadyLiked() => widget.comment.likes.contains(getCurrentUser()?.uid);

  void toggleLike() async {
    final userAlreadyLiked = alreadyLiked();

    if (userAlreadyLiked) {
      setState(() {
        widget.comment.likes.remove(getCurrentUser()!.uid);
      });
    } else {
      setState(() {
        widget.comment.likes.add(getCurrentUser()!.uid);
      });
    }
    await DependencyInjection.crimeCommentariesUseCase
        .toggleLikeOnCommentary(widget.crimeId, widget.comment.id!, getCurrentUser()!.uid, userAlreadyLiked);
  }
}
