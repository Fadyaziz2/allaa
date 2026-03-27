import 'package:invoicex/util/dimensions.dart';
import 'package:invoicex/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BodyWidget extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  const BodyWidget(
      {super.key,
      required this.title,
      required this.description,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.PADDING_SIZE_DEFAULT),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Image
          SvgPicture.asset(
            image,
            height: 200,
          ),
          const SizedBox(height: Dimensions.PADDING_SIZE_SMALL * 3),

          // Title
          Text(
            title,
            textAlign: TextAlign.center,
            style: poppinsMedium.copyWith(
              fontSize: Dimensions.FONT_SIZE_OVER_LARGE,
              color: Theme.of(context).textTheme.bodyLarge!.color,
            ),
          ),
          const SizedBox(height: Dimensions.PADDING_SIZE_SMALL * 2),

          // Description
          Text(
            description,
            textAlign: TextAlign.center,
            style: poppinsRegular.copyWith(
              fontSize: Dimensions.FONT_SIZE_DEFAULT,
              color: Theme.of(context).disabledColor,
            ),
          ),
        ],
      ),
    );
  }
}
