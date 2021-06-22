import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:water_tracker/Models/SettingsModel.dart';
import 'package:water_tracker/Widgets/onboarding/ActivitySelection.dart';
import 'package:water_tracker/Widgets/onboarding/GenderSelection.dart';
import 'package:water_tracker/Widgets/shared/InfoCard.dart';
import 'package:water_tracker/Widgets/onboarding/WeightSelection.dart';
import 'package:easy_localization/easy_localization.dart';

import '../Models/SettingsModel.dart';
import '../Widgets/onboarding/ActivitySelection.dart';
import '../Widgets/onboarding/GenderSelection.dart';
import '../Widgets/shared/InfoCard.dart';
import '../Widgets/onboarding/WeightSelection.dart';
import '../main.dart';

class Onbording extends StatefulWidget {
  static String id = 'Onbording';
  @override
  _OnbordingState createState() => _OnbordingState();
}

class _OnbordingState extends State<Onbording> {
  int currentIndex = 0;
  int selectActivity;
  PageController _controller;
  List<String> subtitle = [
    "Please select your gender:",
    "Please select your weight:",
    "Your Lifestyle activity level:"
  ];

  List<String> infos = [
    " ... water lubricates the joints and the disks of the spine which contains around 80% water!",
    "... water forms saliva and mucus, which helps us to keep the mouth, nose and eyes moist and prevents friction damage!",
    "... water delivers oxygen throughout the body. Blood is more than 90% water and carries the oxygen to different parts of the body!"
  ];

  List<Widget> introWidget = [GenderSelection(), WeightSelection(),ActivitySelection()];



  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
    selectActivity = 0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final introKey = GlobalKey<_OnbordingState>();

  SetData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen', true);
    context.read<SettingsModel>().updateIntroSeen(true);
  }

  // setSelectGender(int val) {
  //   setState(() {
  //     selectGender = val;
  //   });
  // }

  setSelectActivity(int val) {
    setState(() {
      selectActivity = val;
    });
  }

  void _onIntroEnd(context) {
    SetData();
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => WaterTrackerApp()),
    );
  }

  @override
  Widget build(BuildContext context) {
    const color1 = const Color(0xffb3d9f1);
    const color2 = const Color(0xffeef6fb);


    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[color1, color2],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: SafeArea(
                  child: Padding(
                      padding: const EdgeInsets.only(top: 0, right: 0, left: 0),
                      child: Column(
                        children: [
                          Container(
                              child: AutoSizeText(
                            "Welcome to Aquapido",
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 30.0, fontWeight: FontWeight.w700),
                          )),
                          Container(
                              child: AutoSizeText(
                            "\nWe need some information about you, to give you the best advise and a wonderful experience.",
                            maxLines: 3,
                            minFontSize: 10,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14.0),
                          )),
                        ],
                      )),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: 3,
                  onPageChanged: (int index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  itemBuilder: (_, i) {
                    return Padding(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        children: [
                          Container(
                              //margin:EdgeInsets.fromLTRB(0,0,0,MediaQuery.of(context).size.height / 80,) ,
                              padding: EdgeInsets.fromLTRB(
                                0,
                                MediaQuery.of(context).size.height / 80 +
                                    MediaQuery.of(context).padding.top,
                                0,
                                0,
                              ),
                              child: AutoSizeText(
                                subtitle[i],
                                maxLines: 1,
                                minFontSize: 10,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w700),
                              )),
                          introWidget[i]
                        ],
                      ),
                    );
                  },
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 1.1,
                margin: EdgeInsets.all(5),
                child: InfoCard(
                  title: "\nDid you know that ...",
                  text: tr("infos.info"+currentIndex.toString()),
                ),
              ),
              Row(children: [
                Container(
                  height: MediaQuery.of(context).size.height / 15,
                  margin: EdgeInsets.all(0),
                  width: MediaQuery.of(context).size.width / 3.5,
                  child: TextButton(
                    child: Text("LATER"),
                    onPressed: () {
                      context.read<SettingsModel>().updateGender("choose");
                      context.read<SettingsModel>().setWeight(70);
                      _onIntroEnd(context);
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width / 7, 0, MediaQuery.of(context).size.width / 7, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: List.generate(
                      3,
                      (index) => buildDot(index, context),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height / 15,
                  //margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width / 4, 0, 0, 0),
                  width: MediaQuery.of(context).size.width / 3.5,
                  child: ElevatedButton(
                    child: Text(currentIndex == 3 - 1 ? "START" : "NEXT"),
                    onPressed: () {

                      if (currentIndex == 2) {
                       _onIntroEnd(context);

                      }
                      _controller.nextPage(
                        duration: Duration(milliseconds: 200),
                        curve: Curves.bounceIn,
                      );
                    },
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(10),)
                    )
                  ),
                ),
              ])
            ],
          ),
        ));
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 10,
      width:  10,
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: currentIndex == index ? Colors.blue : Colors.grey
      ),
    );
  }
}
