// ignore_for_file: deprecated_member_use

import 'package:invoicex/controller/notification_controller.dart';
import 'package:invoicex/util/dimensions.dart';
import 'package:invoicex/view/base/custom_app_bar.dart';
import 'package:invoicex/view/base/loading_indicator.dart';
import 'package:invoicex/view/base/nothing_to_show_here.dart';
import 'package:invoicex/view/screens/notification/widget/notification_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final ScrollController _scrollController = ScrollController();

// init state
  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  // scroll listener
  Future<void> _scrollListener() async {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      if (!Get.find<NotificationController>().notificationPaginateLoading &&
          Get.find<NotificationController>().notificationNextPageUrl != null) {
        await Get.find<NotificationController>()
            .getNotification(isPaginate: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Get.find<NotificationController>().readAllNotification();
    });
    return WillPopScope(
      onWillPop: () async {
        Get.find<NotificationController>().getNotificationReadStatus();
        return true;
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'notifications_key'.tr,
          isBackButtonExist: true,
          onBackPressed: () {
            Get.find<NotificationController>().getNotificationReadStatus();
            Get.back();
          },
        ),

        // body section
        body: GetBuilder<NotificationController>(
          builder: (notificationController) {
            return notificationController.readAllNotificationLoading ||
                    notificationController.notificationListLoading
                ? const Center(
                    child: LoadingIndicator(),
                  )
                : notificationController.notificationList.isEmpty
                    ? const NothingToShowHere()
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.PADDING_SIZE_SMALL,
                            vertical: Dimensions.PADDING_SIZE_SMALL),
                        child: Column(
                          children: [
                            // Notification List
                            Expanded(
                              child: ListView.builder(
                                controller: _scrollController,
                                itemCount: notificationController
                                    .notificationList.length,
                                itemBuilder: (context, index) {
                                  final data = notificationController
                                      .notificationList[index];
                                  return NotificationItem(
                                    title: data.message ?? '',
                                    time: data.readAt ?? '',
                                  );
                                },
                              ),
                            ),

                            // Pagination View for notification list
                            if (notificationController
                                .notificationPaginateLoading)
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: Dimensions.PADDING_SIZE_DEFAULT),
                                child: Center(
                                  child: LoadingIndicator(),
                                ),
                              )
                          ],
                        ),
                      );
          },
        ),
      ),
    );
  }
}
