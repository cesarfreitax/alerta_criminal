import 'package:flutter/cupertino.dart';

import '../../theme/custom_colors.dart';

class DivisorWidget extends StatelessWidget {
  const DivisorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 0.1,
      color: CustomColors().grey,
    );
  }

}