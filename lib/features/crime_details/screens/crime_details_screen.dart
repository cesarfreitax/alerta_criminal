import 'package:alerta_criminal/core/di/dependency_injection.dart';
import 'package:alerta_criminal/core/util/date_util.dart';
import 'package:alerta_criminal/core/util/string_util.dart';
import 'package:alerta_criminal/core/widgets/location_preview_widget.dart';
import 'package:alerta_criminal/data/models/crime_commentaries_model.dart';
import 'package:alerta_criminal/data/models/crime_commentary_model.dart';
import 'package:alerta_criminal/data/models/crime_model.dart';
import 'package:alerta_criminal/features/crime_details/widgets/comments_bottom_sheet_widget.dart';
import 'package:alerta_criminal/features/crime_details/widgets/user_comment_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:transparent_image/transparent_image.dart';

const commentsPreviewLimit = 2;

class CrimeDetailsScreen extends StatefulWidget {
  const CrimeDetailsScreen({super.key, required this.crime});

  final CrimeModel crime;

  @override
  State<CrimeDetailsScreen> createState() {
    return _CrimeDetailsScreenState();
  }
}

class _CrimeDetailsScreenState extends State<CrimeDetailsScreen> {
  CrimeCommentariesModel? commentaries;
  final List<CrimeCommentaryModel> inMemoryComments = [];
  var isLoading = true;

  @override
  void initState() {
    getCommentaries(widget.crime.id);
    super.initState();
  }

  getCommentaries(String crimeId) async {
    final c = await DependencyInjection.crimeCommentariesUseCase.getCommentaries(crimeId);
    setState(() {
      commentaries = c;
      inMemoryComments.addAll(c?.comments ?? []);
      isLoading = false;
    });
  }

  void onNewComment(CrimeCommentaryModel newComment) {
    inMemoryComments.add(newComment);
  }

  Widget crimeInfoWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          titleWidget(context),
          descriptionWidget(context),
          const SizedBox(
            height: 8,
          ),
          LocationPreviewWidget(location: LatLng(widget.crime.lat, widget.crime.lng)),
          dateAndPlaceWidget(context),
        ],
      ),
    );
  }

  Widget crimeImageWidget() {
    return Hero(
      tag: widget.crime.id,
      child: FadeInImage(
        placeholder: MemoryImage(kTransparentImage),
        image: NetworkImage(widget.crime.imageUrl),
        height: 300,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  Text descriptionWidget(BuildContext context) {
    return Text(
      widget.crime.description,
      style: Theme.of(context).textTheme.bodySmall,
      softWrap: true,
    );
  }

  Text titleWidget(BuildContext context) {
    return Text(
      widget.crime.title,
      style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
      softWrap: true,
    );
  }

  Widget dateAndPlaceWidget(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onPrimaryContainer;
    return RichText(
      text: TextSpan(
          text: '${widget.crime.date.formatToDefaultPattern(context)} - ',
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: textColor.withValues(alpha: 0.5),
              ),
          children: [
            TextSpan(
              text: widget.crime.address,
              style: Theme.of(context).textTheme.labelSmall!.copyWith(
                    color: textColor.withValues(alpha: 0.5),
                  ),
            )
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getStrings(context).crimeDetails),
        actions: [IconButton(onPressed: () => {}, icon: Icon(Icons.share))],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.crime.imageUrl.isNotEmpty) crimeImageWidget(),
            crimeInfoWidget(context),
            const SizedBox(
              height: 8,
            ),
            Divider(
              height: 1,
              color: Theme.of(context).colorScheme.secondaryContainer,
            ),
            const SizedBox(
              height: 8,
            ),
            SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  ...inMemoryComments
                      .getRange(0, inMemoryComments.length < commentsPreviewLimit ? inMemoryComments.length : commentsPreviewLimit)
                      .map((comment) => UserCommentWidget(comment: comment)),
                  const SizedBox(
                    height: 8,
                  ),
                  GestureDetector(
                    onTap: () {
                      CommentsBottomSheet().show(context, commentaries, widget.crime.id, onNewComment);
                    },
                    child: Text(
                      inMemoryComments.isNotEmpty ? getStrings(context).allComments : getStrings(context).firstOnCommenting,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
