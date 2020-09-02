import 'package:epump/utils/networkcalls/networkrequest.dart';
import 'package:epump/utils/networkcalls/networkstrings.dart';
import 'package:mobx/mobx.dart';
import 'package:epump/utils/account/logindetails.dart';

part 'accountloginstore.g.dart';

class AccountLoginStore = _AccountLoginStore with _$AccountLoginStore;

abstract class _AccountLoginStore with Store{

  @observable
  AccountLogin loginDetails;

  @action
  Future<String> loginUser(String username,String password) async {
    dynamic response = await NetworkRequest.loginUser(username, password);

    switch(response["statusCode"]){
      case 200:
        loginDetails = response["object"];
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