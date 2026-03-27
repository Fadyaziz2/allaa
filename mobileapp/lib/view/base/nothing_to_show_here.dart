import 'package:invoicex/util/images.dart';
import 'package:invoicex/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../util/dimensions.dart';

class NothingToShowHere extends StatelessWidget {
  const NothingToShowHere({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            Images.nothing_to_show_here,
            height: 150,
          ),
          Text(
            "nothing_to_show_here_key".tr,
            style: poppinsMedium.copyWith(
              fontSize: Dimensions.FONT_SIZE_LARGE,
              color: Theme.of(context).textTheme.bodyMedium!.color,
            ),
          ),
        ],
      ),
    );
  }
}
