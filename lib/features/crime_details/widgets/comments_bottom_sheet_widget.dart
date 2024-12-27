import 'package:alerta_criminal/core/di/dependency_injection.dart';
import 'package:alerta_criminal/core/util/auth_util.dart';
import 'package:alerta_criminal/core/util/keyboard_util.dart';
import 'package:alerta_criminal/core/util/string_util.dart';
import 'package:alerta_criminal/data/models/crime_commentaries_model.dart';
import 'package:alerta_criminal/data/models/crime_commentary_model.dart';
import 'package:alerta_criminal/features/crime_details/widgets/user_comment_widget.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CommentsBottomSheet {
  Future<dynamic> show(
    BuildContext context,
    CrimeCommentariesModel? commentaries,
    String crimeId,
    void Function(CrimeCommentaryModel) onNewComment,
  ) async {
    return showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return FractionallySizedBox(
          heightFactor: 0.8,
          widthFactor: 1.0,
          child: _CommentsBottomSheetWidget(
            commentaries: commentaries,
            crimeId: crimeId,
            onNewComment: onNewComment,
          ),
        );
      },
      isScrollControlled: true,
    );
  }
}

class _CommentsBottomSheetWidget extends StatefulWidget {
  _CommentsBottomSheetWidget({
    required this.commentaries,
    required this.crimeId,
    required this.onNewComment,
  });

  CrimeCommentariesModel? commentaries;
  final String crimeId;
  void Function(CrimeCommentaryModel) onNewComment;

  @override
  State<_CommentsBottomSheetWidget> createState() {
    return _CommentsBottomSheetWidgetState();
  }
}

class _CommentsBottomSheetWidgetState extends State<_CommentsBottomSheetWidget> {
  final TextEditingController controller = TextEditingController();

  List<CrimeCommentaryModel> comments = [];

  @override
  void initState() {
    if (widget.commentaries != null) {
      comments = widget.commentaries!.comments;
    }
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 8,
        right: 8,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        spacing: 8,
        children: [
          FractionallySizedBox(
            widthFactor: 0.1,
            child: Divider(
              thickness: 2.0,
              height: 16,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Flexible(
            flex: 2,
            child: ListView.builder(
                itemCount: comments.length,
                itemBuilder: (ctx, index) {
                  final comment = comments[index];
                  return UserCommentWidget(comment: comment);
                }),
          ),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(16),
                ),
              ),
              labelText: getStrings(context).comment,
              alignLabelWithHint: true,
            ),
            onSubmitted: (text) async {
              final user = getCurrentUser()!;

              final newComment = CrimeCommentaryModel(
                id: Uuid().v1(),
                likes: [],
                text: text,
                userId: user.uid,
                cachedUsername: user.displayName!,
                date: DateTime.now(),
              );

              setState(() {
                controller.clear();
                comments.add(newComment);
              });

              if (!context.mounted) {
                return;
              }

              closeKeyboard(context);
              widget.onNewComment(newComment);

              await DependencyInjection.crimeCommentariesUseCase
                  .createOrUpdateCrimeCommentaries(widget.crimeId, newComment);
            },
          )
        ],
      ),
    );
  }
}
