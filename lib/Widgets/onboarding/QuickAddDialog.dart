import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../../src/Models/SettingsModel.dart';


class QuickAddDialog extends StatefulWidget {
  final String title, descriptions, text;
  final Image img;

  const QuickAddDialog(
      {Key key, this.title, this.descriptions, this.text, this.img})
      : super(key: key);

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<QuickAddDialog> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(children: [
      Container(
          width: MediaQuery.of(context).size.width / 1.3,
          height: MediaQuery.of(context).size.height / 1.4,
          decoration: new BoxDecoration(
            shape: BoxShape.rectangle,
            color: const Color(0xFFFFFF),
            borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
          ),
          child: Scrollbar(
          controller: _scrollController,


    isAlwaysShown: (MediaQuery.of(context).size.height < 600)
              ?true
              :false,
    child: SingleChildScrollView(
    controller: _scrollController,
    dragStartBehavior: DragStartBehavior.start,
          child: Column(
            children: [
              AutoSizeText(
                tr('settings.quick_add_dialog.title2'),
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
                width: MediaQuery.of(context).size.width / 1.7,
                height: MediaQuery.of(context).size.height / 5,

              ),

              SwitchListTile(
                  value: context.watch<SettingsModel>().shakeSettings,
                  title: AutoSizeText(
                    tr('quick_add_dialog.shake'),
                    maxLines: 1,
                    minFontSize: 10,
                    style:
                        TextStyle(fontSize: 14.0),

                  ),
                  onChanged: (value) {
                    setState(() {
                      context.read<SettingsModel>().updateShakeSettings(value);
                    });
                  }),
              Container(
                child:Image.asset('assets/images/powerbutton.jpg'),
                width: MediaQuery.of(context).size.width / 2.2,
                height: MediaQuery.of(context).size.height / 5.7
              ),
              SwitchListTile(
                  value: context.watch<SettingsModel>().powerSettings,
                  title: AutoSizeText(tr('quick_add_dialog.power'),
                    maxLines: 1,
                    minFontSize: 6,
                    style:
                    TextStyle(fontSize: 14.0),),
                  onChanged: (value) {
                    setState(() {
                      context.read<SettingsModel>().updatePowerSettings(value);
                    });
                  }),
              const Divider(
                height: 40,
                thickness: 1,
                indent: 0,
                endIndent: 0,
              ),
              Container(
                margin: EdgeInsets.all(MediaQuery.of(context).size.height / 80),
              child:ElevatedButton(
                child:  Text(tr('quick_add_dialog.save')),
                onPressed: () {
                  Navigator.pop(context);
                  Provider.of<SettingsModel>(context, listen: false)
                      .updateDialogSeen(true);
                },
              )),
            ],
          ) //Contents here
          )),
      ),
    ]);
  }
}
