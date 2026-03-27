// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/styles.dart';

class SettingItem extends StatelessWidget {
  final String title;
  final String image;
  final Color color;
  final String? route;
  const SettingItem(
      {super.key,
      required this.title,
      required this.image,
      required this.color,
      this.route});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
      child: GestureDetector(
        onTap: () {
          if (route != null) {
            Get.toNamed(route!);
          }
        },
        child: ListTile(

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.RADIUS_DEFAULT),
          ),
          tileColor: Theme.of(context).cardColor,
          contentPadding: const EdgeInsetsDirectional.symmetric(
            horizontal: Dimensions.PADDING_SIZE_SMALL,
            vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL,
          ),
          horizontalTitleGap: Dimensions.PADDING_SIZE_SMALL,

          // Title
          title: Text(
            title.tr,
            style: poppinsMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
          ),

          // Image section
          leading: CircleAvatar(
            radius: Dimensions.RADIUS_EXTRA_LARGE,
            backgroundColor: color.withOpacity(0.15),
            child: SvgPicture.asset(
              image,
              color: color,
              height: 20,
            ),
          ),
        ),
      ),
    );
  }
}
