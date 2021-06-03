import 'package:flutter/material.dart';
import '../Views/home.dart';
import '../Models/Water.dart';

class HistoryListElement extends StatelessWidget {
  final int _index;
  final IconData _icon;
  final Water _water;
  final DeleteCallback _deleteCallback;
  final double _iconCircleSize = 44;
  final double _cardHeight = 40;

  HistoryListElement(
      this._index, this._icon, this._water, this._deleteCallback);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: Stack(children: [
          Card(
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.black87, width: 1),
                borderRadius: BorderRadius.circular(32),
              ),
              child: Container(
                height: this._cardHeight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Text(this._water.toCupSizeString()),
                      margin: const EdgeInsets.only(left: 60),
                    ),
                    Text(this._water.toDateString()),
                    Row(
                      children: [
                        VerticalDivider(
                          indent: 5,
                          endIndent: 5,
                          thickness: 0.8,
                          width: 1,
                        ),
                        IconButton(
                          icon: IconTheme(
                              data: IconThemeData(
                                  color: this._water.isPlaceholder
                                      ? Colors.black26
                                      : Colors.black87),
                              child: Icon(Icons.delete)),
                          onPressed: this._water.isPlaceholder
                              ? null
                              : () {
                                  ScaffoldMessenger.of(context)
                                      .removeCurrentSnackBar();
                                  this._deleteCallback(this._index);
                                },
                        ),
                      ],
                    )
                  ],
                ),
              )),
          Positioned(
            bottom: 2,
            child: Container(
              height: this._iconCircleSize,
              width: this._iconCircleSize,
              child: Icon(_icon),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xF2000000),
                    ),
                    BoxShadow(
                        color: Color(0xFFC2DBFF),
                        spreadRadius: -1,
                        blurRadius: 1.0,
                        offset: Offset(0, 1)),
                  ],
                  borderRadius: BorderRadius.circular(120),
                  border: Border.all(color: Colors.black87)),
              padding: EdgeInsets.all(10),
            ),
          )
        ]));
  }
}
