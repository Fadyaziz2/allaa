// ignore_for_file: deprecated_member_use

import 'package:invoicex/util/dimensions.dart';
import 'package:invoicex/util/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class DashBoardItem extends StatelessWidget {
  final String icon;
  final String title;
  final String subTitle;
  final Color color;
  final bool isCenter;
  const DashBoardItem(
      {super.key,
      required this.icon,
      required this.title,
      required this.subTitle,
      required this.color,
      this.isCenter = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isCenter ? Get.size.width : Get.size.width / 2,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 35,
            width: 35,
            padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL - 2),
            decoration: BoxDecoration(
                color: color.withOpacity(0.15), shape: BoxShape.circle),
            child: SvgPicture.asset(icon, color: color),
          ),
          const SizedBox(
            width: Dimensions.PADDING_SIZE_SMALL,
          ),

          // title and subtitle section
          isCenter
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: poppinsRegular.copyWith(
                            fontSize: Dimensions.FONT_SIZE_DEFAULT,
                            color: color)),
                    const SizedBox(
                      height: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                    ),
                    Text(
                      subTitle,
                      style: poppinsRegular.copyWith(
                          fontSize: Dimensions.FONT_SIZE_DEFAULT,
                          fontWeight: FontWeight.w700,
                          overflow: TextOverflow.ellipsis),
                    )
                  ],
                )
              : Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: poppinsRegular.copyWith(
                              fontSize: Dimensions.FONT_SIZE_DEFAULT,
                              color: color)),
                      const SizedBox(
                        height: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                      ),
                      Text(
                        subTitle,
                        style: poppinsRegular.copyWith(
                            fontSize: Dimensions.FONT_SIZE_DEFAULT,
                            fontWeight: FontWeight.w700,
                            overflow: TextOverflow.ellipsis),
                      )
                    ],
                  ),
                )
        ],
      ),
    );
  }
}
