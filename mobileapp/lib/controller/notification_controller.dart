import 'package:invoicex/data/repository/notification_repo.dart';
import 'package:get/get.dart';
import '../data/api/api_checker.dart';
import '../data/model/response/notification_model.dart';

class NotificationController extends GetxController implements GetxService {
  final NotificationRepo notificationRepo;
  NotificationController({required this.notificationRepo});

  bool _notificationReadStatus = true;
  bool get notificationReadStatus => _notificationReadStatus;

  List<NotificationModel> _notificationList = [];
  List<NotificationModel> get notificationList => _notificationList;

  bool _readAllNotificationLoading = false;
  bool get readAllNotificationLoading => _readAllNotificationLoading;

  bool _notificationReadStatusLoading = false;
  bool get notificationReadStatusLoading => _notificationReadStatusLoading;

  bool _notificationListLoading = false;
  bool get notificationListLoading => _notificationListLoading;

  bool _notificationPaginateLoading = false;
  bool get notificationPaginateLoading => _notificationPaginateLoading;

  String? _notificationNextPageUrl;
  String? get notificationNextPageUrl => _notificationNextPageUrl;

  // Read notification read status data
  Future<void> getNotificationReadStatus() async {
    _notificationReadStatusLoading = true;
    update();
    final response = await notificationRepo.getNotificationReadStatus();
    if (response.statusCode == 200 && response.body['status'] == true) {
      _notificationReadStatus = !response.body['result'];
    } else {
      _notificationReadStatusLoading = false;
      _notificationReadStatus = true;
      update();
      ApiChecker.checkApi(response);
    }
    _notificationReadStatusLoading = false;
    update();
  }

  // Read all notification data
  Future<void> readAllNotification() async {
    _readAllNotificationLoading = true;
    update();
    if (_notificationReadStatus) {
      await getNotification();
    } else {
      final response = await notificationRepo.readAllNotification();
      if (response.statusCode == 200 && response.body['status'] == true) {
        await getNotification();
      } else {
        _readAllNotificationLoading = false;
        update();
        ApiChecker.checkApi(response);
      }
    }
    _readAllNotificationLoading = false;
    update();
  }

  // Get notification data
  Future<void> getNotification({bool isPaginate = false}) async {
    if (isPaginate) {
      _notificationPaginateLoading = true;
    } else {
      _notificationListLoading = true;
      _notificationList = [];
    }
    update();
    final response =
        await notificationRepo.getNotification(url: _notificationNextPageUrl);
    if (response.statusCode == 200 && response.body['status'] == true) {
      response.body['result']['data'].forEach((item) {
        _notificationList.add(NotificationModel.fromJson(item));
      });
      _notificationNextPageUrl =
          response.body['result']['pagination']['next_page_url'];
    } else {
      _notificationListLoading = false;
      _notificationPaginateLoading = false;
      update();
      ApiChecker.checkApi(response);
    }
    if (isPaginate) {
      _notificationPaginateLoading = false;
    } else {
      _notificationListLoading = false;
    }
    update();
  }
}
