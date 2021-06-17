import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Utils/Constants.dart';
import '../Utils/Utils.dart';
import '../Models/SettingsModel.dart';

class CupSizeElement extends StatefulWidget {
  final int size;
  final bool isCustom;
  final BuildContext mainContext;
  final BuildContext dialogContext;

  CupSizeElement({Key key, this.size, this.isCustom, this.mainContext, this.dialogContext}) : super(key: key);
  @override
  _CupSizeElementState createState() => _CupSizeElementState(size: size, isCustom: isCustom, mainContext: mainContext, dialogContext: dialogContext);
}

class _CupSizeElementState extends State<CupSizeElement> {
  int size;
  bool isCustom;
  BuildContext mainContext;
  BuildContext dialogContext;

  _CupSizeElementState(
      {this.size, this.isCustom, this.mainContext, this.dialogContext});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TextButton(
          child: Column(
            children: [
              Constants.cupImages[getImageIndex(size)],
              Padding(
                  padding: EdgeInsets.only(top: 4), child: Text('$size ml')),
            ],
          ),
          onPressed: () {
            Provider.of<SettingsModel>(mainContext, listen: false)
                .updateCupSize(size);
            Navigator.pop(dialogContext);
          },
        ),
        Positioned(
          top: -10,
          right: 5,
          child: isCustom
              ? IconButton(
                  icon: IconTheme(
                      data: IconThemeData(color: Colors.black87),
                      child: Icon(Icons.clear)),
                  onPressed: () {
                    setState(() {
                      Provider.of<SettingsModel>(mainContext, listen: false)
                          .deleteCustomCupSize(size);
                    });
                  },
                )
              : Text(''),
        ),
      ],
    );
  }
}
