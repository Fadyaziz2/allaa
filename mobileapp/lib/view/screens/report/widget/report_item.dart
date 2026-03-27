import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/styles.dart';

class ReportItem extends StatelessWidget {
  final String image;
  final String title;
  final VoidCallback onTap;
  const ReportItem(
      {super.key,
      required this.image,
      required this.title,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      shadowColor: Get.isDarkMode ? Colors.grey[500]! : Colors.grey[100]!,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.RADIUS_DEFAULT),
      ),
      child: ListTile(
        contentPadding: const EdgeInsetsDirectional.symmetric(
          horizontal: Dimensions.PADDING_SIZE_SMALL,
        ),
        horizontalTitleGap: Dimensions.PADDING_SIZE_SMALL,
        onTap: onTap,
        // Report title section
        title: Text(title, style: poppinsRegular),
        // Report logo section
        leading: SvgPicture.asset(
          image,
          width: 25,
          height: 25,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
