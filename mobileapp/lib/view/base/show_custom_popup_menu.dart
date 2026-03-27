// ignore_for_file: deprecated_member_use, overridden_fields, annotate_overrides

import 'package:invoicex/theme/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../data/model/body/popup_model.dart';
import '../../util/dimensions.dart';
import '../../util/styles.dart';

void showPopupMenu(BuildContext context, List<PopupModel> list,
    {bool isGridView = false}) async {
  final RenderBox cardRenderBox = context.findRenderObject() as RenderBox;
  final Offset cardPosition = cardRenderBox.localToGlobal(Offset.zero);
  await showMenu(
    color: Theme.of(context).cardColor,
    context: context,
    surfaceTintColor:
        Get.isDarkMode ? LightAppColor.blackGrey : LightAppColor.cardColor,
    elevation: 5,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.RADIUS_DEFAULT)),
    position: RelativeRect.fromLTRB(
      isGridView
          ? cardPosition.dx + (cardRenderBox.size.width / 2 - 20)
          : cardPosition.dx + cardRenderBox.size.width + 20,
      cardPosition.dy,
      cardPosition.dx + cardRenderBox.size.width + 50.0, // Width of the menu
      cardPosition.dy + cardRenderBox.size.height,
    ),
    items: List.generate(
      list.length,
      (index) => PopupMenuItem(
        padding: null,
        onTap: () {
          if (list[index].isRoute) {
            if (list[index].route != '') {
              Get.toNamed(list[index].route);
            }
          } else {
            Get.dialog(list[index].widget!);
          }
        },
        enabled: true,
        child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          height: 50.3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: SizedBox(
                  height: 50,
                  width: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: Dimensions.PADDING_SIZE_EXTRA_SMALL + 2,
                      ),
                      SizedBox(
                        child: Row(
                          children: [
                            // Popup button image/ icon
                            SvgPicture.asset(
                              list[index].image,
                              color: Get.isDarkMode
                                  ? Theme.of(context).indicatorColor
                                  : const Color(0xff1F2A37),
                              width: 20,
                              height: 20,
                            ),
                            const SizedBox(
                              width: Dimensions.PADDING_SIZE_SMALL,
                            ),

                            // Popup button title
                            Flexible(
                              child: Text(
                                list[index].title.tr,
                                style: poppinsRegular.copyWith(
                                    overflow: TextOverflow.ellipsis,
                                    color: Get.isDarkMode
                                        ? Theme.of(context).indicatorColor
                                        : const Color(0xff1F2A37),
                                    fontSize: Dimensions.FONT_SIZE_LARGE),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: Dimensions.PADDING_SIZE_SMALL,
                      ),
                    ],
                  ),
                ),
              ),

              //   Popup button bottom divider
              index != list.length - 1
                  ? Divider(
                      height: 0.3,
                      color: Theme.of(context).disabledColor.withOpacity(0.3),
                    )
                  : const SizedBox(
                      height: 0.3,
                    )
            ],
          ),
        ),
      ),
    ),
  );
}
