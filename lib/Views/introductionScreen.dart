import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:water_tracker/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Widgets/InfoCard.dart';

class IntroScreen extends StatefulWidget {
  static String id = 'IntroScreen';

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  List<String> infos = [
    " ... water lubricates the joints and thed isks of the spine which contains around 80% water!",
    "... water forms saliva and mucus, which helps us to keep the mouth, nose and eyes moist and prevents friction damage!",
    "... water delivers oxygen throughout the body. Blood is more than 90% water and carries the oxygen to different parts of the body!"
  ];
  int selectGender;
  int selectActivity;
  String _weightUnit = 'kg';
  int _selectedWeight = 45;

  @override
  void initState() {
    super.initState();
    selectGender = 0;
    selectActivity = 0;
  }

  final introKey = GlobalKey<IntroductionScreenState>();

  SetSeenToTrue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen', true);
  }

  SetSeenToFalse() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen', false);
  }

  setSelectGender(int val) {
    setState(() {
      selectGender = val;
    });
  }

  setSelectActivity(int val) {
    setState(() {
      selectActivity = val;
    });
  }

  void _onIntroEnd(context) {
    SetSeenToTrue();
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => WaterTrackerApp()),
    );
  }



  @override
  Widget build(BuildContext context) {
    const color1 = const Color(0xffb3d9f1);
    const color2 = const Color(0xffeef6fb);
    const bodyStyle = TextStyle(fontSize: 14.0);

    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      imagePadding: EdgeInsets.zero,
    );

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[color1, color2],
        ),
      ),
      child: IntroductionScreen(
        key: introKey,
        globalBackgroundColor: Colors.transparent,
        globalHeader: Align(
          alignment: Alignment.topRight,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 16, right: 16),
            ),
          ),
        ),

        pages: [
          PageViewModel(
            title: "Welcome to Aquapido",
            bodyWidget: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    margin: EdgeInsets.all(15.0),
                    padding: EdgeInsets.all(0),
                    child: Text(
                      "We need some information about you, to give you the best advise and a wonderful experience.",
                      textAlign: TextAlign.start,
                      style: bodyStyle,
                    )),
                Container(
                    margin: EdgeInsets.all(30.0),
                    padding: EdgeInsets.all(0),
                    child: Text(
                      "Please select your gender:",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14.0, fontWeight: FontWeight.w700),
                    )),
                Column(
                  children: <Widget>[
                    Container(
                      width: 200,
                      margin: EdgeInsets.all(20.0),
                      padding: EdgeInsets.all(0),

                      decoration: BoxDecoration(
                          color: (selectGender == 1)
                              ? Colors.blue
                              : Colors.transparent,
                          border: Border.all(
                            color: Colors.blue,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      // color: Colors.blue,
                      child: RadioListTile(
                        value: 1,
                        title: Text(
                          "Male",
                          style: (selectGender == 1)
                              ? TextStyle(color: Colors.white)
                              : TextStyle(color: Colors.black),
                          textAlign: TextAlign.start,
                        ),
                        groupValue: selectGender,
                        activeColor: Colors.white,
                        onChanged: (val) {
                          print("Radio $val");
                          setSelectGender(val);
                        },
                      ),
                    ),
                    Container(
                        width: 200,
                        margin: EdgeInsets.fromLTRB(0, 20, 0, 60),
                        padding: EdgeInsets.all(0),
                        decoration: BoxDecoration(
                            color: (selectGender == 2)
                                ? Colors.blue
                                : Colors.transparent,
                            border: Border.all(
                              color: Colors.blue,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: RadioListTile(
                          value: 2,
                          title: Text(
                            "Female",
                            textAlign: TextAlign.start,
                            style: (selectGender == 2)
                                ? TextStyle(color: Colors.white)
                                : TextStyle(color: Colors.black),
                          ),
                          groupValue: selectGender,
                          activeColor: Colors.white,
                          onChanged: (val) {
                            print("Radio $val");
                            setSelectGender(val);
                          },
                        )),
                  ],
                )
              ],
            ),
            footer: new Stack(children: [
              InfoCard(
                title: "Did you know that ...",
                text: infos[0],
              ),
              Divider(
                height: 300,
                thickness: 1,
                indent: 0,
                endIndent: 0,
              ),
            ]),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: "Welcome to Aquapido",
            bodyWidget: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    margin: EdgeInsets.all(15.0),
                    padding: EdgeInsets.all(0),
                    child: Text(
                      "We need some information about you, to give you the best advise and a wonderful experience.",
                      textAlign: TextAlign.start,
                      style: bodyStyle,
                    )),
                Container(
                    margin: EdgeInsets.all(30.0),
                    padding: EdgeInsets.all(0),
                    child: Text(
                      "Please select your weight:",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14.0, fontWeight: FontWeight.w700),
                    )),
                Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 18, 0, 22),
                      constraints: BoxConstraints(
                          minWidth: 200,
                          maxWidth: 200,
                          minHeight: 196,
                          maxHeight: 196),
                      child: Card(
                        color: Color.fromARGB(255, 219, 237, 255),
                        elevation: 2,
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: NumberPicker(
                          value: _selectedWeight,
                          minValue: 40,
                          maxValue: 150,
                          haptics: true,
                          itemCount: 5,
                          itemHeight: 32,
                          textMapper: (numberText) =>
                              numberText + ' ' + _weightUnit,
                          onChanged: (value) =>
                              setState(() => _selectedWeight = value),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
            footer: new Stack(children: [
              InfoCard(
                title: "Did you know that ...",
                text: infos[1],
              ),
              Divider(
                height: 300,
                thickness: 1,
                indent: 0,
                endIndent: 0,
              ),
            ]),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: "Welcome to Aquapido",
            bodyWidget: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    margin: EdgeInsets.all(10.0),
                    padding: EdgeInsets.all(0),
                    child: Text(
                      "We need some information about you, to give you the best advise and a wonderful experience.",
                      textAlign: TextAlign.start,
                      style: bodyStyle,
                    )),
                Container(
                    margin: EdgeInsets.fromLTRB(0, 37, 0, 30),
                    padding: EdgeInsets.all(0),
                    child: Text(
                      "Your Lifestyle activity level:",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14.0, fontWeight: FontWeight.w700),
                    )),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 300,
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                      padding: EdgeInsets.all(0),

                      decoration: BoxDecoration(
                          color: (selectActivity == 1)
                              ? Colors.blue
                              : Colors.transparent,
                          border: Border.all(
                            color: Colors.blue,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      // color: Colors.blue,
                      child: RadioListTile(
                        value: 1,
                        title: Text(
                          "Low (sitting)",
                          style: (selectActivity == 1)
                              ? TextStyle(color: Colors.white)
                              : TextStyle(color: Colors.black),
                          textAlign: TextAlign.start,
                        ),
                        groupValue: selectActivity,
                        activeColor: Colors.white,
                        onChanged: (val) {
                          print("Radio $val");
                          setSelectActivity(val);
                        },
                      ),
                    ),
                    Container(
                        width: 300,
                        margin: EdgeInsets.all(5.0),
                        padding: EdgeInsets.all(0),
                        decoration: BoxDecoration(
                            color: (selectActivity == 2)
                                ? Colors.blue
                                : Colors.transparent,
                            border: Border.all(
                              color: Colors.blue,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: RadioListTile(
                          value: 2,
                          title: Text(
                            "Normal (active)",
                            textAlign: TextAlign.start,
                            style: (selectActivity == 2)
                                ? TextStyle(color: Colors.white)
                                : TextStyle(color: Colors.black),
                          ),
                          groupValue: selectActivity,
                          activeColor: Colors.white,
                          onChanged: (val) {
                            print("Radio $val");
                            setSelectActivity(val);
                          },
                        )),
                    Container(
                        width: 300,
                        margin: EdgeInsets.all(5.0),
                        padding: EdgeInsets.all(0),
                        decoration: BoxDecoration(
                            color: (selectActivity == 3)
                                ? Colors.blue
                                : Colors.transparent,
                            border: Border.all(
                              color: Colors.blue,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: RadioListTile(
                          value: 3,
                          title: Text(
                            "High (very active)",
                            textAlign: TextAlign.start,
                            style: (selectActivity == 3)
                                ? TextStyle(color: Colors.white)
                                : TextStyle(color: Colors.black),
                          ),
                          groupValue: selectActivity,
                          activeColor: Colors.white,
                          onChanged: (val) {
                            print("Radio $val");
                            setSelectActivity(val);
                          },
                        )),
                    Container(
                        width: 300,
                        margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                        padding: EdgeInsets.all(0),
                        decoration: BoxDecoration(
                            color: (selectActivity == 4)
                                ? Colors.blue
                                : Colors.transparent,
                            border: Border.all(
                              color: Colors.blue,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: RadioListTile(
                          value: 4,
                          title: Text(
                            "Very High (Hustler)",
                            textAlign: TextAlign.start,
                            style: (selectActivity == 4)
                                ? TextStyle(color: Colors.white)
                                : TextStyle(color: Colors.black),
                          ),
                          groupValue: selectActivity,
                          activeColor: Colors.white,
                          onChanged: (val) {
                            print("Radio $val");
                            setSelectActivity(val);
                          },
                        )),
                  ],
                )
              ],
            ),
            footer: new Stack(overflow: Overflow.visible, children: [
              Positioned(
                  top: -24,
                  child: InfoCard(
                    title: "Did you know that ...",
                    text: infos[0],
                  )),
              Divider(
                height: 255,
                thickness: 1,
                indent: 0,
                endIndent: 0,
              ),
            ]),
            decoration: pageDecoration,
          ),
        ],
        onDone: () => _onIntroEnd(context),
        onSkip: () => _onIntroEnd(context),
        // You can override onSkip callback
        showSkipButton: true,
        skipFlex: 0,
        nextFlex: 0,
        //rtl: true, // Display as right-to-left
        skip: const Text('LATER'),
        next: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue)),
            child: Text(
              'NEXT',
              style: TextStyle(color: Colors.white),
            )),

        done: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue)),
            child: Text(
              'START',
              style: TextStyle(color: Colors.white),
            )),
        //curve: Curves.fastLinearToSlowEaseIn,
      ),
    );
  }
}
