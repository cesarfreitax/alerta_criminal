import 'package:alerta_criminal/core/utils/date_util.dart';
import 'package:alerta_criminal/core/utils/string_util.dart';
import 'package:alerta_criminal/data/models/crime_model.dart';
import 'package:alerta_criminal/features/crime_details/screens/crime_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class CrimeDetailsWidget extends StatelessWidget {
  const CrimeDetailsWidget({super.key, required this.crime});

  final CrimeModel crime;

  @override
  Widget build(BuildContext context) {
    final formattedDayText = formatDayText(
      crime.date,
      context,
    );
    final todayOrYesterday = isTodayOrYesterday(formattedDayText, context);
    final dateDateTime = crime.date;
    final hour = getStrings(context).hourSuffix(
      formatTime(
        TimeOfDay(
          hour: dateDateTime.hour,
          minute: dateDateTime.minute,
        ),
      ),
    );

    return SizedBox(
      width: crime.imageUrl.isNotEmpty ? double.infinity : 250,
      height: 160,
      child: Card(
        color: Theme.of(context).colorScheme.primaryContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 20,
        child: Row(
          // spacing: 6,
          children: [
            if (crime.imageUrl.isNotEmpty) crimeImage(),
            const SizedBox(
              width: 6,
            ),
            crimeDetails(context, formattedDayText, todayOrYesterday, hour),
          ],
        ),
      ),
    );
  }

  ClipRRect crimeImage() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12.0),
        bottomLeft: Radius.circular(12.0),
      ),
      child: SizedBox(
        height: double.infinity,
        width: 150,
        child: Stack(
          children: <Widget>[
            const Center(child: CircularProgressIndicator()),
            Center(
              child: FadeInImage.memoryNetwork(
                key: ValueKey(crime.id),
                placeholder: kTransparentImage,
                image: crime.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Expanded crimeDetails(BuildContext context, String formattedDayText, bool todayOrYesterday, String hour) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Column(
          crossAxisAlignment: crime.imageUrl.isNotEmpty ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: crime.imageUrl.isNotEmpty ? CrossAxisAlignment.start : CrossAxisAlignment.center,
              children: [
                crimeTitle(context),
                const SizedBox(
                  height: 8,
                ),
                crimeDescription(context),
              ],
            ),
            seeMoreDetailsTextButton(context),
            crimeDate(formattedDayText, context, todayOrYesterday, hour),
          ],
        ),
      ),
    );
  }

  Padding crimeDate(String formattedDayText, BuildContext context, bool todayOrYesterday, String hour) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            formattedDayText,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontSize: 8,
                  fontWeight: todayOrYesterday ? FontWeight.bold : FontWeight.normal,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
          ),
          Text(
            hour,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontSize: 8,
                  fontWeight: FontWeight.w200,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
          ),
        ],
      ),
    );
  }

  GestureDetector seeMoreDetailsTextButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => CrimeDetailsScreen(crime: crime),
          ),
        );
      },
      child: Text(
        getStrings(context).seeMoreDetails,
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Opacity crimeDescription(BuildContext context) {
    return Opacity(
      opacity: 0.8,
      child: Text(
        crime.description,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
      ),
    );
  }

  Text crimeTitle(BuildContext context) {
    return Text(
      crime.title,
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.bold,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
