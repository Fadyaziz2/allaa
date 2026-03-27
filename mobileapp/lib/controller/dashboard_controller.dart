import 'package:invoicex/data/model/body/update_profile_body.dart';
import 'package:invoicex/data/model/response/dashboard_info_model.dart';
import 'package:invoicex/data/repository/dashboard_repo.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../data/api/api_checker.dart';
import '../data/model/response/income_overview_model.dart';
import '../data/model/response/payment_overview_model.dart';
import '../data/model/response/profile_details_model.dart';
import '../data/model/response/response_model.dart';
import '../view/screens/home/home_screen.dart';

class DashboardController extends GetxController implements GetxService {
  final DashboardRepo dashboardRepo;
  DashboardController({required this.dashboardRepo});

  final GlobalKey<ScaffoldState> moreDrawerKey = GlobalKey<ScaffoldState>();
  int _bottomNavbarIndex = 0;
  int get bottomNavbarIndex => _bottomNavbarIndex;

  DashboardInfoModel? _dashboardInfoModel;
  DashboardInfoModel? get dashboardInfoModel => _dashboardInfoModel;

  PaymentOverviewModel? _paymentOverviewModel;
  PaymentOverviewModel? get paymentOverviewModel => _paymentOverviewModel;

  ProfileDetailsModel? _profileDetailsModel;
  ProfileDetailsModel? get profileDetailsModel => _profileDetailsModel;

  double _receivedAmountPercentage = 0;
  double get receivedAmountPercentage => _receivedAmountPercentage;

  double _dueAmountPercentage = 0;
  double get dueAmountPercentage => _dueAmountPercentage;

  List<IncomeOverviewModel> _incomeOverviewList = [];
  List<IncomeOverviewModel> get incomeOverviewList => _incomeOverviewList;

  bool _isDashboardDataLoading = false;
  bool get isDashboardDataLoading => _isDashboardDataLoading;

  bool _isIncomeOverviewLoading = false;
  bool get isIncomeOverviewLoading => _isIncomeOverviewLoading;

  bool _isPaymentOverviewLoading = false;
  bool get isPaymentOverviewLoading => _isPaymentOverviewLoading;

  bool _isIncomeOverviewFilterLoading = false;
  bool get isIncomeOverviewFilterLoading => _isIncomeOverviewFilterLoading;

  bool _isProfileDetailsLoading = false;
  bool get isProfileDetailsLoading => _isProfileDetailsLoading;

  String? _dateOfBirth;
  String? get dateOfBirth => _dateOfBirth;

  String? _selectedGender;
  String? get selectedGender => _selectedGender;

  final List<Map<String, String>> _genderList = [
    {
      'id': 'Male',
      'value': 'Male',
    },
    {
      'id': 'Female',
      'value': 'Female',
    },
  ];
  List<Map<String, String>> get genderList => _genderList;

  XFile? _pickedImage;
  XFile? get pickedImage => _pickedImage;

  final String _countryCodeNumber = '+1';
  String get countryCodeNumber => _countryCodeNumber;

  bool _updateProfileLoading = false;
  bool get updateProfileLoading => _updateProfileLoading;

  Widget bodyItem = const HomeScreen();

  Country _country = CountryParser.parseCountryCode("US");
  Country get country => _country;

  void setBodyItem(Widget screen) {
    bodyItem = screen;
    update();
  }

  void refreshData() {
    _selectedIncomeOverviewType = "this_week_key";
    print('this week= ${_selectedIncomeOverviewType}');
    update();
  }

// Set country code
  void setCountryCode(String code) {
    _country = CountryParser.parseCountryCode(code);
  }

// Set country code
  String removeCountryCode(String phoneNumber) {
    return phoneNumber.replaceAll("+${_country.phoneCode}", '');
  }

  // chart data
  final List<Map<String, String>> _incomeOverviewFilterType = [
    {"title": "last_7_days_key", "value": "1"},
    {"title": "this_week_key", "value": "2"},
    {"title": "last_week_key", "value": "3"},
    {"title": "this_month_key", "value": "4"},
    {"title": "last_month_key", "value": "5"},
    {"title": "this_year_key", "value": "6"},
    {"title": "total_key", "value": "0"}
  ];

  //
  List<Map<String, String>> get incomeOverviewFilterType =>
      _incomeOverviewFilterType;

  String _selectedIncomeOverviewType = "this_week_key";
  String get selectedIncomeOverviewType => _selectedIncomeOverviewType;

  //  Set bottom nav bar selected button index
  void setBottomNavBarIndex(int index) {
    _bottomNavbarIndex = index;
    update();
  }

  // Dash info get Data method
  Future<void> getDashBoardData() async {
    _isDashboardDataLoading = true;
    update();
    Response response = await dashboardRepo.getDashBoardData();
    if (response.statusCode == 200 && response.body['status'] == true) {
      _dashboardInfoModel = DashboardInfoModel.fromJson(response.body);
    } else {
      ApiChecker.checkApi(response);
    }
    _isDashboardDataLoading = false;
    update();
  }

  // Dash info get Data method
  Future<void> getPaymentOverviewData() async {
    _isPaymentOverviewLoading = true;
    update();
    Response response = await dashboardRepo.getPaymentOverviewData();
    if (response.statusCode == 200 && response.body['status'] == true) {
      _paymentOverviewModel = PaymentOverviewModel.fromJson(response.body);
      calculateAmountPercentage(
        receivedAmount: _paymentOverviewModel!.result![0].amount.toString(),
        dueAmount: _paymentOverviewModel!.result![1].amount.toString(),
      );
    } else {
      ApiChecker.checkApi(response);
    }
    _isPaymentOverviewLoading = false;
    update();
  }

  // Calculate Received and Due amount percentage
  void calculateAmountPercentage(
      {required String receivedAmount, required String dueAmount}) {
    double due, received, totalAmount;

    try {
      received = double.parse(receivedAmount);
      due = double.parse(dueAmount);
      totalAmount = received + due;

      _receivedAmountPercentage = (received / totalAmount) * 100;
      _dueAmountPercentage = (due / totalAmount) * 100;
      if (_receivedAmountPercentage.isNaN && _dueAmountPercentage.isNaN) {
        _receivedAmountPercentage = 50;
        _dueAmountPercentage = 50;
      } else {
        if (_receivedAmountPercentage.isNaN && !_dueAmountPercentage.isNaN) {
          _receivedAmountPercentage = 100 - _dueAmountPercentage;
        } else if (!_receivedAmountPercentage.isNaN &&
            _dueAmountPercentage.isNaN) {
          _dueAmountPercentage = 100 - _receivedAmountPercentage;
        }
      }
    } catch (e) {
      _receivedAmountPercentage = 50;
      _dueAmountPercentage = 50;
    }
  }

  // Get income overview data
  Future<void> getIncomeOverview(String id, bool fromFilter) async {
    if (fromFilter) {
      _isIncomeOverviewFilterLoading = true;
    }
    _isIncomeOverviewLoading = true;
    update();
    final response = await dashboardRepo.getIncomeOverviewData(id);
    if (response.statusCode == 200 && response.body['status'] == true) {
      _incomeOverviewList = [];
      response.body['result'].forEach((item) {
        _incomeOverviewList.add(IncomeOverviewModel.fromJson(item));
      });
    } else {
      ApiChecker.checkApi(response);
    }
    if (fromFilter) {
      _isIncomeOverviewFilterLoading = false;
    }
    _isIncomeOverviewLoading = false;
    update();
  }

  void setSelectedIncomeOverviewType(String value) {
    String? id = '2';
    for (var element in _incomeOverviewFilterType) {
      if (element['title'] == value) {
        id = element['value'];
        break;
      }
    }

    _selectedIncomeOverviewType = value;
    getIncomeOverview(id!, true);
    update();
  }

  // Get Profile Data
  Future<ResponseModel> getProfileDetails() async {
    _isProfileDetailsLoading = true;
    _profileDetailsModel = null;
    update();
    ResponseModel responseModel;
    Response response = await dashboardRepo.getProfileDetails();
    if (response.statusCode == 200 && response.body['status'] == true) {
      _profileDetailsModel =
          ProfileDetailsModel.fromJson(response.body['result']);
      responseModel = ResponseModel(true, response.body['message']);
    } else {
      ApiChecker.checkApi(response);
      responseModel = ResponseModel(false, response.body['message']);
    }
    _isProfileDetailsLoading = false;
    update();
    return responseModel;
  }

  // Set Selected Gender name
  void setGender(String? value, bool notify) {
    _selectedGender = value;
    if (notify) {
      update();
    }
  }

  // Set pick image
  void pickImage(bool isRemove) async {
    if (isRemove) {
      _pickedImage = null;
    } else {
      _pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
      update();
    }
  }

  // Update Profile
  Future<ResponseModel> updateProfile(
      UpdateProfileBody updateProfileBody) async {
    _updateProfileLoading = true;
    update();
    ResponseModel responseModel;
    Response response = await dashboardRepo.updateProfile(
        updateProfileBody: updateProfileBody, image: _pickedImage);

    if (response.statusCode == 200 && response.body['status'] == true) {
      responseModel = ResponseModel(true, response.body['message']);
      _pickedImage = null;
      getProfileDetails();
    } else {
      ApiChecker.checkApi(response);
      responseModel = ResponseModel(false, response.body['message']);
    }
    _updateProfileLoading = false;
    update();
    return responseModel;
  }

  // Set country
  void setCountry(Country country) {
    _country = country;
    update();
  }

  // Email De..@gemail.com formatter
  String formatEmail(String email) {
    int atIndex = email.indexOf('@');
    if (atIndex <= 2) {
      return email; // Not enough characters to shorten
    }
    return email.substring(0, 2) + '..' + email.substring(atIndex);
  }
}
