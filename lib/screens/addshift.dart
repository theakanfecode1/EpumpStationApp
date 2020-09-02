import 'package:epump/customwidgets/feedbackwidget.dart';
import 'package:epump/customwidgets/structureddialog.dart';
import 'package:epump/screens/loadingscreen.dart';
import 'package:epump/stores/branchstores/addshiftstore.dart';
import 'package:epump/utils/networkcalls/networkstrings.dart';
import 'package:epump/values/colors.dart';
import 'package:epump/values/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class AddShift extends StatefulWidget {
  @override
  _AddShiftState createState() => _AddShiftState();
}

class _AddShiftState extends State<AddShift> {

  TextEditingController _shiftTitleController = TextEditingController();


  @override
  void dispose() {
    _shiftTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final addShiftStore = Provider.of<AddShiftStore>(context);
    return Scaffold(
      appBar: Constants.showCustomAppBar("Add Shift"),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 150,
              width: MediaQuery.of(context).size.width,
              color: CustomColors.REMIS_PURPLE,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SvgPicture.asset(
                    Constants.getAssetGeneralName("stopwatchdrawer", "svg"),
                    color: Colors.white,
                    width: 80,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: TextField(
                controller: _shiftTitleController,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 18),
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: "Shift Title (e.g Afternoon shiftAssignment)",

                  labelStyle: TextStyle(
                      fontSize: 18,
                      color: CustomColors.REMIS_PURPLE,
                    fontWeight: FontWeight.w400,),
                  isDense: true,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(
                        color: CustomColors.REMIS_PURPLE,
                      )),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(
                        color: CustomColors.REMIS_PURPLE,
                      )),
//        enabledBorder: OutlineInputBorder(
//            borderRadius: BorderRadius.all(Radius.circular(10.0)),
//            borderSide: BorderSide(color: Colors.white,)
//        ),
                ),
                onSubmitted: (text) {
                  FocusScope.of(context).unfocus();
                },
              ),
            ),
            SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: SizedBox(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  child: RaisedButton(onPressed: () async {
                    Navigator.of(context).push(LoadingWidget.showLoadingScreen("Adding Shift"));
                    String result = await addShiftStore.addShift(_shiftTitleController.text);
                    Navigator.of(context).pop();
                    if(result != NetworkStrings.SUCCESSFUL){
                      showDialog(context: context,builder: (_){
                        return StructuredDialog(
                          giveRadius: true,
                          child: FeedbackWidget(
                          title: "Error",
                          status: false,
                          message: result,
                        ),);
                      });
                    }else{
                      await showDialog(context: context,builder: (_){
                        return StructuredDialog(
                          giveRadius: true,
                          child: FeedbackWidget(
                          title: "Successful",
                          status: true,
                          message: "Shift Successfully Added",
                        ),);
                      });
                      Navigator.of(context).pop();

                    }
                  },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(bottomRight:Radius.circular(10),bottomLeft:Radius.circular(10))
                    ),
                    color: CustomColors.REMIS_PURPLE,child: Text("SUBMIT",style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 20
                    ),),)),
            )



          ],
        ),
      ),
    );
  }
}
