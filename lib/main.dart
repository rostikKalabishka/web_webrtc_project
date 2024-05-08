import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webrtc_flutter/common/utils/bloc_observer.dart';
import 'package:webrtc_flutter/domain/config/firebase_options.dart';
import 'package:webrtc_flutter/webRTC_project.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final prefs = await SharedPreferences.getInstance();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  Bloc.observer = SimpleBlocObserver();

  runApp(WebRTCProject(
    preferences: prefs,
  ));
}
