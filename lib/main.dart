import 'package:flutter/material.dart';
import 'package:project_citra/src/app.dart';
import 'package:project_citra/src/services/services.dart';
import 'package:pusher_beams/pusher_beams.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences _prefs = await SharedPreferences.getInstance();
  int? userId = PrefsHelper(sharedPreferences: _prefs).initUserId();
  if (userId != null) {
    await PusherBeams.instance.start(beamId);
    await PusherBeams.instance.addDeviceInterest("user.$userId");
  }

  runApp(const App());
}
