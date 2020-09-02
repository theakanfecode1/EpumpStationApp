import 'package:epump/customwidgets/feedbackwidget.dart';
import 'package:epump/customwidgets/singletextfielddialog.dart';
import 'package:epump/customwidgets/structureddialog.dart';
import 'package:epump/screens/loadingscreen.dart';
import 'package:epump/stores/branchstores/maintenancerequeststore.dart';
import 'package:epump/utils/branch/maintenancerequest.dart';
import 'package:epump/utils/networkcalls/networkstrings.dart';
import 'package:epump/values/colors.dart';
import 'package:epump/values/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RequestDetails extends StatefulWidget {
  final MaintenanceRequest request;

  RequestDetails({this.request});

  @override
  _RequestDetailsState createState() => _RequestDetailsState();
}

class _RequestDetailsState extends State<RequestDetails> {
  bool showResolved = false;

  void checkResolved() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String role =
        sharedPreferences.getString("ROLE").toLowerCase() ?? "branchmanager";
    if (widget.request.resolved) {
      setState(() {
        showResolved = false;
      });
    } else {
      if (role != "companyadmin") {
        setState(() {
          showResolved = true;
        });
      } else {
        setState(() {
          showResolved = false;
        });
      }
    }
  }

  textFromDialog(String amount) async {
    final requestStore = Provider.of<MaintenanceRequestStore>(context,listen: false);
    double resolveAmount = amount.isEmpty?0.00:double.parse(amount);
    Navigator.of(context).push(LoadingWidget.showLoadingScreen("Resolving Request"));
    String result = await requestStore.resolveRequest(widget.request.id, resolveAmount);
    Navigator.of(context).pop();
    if(result == NetworkStrings.SUCCESSFUL){
      await showDialog(context: context,builder: (_){
        return StructuredDialog(
          giveRadius: true,
          child: FeedbackWidget(
            title: "Success",
            status: true,
            message: "Resolve Successful",
          ),);
      });
      Navigator.of(context).pop();
    }else{
      showDialog(context: context,builder: (_){
        return StructuredDialog(
          giveRadius: true,
          child: FeedbackWidget(
            title: "Error",
            status: false,
            message: result,
          ),);
      });
    }


  }

  @override
  void initState() {
    checkResolved();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text(
          "Request Details",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.message),
            onPressed: () {},
            color: Colors.white,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 10),
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: 250,
              decoration: BoxDecoration(
                color: CustomColors.REMIS_PURPLE,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SvgPicture.asset(
                    Constants.getAssetGeneralName("maintenance", "svg"),
                    color: Colors.white,
                    width: 50,
                    height: 100,
                  ),
                  Text(
                    widget.request.branchName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (showResolved)
                    GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                insetPadding: EdgeInsets.all(10.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: SingleTextFieldDialog(
                                  title: "INPUT COST OF REPAIRS",
                                  inputType: TextInputType.number,
                                  hint: "",
                                  notShowText: false,
                                  function: textFromDialog,
                                ),
                              );
                            });
                      },
                      child: Container(
                        height: 55,
                        width: MediaQuery.of(context).size.width / 2,
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "MARK AS RESOLVED",
                              style: TextStyle(
                                  color: CustomColors.REMIS_PURPLE,
                                  fontWeight: FontWeight.w600),
                            ),
                            Icon(Icons.done)
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.calendar_today,
                        color: CustomColors.REMIS_DARK_PURPLE, size: 30),
                    title: Text(
                      "Request Date",
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.w400),
                    ),
                    subtitle: Text(
                      widget.request.date.toString(),
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.build,
                      color: CustomColors.REMIS_DARK_PURPLE,
                      size: 30,
                    ),
                    title: Text(
                      "Type of Request Pump",
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.w400),
                    ),
                    subtitle: Text(
                      widget.request.typeName,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.edit,
                      color: CustomColors.REMIS_DARK_PURPLE,
                      size: 30,
                    ),
                    title: Text(
                      "Description",
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.w400),
                    ),
                    subtitle: Text(
                      widget.request.description,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
