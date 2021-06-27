import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:grafpix/icons.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:water_tracker/Widgets/goals/MedalType.dart';

class AchievementCircleDialog extends StatefulWidget {
  final String title, descriptions, text;
  final Image img;

  const AchievementCircleDialog(
      {Key key, this.title, this.descriptions, this.text, this.img})
      : super(key: key);

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<AchievementCircleDialog> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(children: [
      Container(
        width: MediaQuery.of(context).size.width / 1.3,
        height: MediaQuery.of(context).size.height / 3.6,
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: const Color(0xFFFFFF),
          borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
        ),
        child: Scrollbar(
          controller: _scrollController,
          isAlwaysShown:
              (MediaQuery.of(context).size.height < 760) ? true : false,
          child: SingleChildScrollView(
            controller: _scrollController,
            dragStartBehavior: DragStartBehavior.start,
            child: Column(
              children: [
                AutoSizeText(
                  tr('goals.title'),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700),
                  maxLines: 1,
                  minFontSize: 10,
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              margin: EdgeInsets.all(3),
                              child: PixMedal(
                                icon: PixIcon.drop,
                                medalType: MedalType.Bronze,
                                radius: MediaQuery.of(context).size.height / 20,
                                iconSize:
                                    MediaQuery.of(context).size.height / 25,
                                iconColor: Colors.blue,
                              )),
                          Container(
                              margin: EdgeInsets.all(3),
                              child: PixMedal(
                                icon: PixIcon.drop,
                                medalType: MedalType.Silver,
                                radius: MediaQuery.of(context).size.height / 20,
                                iconSize:
                                    MediaQuery.of(context).size.height / 25,
                                iconColor: Colors.blue,
                              )),
                          Container(
                              margin: EdgeInsets.all(3),
                              child: PixMedal(
                                icon: PixIcon.drop,
                                medalType: MedalType.Gold,
                                radius: MediaQuery.of(context).size.height / 20,
                                iconSize:
                                    MediaQuery.of(context).size.height / 25,
                                iconColor: Colors.blue,
                              )),
                        ])),
                AutoSizeText(
                  tr('goals.goals_dialog.better_medals'),
                  textAlign: TextAlign.center,
                ),
                const Divider(
                  height: 40,
                  thickness: 1,
                  indent: 0,
                  endIndent: 0,
                ),
                OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(tr('goals.goals_dialog.alright'))),
              ],
            ),
          ),
        ),
      ),
    ]);
  }
}
