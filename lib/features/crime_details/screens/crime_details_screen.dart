import 'package:alerta_criminal/core/utils/date_util.dart';
import 'package:alerta_criminal/core/utils/string_util.dart';
import 'package:alerta_criminal/core/widgets/location_preview_widget.dart';
import 'package:alerta_criminal/data/models/crime_model.dart';
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
              Hero(
                tag: crime.id,
                child: FadeInImage(
                  placeholder: MemoryImage(kTransparentImage),
                  image: NetworkImage(crime.imageUrl),
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  RichText(
                    text: TextSpan(
                      text: '$formattedDate em ',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(fontWeight: todayOrYesterday ? FontWeight.bold : FontWeight.normal),
                      children: [
                        TextSpan(
                          text: crime.address,
                          style: Theme.of(context).textTheme.bodySmall
                        )
                      ]
                    ),
                  ),
                  Text(
                    crime.title,
                    style: Theme.of(context).textTheme.titleLarge,
                    softWrap: true,
                  ),
                  Text(
                    crime.description,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Theme.of(context).colorScheme.primary.withOpacity(0.8)),
                    softWrap: true,
                  ),
                  LocationPreviewWidget(location: LatLng(crime.lat, crime.lng))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
