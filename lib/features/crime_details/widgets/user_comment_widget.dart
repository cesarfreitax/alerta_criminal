import 'package:alerta_criminal/core/util/date_util.dart';
import 'package:flutter/material.dart';

import '../../../data/models/crime_commentary_model.dart';

class UserCommentWidget extends StatelessWidget {
  const UserCommentWidget({super.key, required this.comment});

  final CrimeCommentaryModel comment;

  @override
  Widget build(context) {
    return ListTile(
      title: Row(
        spacing: 4,
        children: [
          Text(
            comment.cachedUsername,
            style: Theme.of(context).textTheme.labelSmall!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            comment.date.getDifferenceFromNow(context),
            style: Theme.of(context).textTheme.labelSmall!.copyWith(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5)
            ),
          ),
        ],
      ),
      subtitle: Text(
        comment.text,
        style: Theme.of(context).textTheme.labelSmall,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 4,
        children: [
          GestureDetector(onTap: () => {}, child: Image.asset('assets/like_outlined.png', scale: 1.5,)),
          Text(comment.likes.length.toString())
        ],
      ),
    );
  }
}
