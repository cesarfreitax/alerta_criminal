import 'package:alerta_criminal/core/utils/string_util.dart';
import 'package:alerta_criminal/data/models/crime_model.dart';
import 'package:flutter/material.dart';

class CrimeDetailsWidget extends StatelessWidget {
  const CrimeDetailsWidget({super.key, required this.crime});

  final CrimeModel crime;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 150,
      child: Card(
        elevation: 20,
        child: Row(
          children: [
            SizedBox(
              height: 150,
              width: 150,
              child: crime.imageUrl.isNotEmpty
                  ? Image.network(
                      crime.imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    )
                  : null,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      crime.title,
                      style: Theme.of(context).textTheme.titleSmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8,),
                    Opacity(
                      opacity: 0.8,
                      child: Text(
                        crime.description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    const SizedBox(height: 8,),
                    Text(getStrings(context).seeMoreDetails, style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      decoration: TextDecoration.underline
                    ),)
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
