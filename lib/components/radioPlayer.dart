import 'dart:async';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:radio_mesias/radioTask.dart';
import 'package:radio_mesias/models/schedule.dart';
import 'package:radio_mesias/helpers/colors.dart' as colors;
import 'package:radio_mesias/helpers/ui.dart' as ui;

void _backgroundTaskEntrypoint() {
  AudioServiceBackground.run(() => RadioTask());
}

class RadioPlayer extends StatefulWidget {
  @override
  _RadioPlayerState createState() => _RadioPlayerState();
}

class _RadioPlayerState extends State<RadioPlayer> with WidgetsBindingObserver {
  List<Schedule> schedule;
  String song;
  bool playing = false;
  bool transition = false;
  bool stripesFlag = true;
  bool loading = false;
  Timer interval;
  StreamSubscription customEventStream;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Schedule
    // schedule = _getSchedule();

    // Timer Periodic
    // interval = Timer.periodic(Duration(minutes: 1), (Timer timer) async {
    //   List<Schedule> newSchedule = _reorderList(schedule);
    //   if (newSchedule.length != schedule.length) {
    //     AudioService.customAction('setMediaItem', _mediaItem());
    //     setState(() => transition = true);
    //     await Future.delayed(Duration(seconds: 1));
    //     widget.getSchedule();
    //   }
    //   setState(() {
    //     schedule = newSchedule;
    //     stripesFlag = transition ? !stripesFlag : stripesFlag;
    //     transition = false;
    //   });
    // });
    AudioService.customAction('init');

    customEventStream = AudioService.customEventStream.listen((event) {
      print(event);
      if (event['event'] == 'stop') {
        setState(() {
          playing = false;
        });
        // exit(0);
      } else if (event['event'] == 'pause') {
        setState(() {
          playing = false;
        });
      } else if (event['event'] == 'play') {
        setState(() {
          loading = false;
          playing = true;
        });
      } else if (event['event'] == 'schedule') {
        setState(() {
          song = event['data'];
        });
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      AudioService.customAction('init');
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    customEventStream.cancel();
    interval.cancel();
    super.dispose();
  }

  List<Schedule> _getSchedule() {
    return _reorderList(schedule);
  }

  List<Schedule> _reorderList(List<Schedule> list) {
    List<Schedule> aux = [];
    for (int i = 0; i < list.length; ++i) {
      if (i == list.length - 1) {
        aux.add(list[i]);
      } else if (list[i + 1]
          .date
          .isAfter(DateTime.now().subtract(DateTime.now().timeZoneOffset))) {
        aux.add(list[i]);
      }
    }
    return aux;
  }

  List<Schedule> _listToShow(List<Schedule> list) {
    List<Schedule> aux = [];
    if (list.length > 1) {
      aux = list.getRange(1, list.length).toList();
    }

    return aux;
  }

  void _play() async {
    print(AudioService.running);
    if (!AudioService.running) {
      setState(() {
        loading = true;
        playing = false;
      });
      AudioService.start(
        backgroundTaskEntrypoint: _backgroundTaskEntrypoint,
      );
    } else {
      AudioService.play();
      setState(() {
        loading = true;
      });
    }
  }

  void _stop() {
    AudioService.pause();
    setState(() {
      playing = false;
      loading = false;
    });
  }

  // void getSchedule() async {
  //   print('fetching schedule');
  //   try {
  //     http.Response res = await http.get(
  //         'http://app.radiosanadoctrina.cl/json/${days[(DateTime.now().weekday - 1) % 7]}.json');

  //     Map<String, dynamic> today = jsonDecode(utf8.decode(res.bodyBytes));

  //     res = await http.get(
  //         'http://app.radiosanadoctrina.cl/json/${days[(DateTime.now().weekday) % 7]}.json');

  //     Map<String, dynamic> tomorrow = jsonDecode(utf8.decode(res.bodyBytes));

  //     schedule = [];
  //     for (dynamic aux in today['schedule']) {
  //       schedule.add(
  //         Schedule(
  //           lecture: aux['lecture'],
  //           preacher: aux['preacher'],
  //           date: DateTime(
  //             DateTime.now().year,
  //             DateTime.now().month,
  //             DateTime.now().day,
  //             aux['hour'],
  //             aux['minute'],
  //           ).add(Duration(hours: 4)),
  //         ),
  //       );
  //     }

  //     for (dynamic aux in tomorrow['schedule']) {
  //       schedule.add(
  //         Schedule(
  //           lecture: aux['lecture'],
  //           preacher: aux['preacher'],
  //           date: DateTime(
  //             DateTime.now().year,
  //             DateTime.now().month,
  //             DateTime.now().day + 1,
  //             aux['hour'],
  //             aux['minute'],
  //           ).add(Duration(hours: 4)),
  //         ),
  //       );
  //     }

  //     setState(() => schedule = schedule);
  //   } catch (e) {
  //     setState(() => schedule = []);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    Widget mediaIcon = playing
        ? Icon(Icons.pause, color: colors.green)
        : Icon(Icons.play_arrow, color: colors.green);
    Function mediaFunction = playing ? _stop : _play;
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: double.infinity,
            color: colors.yellow,
            padding: EdgeInsets.all(5.0),
            child: Text(
              'Ahora transmitiendo',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Flexible(
                fit: FlexFit.tight,
                flex: 8,
                child: Container(
                  margin: EdgeInsets.only(left: 15.0, top: 10.0, bottom: 10.0),
                  child: Text(
                    song != null ? song : 'La bíblia dice',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: colors.green),
                  ),
                ),
              ),
              Flexible(
                  fit: FlexFit.tight,
                  flex: 2,
                  child: Container(
                    height: 56.0,
                    child: loading
                        ? ui.isAndroid
                            ? Container(
                                alignment: Alignment.center,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      colors.green),
                                ),
                              )
                            : CupertinoActivityIndicator()
                        : ui.isAndroid
                            ? IconButton(
                                icon: mediaIcon,
                                onPressed: mediaFunction,
                              )
                            : CupertinoButton(
                                child: mediaIcon,
                                onPressed: mediaFunction,
                              ),
                  ))
            ],
          )
        ],
      ),
    );
  }
}
