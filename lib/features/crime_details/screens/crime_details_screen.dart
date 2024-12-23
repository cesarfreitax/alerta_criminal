import 'package:alerta_criminal/core/util/date_util.dart';
import 'package:alerta_criminal/core/util/string_util.dart';
import 'package:alerta_criminal/core/widgets/location_preview_widget.dart';
import 'package:alerta_criminal/data/models/crime_model.dart';
import 'package:alerta_criminal/features/crime_details/enums/interaction_type_enum.dart';
import 'package:alerta_criminal/features/crime_details/widgets/interaction_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:transparent_image/transparent_image.dart';

class CrimeDetailsScreen extends StatelessWidget {
  const CrimeDetailsScreen({super.key, required this.crime});

  final CrimeModel crime;

  @override
  Widget build(BuildContext context) {
    final formattedDate = formatDayText(crime.date, context);
    final todayOrYesterday = isTodayOrYesterday(formattedDate, context);

    return Scaffold(
      appBar: AppBar(
        title: Text(getStrings(context).crimeDetails),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (crime.imageUrl.isNotEmpty)
              crimeImageWidget(),
            crimeInfoWidget(context, formattedDate, todayOrYesterday),
          ],
        ),
      ),
    );
  }

  Widget crimeInfoWidget(BuildContext context, String formattedDate, bool todayOrYesterday) {
    return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                titleWidget(context),
                descriptionWidget(context),
                const SizedBox(height: 8,),
                LocationPreviewWidget(location: LatLng(crime.lat, crime.lng)),
                dateAndPlaceWidget(formattedDate, context, todayOrYesterday),
                interactionsWidget(),
              ],
            ),
          );
  }

  Widget crimeImageWidget() {
    return Hero(
              tag: crime.id,
              child: FadeInImage(
                placeholder: MemoryImage(kTransparentImage),
                image: NetworkImage(crime.imageUrl),
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            );
  }

  Text descriptionWidget(BuildContext context) {
    return Text(
                  crime.description,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Theme.of(context).colorScheme.primary.withValues(alpha: 20, red: 255, green: 255, blue: 255)),
                  softWrap: true,
                );
  }

  Text titleWidget(BuildContext context) {
    return Text(
                  crime.title,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
                  softWrap: true,
                );
  }

  Widget dateAndPlaceWidget(String formattedDate, BuildContext context, bool todayOrYesterday) {
    return RichText(
                  text: TextSpan(
                    text: '$formattedDate em ',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(fontWeight: todayOrYesterday ? FontWeight.bold : FontWeight.normal),
                    children: [
                      TextSpan(
                        text: crime.address,
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          color: Theme.of(context).colorScheme.primary.withValues(alpha: 20, red: 255, green: 255, blue: 255)
                        )
                      )
                    ]
                  ),
                );
  }

  Widget interactionsWidget() {
    return Row(
      spacing: 10,
      children: [
        InteractionWidget(interactionType: InteractionTypeEnum.alert, interactionsCount: 0,),
        InteractionWidget(interactionType: InteractionTypeEnum.comment, interactionsCount: 0,),
        InteractionWidget(interactionType: InteractionTypeEnum.share),
      ],
    );
  }
}
