// ignore_for_file: unnecessary_import

import 'package:invoicex/util/dimensions.dart';
import 'package:invoicex/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool? isBackButtonExist;
  final Function? onBackPressed;
  final List<Widget>? actions;
  final bool? centerTitle;
  const CustomAppBar({
    super.key,
    this.actions,
    this.title,
    this.isBackButtonExist,
    this.onBackPressed,
    this.centerTitle,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).cardColor,
      surfaceTintColor: Colors.transparent,

      // Title Section
      title: title != null
          ? Text(
              title!,
              textAlign: TextAlign.center,
              style:
                  poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
            )
          : const SizedBox(),
      centerTitle: centerTitle == null ? true : false,

      // Action Section
      leading: isBackButtonExist!
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
              ),
              onPressed: () => onBackPressed != null
                  ? onBackPressed!()
                  : Navigator.pop(context),
            )
          : const SizedBox(),
      actions: actions,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => Size(1170, GetPlatform.isDesktop ? 70 : 50);
}
