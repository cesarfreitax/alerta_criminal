import 'package:flutter/material.dart';

class UserProfileLabelWidget extends StatelessWidget {
  const UserProfileLabelWidget({super.key, required this.label, required this.text});

  final String label;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .labelLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          text,
          style: Theme.of(context).textTheme.labelMedium,
          softWrap: true,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
