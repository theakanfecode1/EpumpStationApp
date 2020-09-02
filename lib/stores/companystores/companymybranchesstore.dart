import 'package:epump/utils/company/company.dart';
import 'package:epump/utils/networkcalls/networkrequest.dart';
import 'package:epump/utils/networkcalls/networkstrings.dart';
import 'package:mobx/mobx.dart';

part 'companymybranchesstore.g.dart';

class CompanyMyBranchesStore = _CompanyMyBranchesStore with _$CompanyMyBranchesStore;

abstract class _CompanyMyBranchesStore with Store{


  @observable
  Company company = Company(id: "",name: "",email: "",street: "",city: "",state: "",country: "",numberOfBranches: 0,numberOfDealers: 0,url: "");

  @action
  Future<String> getBranch() async {
    dynamic response = await NetworkRequest.getMyBranchesFromCompany();
    switch(response["statusCode"]){
      case 200:
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
  Future<String> getCompany() async {
    dynamic response = await NetworkRequest.getCompany();
    switch(response["statusCode"]){
      case 200:
        company = response["object"];
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