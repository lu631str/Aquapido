import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Utils/Constants.dart';
import '../Utils/utils.dart';
import '../Models/SettingsModel.dart';

class CupSizeElement extends StatelessWidget {
  final int size;
  final bool isCustom;

  CupSizeElement({this.size, this.isCustom, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
            title: Text('$size ml'),
            leading: Constants.cupImages[getImageIndex(size)],
            trailing: isCustom ? IconButton(
              icon: IconTheme(
                  data: IconThemeData(color: Colors.black87),
                  child: Icon(Icons.delete)),
              onPressed: () {
                Provider.of<SettingsModel>(context, listen: false)
                    .deleteCustomCupSize(size);
              },
            ) : null,
          );
  }
}
