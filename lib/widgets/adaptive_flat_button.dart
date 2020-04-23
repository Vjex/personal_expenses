import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class AdaptiveFlatButton extends StatelessWidget {

final String text;
final Function handlerDatePicker;

AdaptiveFlatButton(this.text,this.handlerDatePicker);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
                      ? CupertinoButton(
                        //color : Colors.blue,    Add color to make the Button as Raised otherwise wil behave as flatbutton.
                          child: Text(
                            text,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: handlerDatePicker,
                        )
                      : FlatButton(
                          textColor: Theme.of(context).primaryColor,
                          child: Text(
                            text,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: handlerDatePicker,
                        );
  }
}