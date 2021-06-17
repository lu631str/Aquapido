import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:water_tracker/Models/SettingsModel.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';

class Constants {
  Constants._();

  static const double padding = 20;
  static const double avatarRadius = 45;
}

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
          child:SingleChildScrollView(
          child: Column(
            children: [
              AutoSizeText(
                'Try out our ‘Quick Add’ functions!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w700),
                maxLines: 1,
                minFontSize: 10,
              ),
              Container(
                child: Image.asset('assets/images/shake.png'),
                width: MediaQuery.of(context).size.width / 1.3,
                height: MediaQuery.of(context).size.height / 5,

              ),

              SwitchListTile(
                  value: context.watch<SettingsModel>().shakeSettings,
                  title: AutoSizeText(
                    'Quick add Shaking',
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
                width: MediaQuery.of(context).size.width / 1.3,
                height: MediaQuery.of(context).size.height / 5
              ),
              SwitchListTile(
                  value: context.watch<SettingsModel>().powerSettings,
                  title: AutoSizeText('Quick add 2x Power Button',
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
              ElevatedButton(
                child: const Text('Save'),
                onPressed: () {
                  Navigator.pop(context);
                  Provider.of<SettingsModel>(context, listen: false)
                      .updateDialogSeen(true);
                },
              ),
            ],
          ) //Contents here
          ),
      ),
    ]);
  }
}
