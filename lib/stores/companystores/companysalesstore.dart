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
  dynamic todayLpgAmount = 0.00;

  @observable
  dynamic yesterdayPmsAmount = 0.00;

  @observable
  dynamic yesterdayAgoAmount = 0.00;

  @observable
  dynamic yesterdayDpkAmount = 0.00;

  @observable
  dynamic yesterdayLpgAmount = 0.00;

  @observable
  dynamic monthPmsAmount = 0.00;

  @observable
  dynamic monthAgoAmount = 0.00;

  @observable
  dynamic monthDpkAmount = 0.00;

  @observable
  dynamic monthLpgAmount = 0.00;

  @observable
  dynamic todayPmsVolume = 0.00;

  @observable
  dynamic todayAgoVolume = 0.00;

  @observable
  dynamic todayDpkVolume = 0.00;


  @observable
  dynamic todayLpgVolume = 0.00;

  @observable
  dynamic yesterdayPmsVolume = 0.00;

  @observable
  dynamic yesterdayAgoVolume = 0.00;

  @observable
  dynamic yesterdayDpkVolume = 0.00;

  @observable
  dynamic yesterdayLpgVolume = 0.00;

  @observable
  dynamic monthPmsVolume = 0.00;

  @observable
  dynamic monthAgoVolume = 0.00;

  @observable
  dynamic monthDpkVolume = 0.00;

  @observable
  dynamic monthLpgVolume = 0.00;



  @action
  void sortBranches(String sortBy){
    List<MyBranches> temp = branches;

    if(sortBy == "PMS"){
      temp.sort((b,a) => a.pmsTotalVolume.compareTo(b.pmsTotalVolume));
      // branches.sort((a,b) => a.name.compareTo(b.name));

    }else if(sortBy == "DPK"){
      temp.sort((b,a) => a.dpkTotalVolume.compareTo(b.dpkTotalVolume));
    }else if(sortBy == "PMS"){
      temp.sort((b,a) => a.agoTotalVolume.compareTo(b.agoTotalVolume));
    }
    else if(sortBy == "LPG"){
      temp.sort((b,a) => a.lpgTotalVolume.compareTo(b.lpgTotalVolume));
    }
    branches = temp;
  }

  @action
  Future<String> getCompanySales(
      String typeOfRequest, String startDate, String endDate) async {
    monthAgoAmount=0;
    monthDpkAmount=0;
    monthPmsAmount=0;
    monthLpgAmount=0;
    monthAgoVolume=0;
    monthDpkVolume=0;
    monthPmsVolume=0;
    monthLpgVolume=0;
    todayAgoAmount=0;
    todayDpkAmount=0;
    todayPmsAmount=0;
    todayLpgAmount=0;
    todayAgoVolume=0;
    todayDpkVolume=0;
    todayPmsVolume=0;
    todayLpgVolume=0;
    yesterdayAgoAmount=0;
    yesterdayDpkAmount=0;
    yesterdayPmsAmount=0;
    yesterdayLpgAmount=0;
    yesterdayAgoVolume=0;
    yesterdayDpkVolume=0;
    yesterdayPmsVolume=0;
    yesterdayLpgVolume=0;
    dynamic response = await NetworkRequest.getCompanySales(startDate, endDate);

    switch (response["statusCode"]) {
      case 200:
        switch (typeOfRequest) {
          case Strings.MONTH_REQUEST:

            List<DaySale> daySales = response["object"];
            daySales.forEach((daySale) {
              if(daySale.product == "AGO"){
                monthAgoAmount+=daySale.amount;
                monthAgoVolume+=daySale.volume;
              }
              else if(daySale.product == "DPK"){
                monthDpkAmount+=daySale.amount;
                monthDpkVolume+=daySale.volume;
              }
              else if(daySale.product == "PMS"){
                monthPmsAmount+=daySale.amount;
                monthPmsVolume+=daySale.volume;
              }else if(daySale.product == "LPG"){
                monthLpgAmount+=daySale.amount;
                monthLpgVolume+=daySale.volume;
              }else{}
            });
            break;

          case Strings.TODAY_REQUEST:

            List<DaySale> daySales = response["object"];
            daySales.forEach((daySale) {
              if(daySale.product == "AGO"){
                todayAgoAmount+=daySale.amount;
                todayAgoVolume+=daySale.volume;
              }
              else if(daySale.product == "DPK"){
                todayDpkAmount+=daySale.amount;
                todayDpkVolume+=daySale.volume;
              }
              else if(daySale.product == "PMS"){
                todayPmsAmount+=daySale.amount;
                todayPmsVolume+=daySale.volume;

              }else if(daySale.product == "LPG"){
                todayLpgAmount+=daySale.amount;
                todayLpgVolume+=daySale.volume;

              }else{}
            });
            break;

          case Strings.YESTERDAY_REQUEST:

            List<DaySale> daySales = response["object"];
            daySales.forEach((daySale) {
              if(daySale.product == "AGO"){
                yesterdayAgoAmount+=daySale.amount;
                yesterdayAgoVolume+=daySale.volume;
              }
              else if(daySale.product == "DPK"){
                yesterdayDpkAmount+=daySale.amount;
                yesterdayDpkVolume+=daySale.volume;
              }
              else if(daySale.product == "PMS"){
                yesterdayPmsAmount+=daySale.amount;
                yesterdayPmsVolume+=daySale.volume;
              }
              else if(daySale.product == "LPG"){
                yesterdayLpgAmount+=daySale.amount;
                yesterdayLpgVolume+=daySale.volume;
              }else{}
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
        branches.sort((a,b) => a.name.compareTo(b.name));

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
