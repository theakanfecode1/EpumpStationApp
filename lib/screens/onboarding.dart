import 'dart:async';

import 'package:epump/values/colors.dart';
import 'package:epump/values/constants.dart';
import 'package:flutter/material.dart';

class Onboarding extends StatefulWidget {
  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  PageController _pageController = PageController();
  int _index = 0;
  Timer _timer;

  void setUpTimer() {
    _timer = Timer(Duration(seconds: 5), () {
      setState(() {
        if (_index == 2) {
          _index = 0;
        } else {
          _index++;
        }
      });
      _pageController.animateToPage(
        _index,
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
      setUpTimer();
    });
  }

  @override
  void initState() {
    setUpTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 10),
          child: Column(
            children: <Widget>[
              SizedBox(height: 50,),

              Image.asset(
                Constants.getAssetGeneralName("epumplogo", "png"),
                color: CustomColors.REMIS_DARK_PURPLE,
                width: 300,
              ),
              SizedBox(height: 50,),
              Stack(
                children: <Widget>[
                  Positioned(
                    top: 310,
                    left: 5,
                    right: 5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          color: _index == 0
                              ? CustomColors.REMIS_PURPLE
                              : CustomColors.REMIS_LIGHT_PURPLE,
                          width: 40,
                          height: 6,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          color: _index == 1
                              ? CustomColors.REMIS_PURPLE
                              : CustomColors.REMIS_LIGHT_PURPLE,
                          width: 40,
                          height: 6,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          color: _index == 2
                              ? CustomColors.REMIS_PURPLE
                              : CustomColors.REMIS_LIGHT_PURPLE,
                          width: 40,
                          height: 6,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 500,
                    child: PageView(
                      onPageChanged: (index) {
                        setState(() {
                          _index = index;
                        });
                        _timer.cancel();
                        setUpTimer();
                      },
                      controller: _pageController,
                      children: <Widget>[
                        OnboardingItems("businessonboard", "Business Management",
                            "E-pump helps manage your entire business effectively and efficiently."),
                        OnboardingItems("electronics", "Electronic Payment",
                            "E-pump brings to you cashless payment methods via vouchers and electronic cards."),
                        OnboardingItems("reportmanagement", "Report Generation",
                            "E-pump helps to generate Sales, Operational,Financial e.t.c reports in P.D.F, graphs, Word e.t.c for business intelligence."),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                height: 56,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  color: CustomColors.REMIS_PURPLE,
                  onPressed: () =>
                      Navigator.of(context).pushReplacementNamed("/login"),
                  child: Text(
                    "Login",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingItems extends StatelessWidget {
  final image;
  final title;
  final subtitle;

  OnboardingItems(this.image, this.title, this.subtitle);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Image.asset(
            Constants.getAssetGeneralName(image, "png"),
            width: 300,
            height: 300,
          ),
          SizedBox(
            height: 60,
          ),
          Text(
            title,
            style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.w600,
                color: CustomColors.REMIS_PURPLE),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 3,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                subtitle,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
