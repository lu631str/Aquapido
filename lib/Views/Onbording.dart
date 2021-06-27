import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

import '../src/Models/SettingsModel.dart';
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
  PageController _controller;
  List<String> subtitle = [
    tr('onbording.title_widget1'),
    tr('onbording.title_widget2'),
    tr('onbording.title_widget3')
  ];

  List<Widget> introWidget = [GenderSelection(), WeightSelection(),ActivitySelection()];

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final introKey = GlobalKey<_OnbordingState>();

  setData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen', true);
    context.read<SettingsModel>().updateIntroSeen(true);
  }



  void _onIntroEnd(context) {
    setData();
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
                                tr('onbording.title'),
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 30.0, fontWeight: FontWeight.w700),
                          )),
                          Container(
                              child: AutoSizeText(
                                tr('onbording.subtitle'),
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
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
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
                  title: "\n"+tr('infos.title'),
                  text: tr("infos.info"+currentIndex.toString()),
                ),
              ),
              Row(children: [
                Container(
                  height: MediaQuery.of(context).size.height / 15,
                  margin: EdgeInsets.all(0),
                  width: MediaQuery.of(context).size.width / 3.5,
                  child: TextButton(
                    child: Text(tr('onbording.later')),
                    onPressed: () {
                      context.read<SettingsModel>().updateGender("choose");
                      context.read<SettingsModel>().updateActivity("normal");
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
                    child: Text(currentIndex == 3 - 1 ? "START" : tr('onbording.next')),
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
