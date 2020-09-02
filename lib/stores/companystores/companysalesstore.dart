import 'package:epump/utils/branch/banktransaction.dart';
import 'package:epump/utils/branch/daysale.dart';
import 'package:epump/utils/branch/posandvouchersales.dart';
import 'package:epump/utils/company/mybranches.dart';
import 'package:epump/utils/networkcalls/networkrequest.dart';
import 'package:epump/utils/networkcalls/networkstrings.dart';
import 'package:epump/values/strings.dart';
import 'package:mobx/mobx.dart';

part 'companysalesstore.g.dart';

class CompanySalesStore = _CompanySalesStore with _$CompanySalesStore;

abstract class _CompanySalesStore with Store {

  @observable
  List<MyBranches> branches = [];

  @observable
  dynamic todayPmsAmount = 0.00;

  @observable
  dynamic todayAgoAmount = 0.00;

  @observable
  dynamic todayDpkAmount = 0.00;

  @observable
  dynamic yesterdayPmsAmount = 0.00;

  @observable
  dynamic yesterdayAgoAmount = 0.00;

  @observable
  dynamic yesterdayDpkAmount = 0.00;

  @observable
  dynamic monthPmsAmount = 0.00;

  @observable
  dynamic monthAgoAmount = 0.00;

  @observable
  dynamic monthDpkAmount = 0.00;

  @observable
  dynamic todayPmsVolume = 0.00;

  @observable
  dynamic todayAgoVolume = 0.00;

  @observable
  dynamic todayDpkVolume = 0.00;

  @observable
  dynamic yesterdayPmsVolume = 0.00;

  @observable
  dynamic yesterdayAgoVolume = 0.00;

  @observable
  dynamic yesterdayDpkVolume = 0.00;

  @observable
  dynamic monthPmsVolume = 0.00;

  @observable
  dynamic monthAgoVolume = 0.00;

  @observable
  dynamic monthDpkVolume = 0.00;

  @action
  Future<String> getCompanySales(
      String typeOfRequest, String startDate, String endDate) async {
    dynamic response = await NetworkRequest.getCompanySales(startDate, endDate);

    switch (response["statusCode"]) {
      case 200:
        switch (typeOfRequest) {
          case Strings.MONTH_REQUEST:
            monthAgoAmount = 0;
            monthDpkAmount = 0;
            monthPmsAmount = 0;
            monthAgoVolume = 0;
            monthDpkVolume = 0;
            monthPmsVolume = 0;
            List<DaySale> daySales = response["object"];
            daySales.forEach((daySale) {
              if (daySale.product == "AGO") {
                monthAgoAmount += daySale.amount;
                monthAgoVolume += daySale.volume;
              } else if (daySale.product == "DPK") {
                monthDpkAmount += daySale.amount;
                monthDpkVolume += daySale.volume;
              } else {
                monthPmsAmount += daySale.amount;
                monthPmsVolume += daySale.volume;
              }
            });
            break;

          case Strings.TODAY_REQUEST:
            todayAgoAmount = 0;
            todayDpkAmount = 0;
            todayPmsAmount = 0;
            todayAgoVolume = 0;
            todayDpkVolume = 0;
            todayPmsVolume = 0;
            List<DaySale> daySales = response["object"];
            daySales.forEach((daySale) {
              if (daySale.product == "AGO") {
                todayAgoAmount += daySale.amount;
                todayAgoVolume += daySale.volume;
              } else if (daySale.product == "DPK") {
                todayDpkAmount += daySale.amount;
                todayDpkVolume += daySale.volume;
              } else {
                todayPmsAmount += daySale.amount;
                todayPmsVolume += daySale.volume;
              }
            });
            break;

          case Strings.YESTERDAY_REQUEST:
            yesterdayAgoAmount = 0;
            yesterdayDpkAmount = 0;
            yesterdayPmsAmount = 0;
            yesterdayAgoVolume = 0;
            yesterdayDpkVolume = 0;
            yesterdayPmsVolume = 0;
            List<DaySale> daySales = response["object"];
            daySales.forEach((daySale) {
              if (daySale.product == "AGO") {
                yesterdayAgoAmount += daySale.amount;
                yesterdayAgoVolume += daySale.volume;
              } else if (daySale.product == "DPK") {
                yesterdayDpkAmount += daySale.amount;
                yesterdayDpkVolume += daySale.volume;
              } else {
                yesterdayPmsAmount += daySale.amount;
                yesterdayPmsVolume += daySale.volume;
              }
            });
            break;
        }
        return NetworkStrings.SUCCESSFUL;
        break;
      case 401:
        return NetworkStrings.UNAUTHORIZED;
        break;
      case 400:
        return NetworkStrings.BAD_REQUEST;
        break;
      case 500:
        return NetworkStrings.SERVER_ERROR;
        break;
      case 600:
        return NetworkStrings.CONNECTION_ERROR;
        break;
      default:
        return NetworkStrings.UNKNOWN_ERROR;
        break;
    }
  }



  @action
  Future<String> getBranches() async {
    branches = [];
    dynamic response = await NetworkRequest.getBranchesForCompany();
    switch (response["statusCode"]) {
      case 200:
        branches = response["object"];
        return NetworkStrings.SUCCESSFUL;
        break;
      case 401:
        return NetworkStrings.UNAUTHORIZED;
        break;
      case 400:
        return NetworkStrings.BAD_REQUEST;
        break;
      case 500:
        return NetworkStrings.SERVER_ERROR;
        break;
      case 600:
        return NetworkStrings.CONNECTION_ERROR;
        break;
      default:
        return NetworkStrings.UNKNOWN_ERROR;
        break;
    }
  }
}
