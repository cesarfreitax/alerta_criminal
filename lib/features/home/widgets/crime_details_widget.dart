import 'package:alerta_criminal/core/util/date_util.dart';
import 'package:alerta_criminal/core/util/string_util.dart';
import 'package:alerta_criminal/data/models/crime_model.dart';
import 'package:alerta_criminal/features/crime_details/screens/crime_details_screen.dart';
import 'package:flutter/material.dart';

class CrimeDetailsWidget extends StatelessWidget {
  const CrimeDetailsWidget({super.key, required this.crime});

  final CrimeModel crime;

  @override
  Widget build(BuildContext context) {
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
            if (crime.imageUrl.isNotEmpty) crimeImage(context),
            const SizedBox(
              width: 6,
            ),
            crimeDetails(context),
          ],
        ),
      ),
    );
  }

  ClipRRect crimeImage(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12.0),
        bottomLeft: Radius.circular(12.0),
      ),
      child: SizedBox(
        height: double.infinity,
        width: 150,
        child: Center(
          child: Image.network(
            crime.imageUrl,
            loadingBuilder: (context, child, loading) {
              if (loading == null) return child;
              return CircularProgressIndicator(
                color: Theme.of(context).colorScheme.secondary,
                value: loading.expectedTotalBytes != null
                    ? loading.cumulativeBytesLoaded / loading.expectedTotalBytes!
                    : null,
              );
            },
            key: ValueKey(crime.id),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
    );
  }

  Expanded crimeDetails(BuildContext context) {
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
            crimeDate(context),
          ],
        ),
      ),
    );
  }

  Padding crimeDate(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: Text(
        crime.date.getDifferenceFromNow(context),
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
              fontSize: 8,
              fontWeight: FontWeight.w200,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
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
