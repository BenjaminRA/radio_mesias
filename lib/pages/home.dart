import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:matrix4_transform/matrix4_transform.dart';
import 'package:radio_mesias/helpers/colors.dart' as colors;
import 'package:radio_mesias/helpers/ui.dart' as ui;
import 'package:radio_mesias/helpers/api.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String activeTab;
  List<RecientementeContainer> recientes;
  List<ArticleTile> news;

  @override
  void initState() {
    super.initState();
    Api.getRecientes().then((value) => setState(() => recientes = value));
  }

  void onPressed(title) {
    Api.getNoticias().then((value) => setState(() => news = value));
    setState(() => activeTab = activeTab == title ? null : title);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.only(
                    bottom: 5.0, left: 20.0, right: 20.0, top: 20.0),
                child: Text(
                  'Recientemente',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: 170.0,
                child: recientes == null
                    ? Container(
                        alignment: Alignment.center,
                        child: ui.isAndroid
                            ? CircularProgressIndicator()
                            : CupertinoActivityIndicator(),
                      )
                    : ListView(
                        scrollDirection: Axis.horizontal,
                        children: recientes,
                      ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    width: double.infinity,
                    margin:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                    child: Text(
                      'Más para leer',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 24.0),
                    ),
                  ),
                  LinkToPageTile(
                    icon: 'assets/icons/noticias.png',
                    title: 'Noticias',
                    selected: activeTab,
                    onPressed: onPressed,
                  ),
                  LinkToPageTile(
                      icon: 'assets/icons/reflexiones.png',
                      title: 'Reflexiones',
                      selected: activeTab,
                      onPressed: onPressed),
                  LinkToPageTile(
                      icon: 'assets/icons/consultorio.png',
                      title: 'Consultorio',
                      selected: activeTab,
                      onPressed: onPressed),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ArticleTile extends StatelessWidget {
  final String title;
  final String date;
  final String image;

  ArticleTile({this.title, this.date, this.image});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class RecientementeContainer extends StatelessWidget {
  final String title;
  final String image;
  final String category;

  RecientementeContainer({this.title, this.image, this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.0,
      margin: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
        color: Colors.white,
        image: DecorationImage(
          image: NetworkImage(
            image,
          ),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.green,
            offset: Offset(0.0, 0.0),
            blurRadius: 6.0,
            spreadRadius: -2.0,
          )
        ],
      ),
      padding: EdgeInsets.all(10.0),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Text(
          title,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: Colors.black,
                  blurRadius: 2.5,
                ),
              ]),
        ),
      ),
    );
  }
}

class LinkToPageTile extends StatelessWidget {
  final String icon;
  final String title;
  final String selected;
  final Function onPressed;

  LinkToPageTile({this.icon, this.title, this.selected, this.onPressed});

  @override
  Widget build(BuildContext context) {
    Widget child = Row(
      children: <Widget>[
        Flexible(
          fit: FlexFit.tight,
          flex: 1,
          child: Image.asset(
            icon,
            color: selected == title ? colors.green : Colors.black,
          ),
        ),
        Flexible(
          fit: FlexFit.tight,
          flex: 4,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: selected == title ? colors.green : Colors.black,
              fontSize: 24.0,
            ),
          ),
        ),
        Flexible(
          fit: FlexFit.tight,
          flex: 1,
          child: Stack(
            children: <Widget>[
              AnimatedOpacity(
                duration: Duration(milliseconds: 200),
                opacity: selected == title ? 0.0 : 1.0,
                child: Image.asset(
                  'assets/icons/forward.png',
                  color: selected == title ? colors.green : Colors.black,
                ),
              ),
              AnimatedOpacity(
                duration: Duration(milliseconds: 200),
                opacity: selected == title ? 1.0 : 0.0,
                child: Transform.rotate(
                  angle: pi / 2,
                  child: Image.asset(
                    'assets/icons/forward.png',
                    color: selected == title ? colors.green : Colors.black,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );

    Function callback = () {
      onPressed(title);
    };
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          color: Colors.white,
        ),
        // constraints: BoxConstraints(
        //   maxHeight: selected == title ? double.infinity : 60.0,
        // ),
        child: Column(
          children: <Widget>[
            ui.isAndroid
                ? FlatButton(onPressed: callback, child: child)
                : CupertinoButton(child: child, onPressed: callback),
            AnimatedContainer(
              curve: Curves.easeInOutSine,
              duration: Duration(milliseconds: 500),
              height: selected == title ? 500.0 : 0.0,
              child: Container(
                color: Colors.white,
                height: 500.0,
              ),
            )
          ],
        ));
  }
}
