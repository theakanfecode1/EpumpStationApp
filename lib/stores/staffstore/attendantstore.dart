import 'package:epump/utils/branch/bank.dart';
import 'package:epump/utils/branch/bankdeposit.dart';
import 'package:epump/utils/branch/staff.dart';
import 'package:epump/utils/networkcalls/networkrequest.dart';
import 'package:epump/utils/networkcalls/networkstrings.dart';
import 'package:epump/utils/staff/branchstaff.dart';
import 'package:mobx/mobx.dart';

part 'attendantstore.g.dart';

class AttendantStore = _AttendantStore with _$AttendantStore;

abstract class _AttendantStore with Store{
  @observable
  List<BranchStaff> staffs= [];

  @observable
  List<State> states = [];



  @action
  Future<String> getStaff() async {
    staffs = [];
    dynamic response = await NetworkRequest.getBranchStaffs();

    switch(response["statusCode"]){
      case 200:
        staffs = response["object"];
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
  Future<String> getStates() async {
    states = [];
    dynamic response = await NetworkRequest.getStates();

    switch(response["statusCode"]){
      case 200:
        states = response["object"];
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
  Future<String> createStaff(String firstName,String lastName,String gender,String phoneNumber,String email,String streetAddress,String state) async {
    dynamic response = await NetworkRequest.postCreateStaff(firstName, lastName, gender, phoneNumber, email, streetAddress, state);
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
}
