import 'package:alerta_criminal/features/crime_details/enums/interaction_type_enum.dart';
import 'package:flutter/material.dart';

class InteractionWidget extends StatefulWidget {
  const InteractionWidget({super.key, required this.interactionType, this.interactionsCount});

  final InteractionTypeEnum interactionType;
  final int? interactionsCount;

  @override
  State<StatefulWidget> createState() {
    return _InteractionWidgetState();
  }
}

class _InteractionWidgetState extends State<InteractionWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Row(
        children: [
          Icon(_getInteractionIcon(widget.interactionType)),
          const SizedBox(width: 4,),
          if (widget.interactionsCount != null)
            Text(widget.interactionsCount.toString())
        ],
      ),
    );
  }
}

IconData _getInteractionIcon(InteractionTypeEnum interactionType) {
  switch (interactionType) {
    case InteractionTypeEnum.alert:
      return Icons.favorite_border;
    case InteractionTypeEnum.comment:
      return Icons.mode_comment_outlined;
    case InteractionTypeEnum.share:
      return Icons.send;
  }
}