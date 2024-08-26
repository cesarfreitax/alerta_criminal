import 'package:alerta_criminal/core/utils/string_util.dart';
import 'package:alerta_criminal/data/models/crime_model.dart';
import 'package:flutter/material.dart';
import 'package:alerta_criminal/core/utils/date_util.dart';

class CrimeDetailsWidget extends StatelessWidget {
  const CrimeDetailsWidget({super.key, required this.crime});

  final CrimeModel crime;

  @override
  Widget build(BuildContext context) {
    final formattedDayText = formatDayText(
      crime.date.toDate(),
      context,
    );
    final todayOrYesterday = isTodayOrYesterday(formattedDayText, context);
    final dateDateTime = crime.date.toDate();
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 20,
        child: Row(
          spacing: 6,
          children: [
            if (crime.imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  bottomLeft: Radius.circular(12.0),
                ),
                child: SizedBox(
                  height: double.infinity,
                  width: 150,
                  child: Image.network(
                    crime.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Column(
                  crossAxisAlignment: crime.imageUrl.isNotEmpty
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: crime.imageUrl.isNotEmpty
                          ? CrossAxisAlignment.start
                          : CrossAxisAlignment.center,
                      children: [
                        Text(
                          crime.title,
                          style: Theme.of(context).textTheme.titleSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Opacity(
                          opacity: 0.8,
                          child: Text(
                            crime.description,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      getStrings(context).seeMoreDetails,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            decoration: TextDecoration.underline,
                          ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            formattedDayText,
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      fontSize: 8,
                                      fontWeight: todayOrYesterday
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                          ),
                          Text(
                            hour,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    fontSize: 8, fontWeight: FontWeight.w200),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
