import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:radio_mesias/components/tabScaffold.dart';
import 'package:radio_mesias/helpers/ui.dart' as ui;

import 'package:radio_mesias/pages/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ui.isAndroid
        ? MaterialApp(
            title: 'Radio Mesías',
            theme: ThemeData(
              fontFamily: 'Roboto',
              primarySwatch: Colors.green,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: AudioServiceWidget(
              child: HomePage(),
            ),
          )
        : CupertinoApp(
            title: 'Radio Mesías',
            home: AudioServiceWidget(
              child: HomePage(),
            ),
          );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TabScaffold(
      pages: <Widget>[
        MainPage(),
        Container(
          child: Center(
            child: Text('Página #2'),
          ),
        ),
        Container(
          child: Center(
            child: Text('Página #3'),
          ),
        ),
        Container(
          child: Center(
            child: Text('Página #4'),
          ),
        )
      ],
      tabs: [
        ScaffoldTab(
          icon: Icon(Icons.home),
          title: Text('Portada'),
        ),
        ScaffoldTab(
          icon: Icon(Icons.people),
          title: Text('Quienes somos'),
        ),
        ScaffoldTab(
          icon: Icon(Icons.calendar_today),
          title: Text('Programación'),
        ),
        ScaffoldTab(
          icon: Icon(Icons.live_tv),
          title: Text('En vivo'),
        ),
      ],
    );
    // return AppScaffold(
    //   body: Container(
    //     child: ListView(
    //       children: [
    //         Container(
    //           color: green,
    //           padding: EdgeInsets.all(7.0),
    //           child: Text(
    //             'Ahora transmitiendo',
    //             textAlign: TextAlign.center,
    //             style: TextStyle(
    //               color: Colors.white,
    //               fontWeight: FontWeight.w300,
    //               fontSize: 20,
    //             ),
    //           ),
    //         ),
    //         Container(
    //           color: Colors.black,
    //           height: 80,
    //           margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
    //           child: Row(
    //             children: <Widget>[
    //               Flexible(
    //                 fit: FlexFit.tight,
    //                 flex: 1,
    //                 child: AudioService.running
    //                     ? loading
    //                         ? Transform.scale(
    //                             scale: 1.7,
    //                             child: Container(
    //                               alignment: Alignment.center,
    //                               child: FlareActor(
    //                                 "assets/loading.flr",
    //                                 alignment: Alignment.center,
    //                                 animation: "Loading",
    //                               ),
    //                             ),
    //                           )
    //                         : FlatButton(
    //                             onPressed: playing ? _stop : _play,
    //                             child: Transform.scale(
    //                               scale: 1.5,
    //                               child: Container(
    //                                 padding: EdgeInsets.all(15.0),
    //                                 child: Image.asset(
    //                                   playing
    //                                       ? 'assets/pause.png'
    //                                       : 'assets/play.png',
    //                                   color: Colors.white,
    //                                 ),
    //                               ),
    //                             ),
    //                           )
    //                     : FlatButton(
    //                         onPressed: () {
    //                           setState(() {
    //                             loading = true;
    //                             playing = false;
    //                           });
    //                           AudioService.start(
    //                             backgroundTaskEntrypoint:
    //                                 _backgroundTaskEntrypoint,
    //                           ).then((value) {
    //                             AudioService.customAction(
    //                                 'setMediaItem', _mediaItem());
    //                           });
    //                         },
    //                         child: Transform.scale(
    //                           scale: 1.5,
    //                           child: Container(
    //                             padding: EdgeInsets.all(15.0),
    //                             child: Image.asset(
    //                               'assets/play.png',
    //                               color: Colors.white,
    //                             ),
    //                           ),
    //                         ),
    //                       ),
    //               ),
    //               // Flexible(
    //               //   fit: FlexFit.tight,
    //               //   flex: 2,
    //               //   child: Stack(
    //               //     alignment: Alignment.center,
    //               //     children: schedule.length == 0
    //               //         ? [
    //               //             Text(
    //               //               'Programa no disponible',
    //               //               textAlign: TextAlign.center,
    //               //               softWrap: true,
    //               //               style: TextStyle(
    //               //                 color: green,
    //               //                 fontWeight: FontWeight.bold,
    //               //                 fontSize: 24,
    //               //               ),
    //               //             )
    //               //           ]
    //               //         : <Widget>[
    //               //             AnimatedContainer(
    //               //               duration: Duration(
    //               //                   milliseconds: transition ? 500 : 0),
    //               //               curve: Curves.easeInOut,
    //               //               transform: Matrix4.translationValues(
    //               //                   0.0, transition ? -50.0 : 0.0, 0.0),
    //               //               child: AnimatedOpacity(
    //               //                 opacity: transition ? 0.0 : 1.0,
    //               //                 duration: Duration(
    //               //                     milliseconds: transition ? 500 : 0),
    //               //                 child: lectureBuilder(schedule[0]),
    //               //               ),
    //               //             ),
    //               //             schedule.length == 1
    //               //                 ? Container()
    //               //                 : AnimatedContainer(
    //               //                     duration: Duration(
    //               //                         milliseconds: transition ? 500 : 0),
    //               //                     curve: Curves.easeInOut,
    //               //                     transform: Matrix4.translationValues(
    //               //                         0.0, transition ? 0.0 : 50.0, 0.0),
    //               //                     child: AnimatedOpacity(
    //               //                       opacity: transition ? 1.0 : 0.0,
    //               //                       duration: Duration(
    //               //                           milliseconds:
    //               //                               transition ? 500 : 0),
    //               //                       child: lectureBuilder(schedule[1]),
    //               //                     ),
    //               //                   ),
    //               //           ],
    //               //   ),
    //               // ),
    //             ],
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
