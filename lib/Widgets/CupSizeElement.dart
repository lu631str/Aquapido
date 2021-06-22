import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Utils/Constants.dart';
import '../Utils/Utils.dart';
import '../Models/SettingsModel.dart';

class CupSizeElement extends StatelessWidget {
  final int size;
  final bool isCustom;
  final BuildContext mainContext;
  final BuildContext dialogContext;

  CupSizeElement(
      {this.size, this.isCustom, this.mainContext, this.dialogContext});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TextButton(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Constants.cupImages[getImageIndex(size)],
              Text('${size}ml'),
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
                      Provider.of<SettingsModel>(mainContext, listen: false)
                          .deleteCustomCupSize(size);
                  },
                )
              : Text(''),
        ),
      ],
    );
  }
}
