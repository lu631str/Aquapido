import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../../Models/SettingsModel.dart';

class QuickAddDialogInfo extends StatefulWidget {
  final String title, descriptions, text;
  final Image img;

  const QuickAddDialogInfo(
      {Key key, this.title, this.descriptions, this.text, this.img})
      : super(key: key);

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<QuickAddDialogInfo> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(children: [
      Container(
        width: MediaQuery.of(context).size.width / 1.3,
        height: MediaQuery.of(context).size.height / 1.5,
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: const Color(0xFFFFFF),
          borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
        ),
        child: Scrollbar(
          controller: _scrollController,
            isAlwaysShown: (MediaQuery.of(context).size.height < 760)
                ?true
                :false,
            child: SingleChildScrollView(
                controller: _scrollController,
              dragStartBehavior: DragStartBehavior.start,
                child: Column(
          children: [
            AutoSizeText(
              '‘Quick Add’ functions!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w700),
              maxLines: 1,
              minFontSize: 10,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(
                  0,
                  MediaQuery.of(context).size.height / 80,
                  0,
                  MediaQuery.of(context).size.height / 80),
              child: Image.asset('assets/images/shake.png'),
              width: MediaQuery.of(context).size.width / 1.4,
              height: MediaQuery.of(context).size.height / 4.5,
            ),
            AutoSizeText(
              'Quick add Shaking',
              maxLines: 1,
              minFontSize: 10,
              style: TextStyle(fontSize: 14.0),
            ),
            Container(
                margin: EdgeInsets.fromLTRB(
                    0,
                    MediaQuery.of(context).size.height / 80,
                    0,
                    MediaQuery.of(context).size.height / 80),
                child: Image.asset('assets/images/powerbutton.jpg'),
                width: MediaQuery.of(context).size.width / 1.6,
                height: MediaQuery.of(context).size.height / 4.7),
            AutoSizeText(
              'Quick add 2x Power Button',
              maxLines: 1,
              minFontSize: 6,
              style: TextStyle(fontSize: 14.0),
            ),
            const Divider(
              height: 40,
              thickness: 1,
              indent: 0,
              endIndent: 0,
            ),
            ElevatedButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.pop(context);
                Provider.of<SettingsModel>(context, listen: false)
                    .updateDialogSeen(true);
              },
            ),
          ],
        ) //Contents here
                )),
      ),
    ]);
  }
}
