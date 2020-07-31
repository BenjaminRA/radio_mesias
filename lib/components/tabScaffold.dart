import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:radio_mesias/components/radioPlayer.dart';
import 'package:radio_mesias/helpers/ui.dart' as ui;
import 'package:radio_mesias/helpers/colors.dart' as colors;

class ScaffoldTab {
  Widget icon;
  Widget title;

  ScaffoldTab({this.icon, this.title});
}

class TabScaffold extends StatefulWidget {
  final List<ScaffoldTab> tabs;
  final List<Widget> pages;
  TabScaffold({this.tabs, this.pages});

  @override
  _TabScaffoldState createState() => _TabScaffoldState();
}

class _TabScaffoldState extends State<TabScaffold> {
  int indexTab;

  @override
  void initState() {
    super.initState();
    indexTab = 0;
  }

  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> navBarItems = widget.tabs
        .map(
          (item) => BottomNavigationBarItem(
            icon: item.icon,
            title: item.title,
            backgroundColor: colors.background,
          ),
        )
        .toList();

    return ui.isAndroid
        ? Scaffold(
            backgroundColor: colors.background,
            body: Stack(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 80.0),
                  child: widget.pages[indexTab],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: RadioPlayer(),
                ),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: indexTab,
              onTap: (index) => setState(() => indexTab = index),
              items: navBarItems,
              selectedItemColor: colors.green,
              // unselectedItemColor: colors.darkGreen,
            ))
        : Stack(
            children: <Widget>[
              CupertinoTabScaffold(
                backgroundColor: colors.background,
                tabBar: CupertinoTabBar(
                  items: navBarItems,
                  onTap: (index) => setState(() => indexTab = index),
                  activeColor: colors.green,
                ),
                tabBuilder: (context, index) => SafeArea(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 85.0),
                    child: widget.pages[indexTab],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(bottom: 50.0),
                  child: RadioPlayer(),
                ),
              ),
            ],
          );
  }
}
