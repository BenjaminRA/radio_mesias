import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:radio_mesias/helpers/ui.dart' as ui;
import 'package:radio_mesias/helpers/colors.dart' as colors;

class AppScaffold extends StatefulWidget {
  final Widget body;

  AppScaffold({this.body});

  @override
  _AppScaffoldState createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  @override
  Widget build(BuildContext context) {
    return ui.isAndroid
        ? Scaffold(
            body: widget.body,
          )
        : CupertinoPageScaffold(
            child: SafeArea(child: widget.body),
          );
  }
}
