import 'dart:async';

import 'package:epump/customwidgets/feedbackwidget.dart';
import 'package:epump/screens/loadingscreen.dart';
import 'package:epump/stores/accountstores/accountloginstore.dart';
import 'package:epump/stores/companystores/companymybranchesstore.dart';
import 'package:epump/utils/networkcalls/networkstrings.dart';
import 'package:epump/values/colors.dart';
import 'package:epump/values/constants.dart';
import 'package:epump/values/gradientcontainer.dart';
import 'package:epump/customwidgets/customtextbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  AnimationController controller;

  Animation<double> animation;

  double beginAnim = 0.0;

  double endAnim = 1.0;

  bool switchButtonColor = false;

  double _width = 0.0;

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    animation = Tween(begin: beginAnim, end: endAnim).animate(controller)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void loginUser(String username, String password) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final loginStore = Provider.of<AccountLoginStore>(context, listen: false);
    Navigator.of(context).push(LoadingWidget.showLoadingScreen("Signing In"));
    String result = await loginStore.loginUser(username, password);
    if (result == NetworkStrings.SUCCESSFUL) {
      if (loginStore.loginDetails.role.toLowerCase() == "branchmanager" ||
          loginStore.loginDetails.role.toLowerCase() == "subbranchmanager" ||
          loginStore.loginDetails.role.toLowerCase() == "supervisor") {
        final companyStore =
            Provider.of<CompanyMyBranchesStore>(context, listen: false);
        await companyStore.getBranch();
        sharedPreferences.setBool("LOGGED_IN", true);
        sharedPreferences.setString("LOGGED_IN_AS", "BRANCHMANAGER");
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacementNamed("/dashboard");

      }
      else if (loginStore.loginDetails.role.toLowerCase() == "companyadmin") {
        final companyStore = Provider.of<CompanyMyBranchesStore>(context, listen: false);
        String result = await companyStore.getCompany();
        if (result == NetworkStrings.SUCCESSFUL) {
          Navigator.of(context).pop();
          sharedPreferences.setBool("LOGGED_IN", true);
          sharedPreferences.setString("LOGGED_IN_AS", "COMPANYADMIN");
          Navigator.of(context).pushReplacementNamed("/companydashboard");
        } else {
          Navigator.of(context).pop();
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(
              "An error occurred",
              style: TextStyle(color: Colors.white),
            ),
            duration: Duration(seconds: 2),
          ));
          setState(() {
            _width = 0.0;
            switchButtonColor = false;
          });
        }
        print("THE RESULT" + result);
      } else {
        Navigator.of(context).pop();
        await showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                insetPadding: EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: FeedbackWidget(
                  title: "ERROR",
                  status: false,
                  message:
                      "${loginStore.loginDetails.role} cannot be granted access",
                ),
              );
            });
        Navigator.of(context).pop();
      }
    } else {
      Navigator.of(context).pop();
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          result,
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(seconds: 2),
      ));
      setState(() {
        _width = 0.0;
        switchButtonColor = false;
      });
    }
  }

  void restartAnimation() {
    controller.reverse();
  }

  void startAnimation() {
    controller.forward();
  }

  onSubmitted(String text) {
    FocusScope.of(context).nextFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: GradientContainer(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                Constants.getAssetGeneralName("epumplogo", "png"),
                width: 250,
                height: 70,
              ),
              SizedBox(height: 10,),
              CustomTextBox(
                controller: usernameController,
                hint: "Username",
                assetName: Constants.getAssetGeneralName("user", "svg"),
                textInputAction: TextInputAction.next,
                textInputType: TextInputType.emailAddress,
                obsecureText: false,
                onSubmitted: onSubmitted,
              ),
              SizedBox(
                height: 20,
              ),
              CustomTextBox(
                controller: passwordController,
                hint: "Password",
                assetName: Constants.getAssetGeneralName("locked", "svg"),
                textInputAction: TextInputAction.done,
                textInputType: null,
                obsecureText: true,
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10, left: 10),
                child: Builder(
                  builder: (context) => GestureDetector(
                    onTap: () async {
//                      startAnimation();
                      setState(() {
                        switchButtonColor = true;
                        _width = MediaQuery.of(context).size.width;
                      });
                      loginUser(
                          usernameController.text == null
                              ? ""
                              : usernameController.text,
                          passwordController.text == null
                              ? ""
                              : passwordController.text);
                    },
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Stack(
                          alignment: Alignment.centerLeft,
                          children: <Widget>[
                            AnimatedContainer(
                              duration: Duration(milliseconds: 1500),
                              height: 60,
                              width: _width,
                              decoration: BoxDecoration(
                                color: CustomColors.REMIS_DARK_PURPLE,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "SIGN IN",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: switchButtonColor
                                          ? Colors.white
                                          : CustomColors.REMIS_PURPLE,
                                      fontWeight: FontWeight.w500),
                                ),
//                            SizedBox(
//                              width: 20,
//                            ),
                                SvgPicture.asset(
                                  Constants.getAssetGeneralName("login", "svg"),
                                  color: switchButtonColor
                                      ? Colors.white
                                      : CustomColors.REMIS_PURPLE,
                                  width: 30,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
