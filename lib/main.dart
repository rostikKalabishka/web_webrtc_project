import 'package:flutter/material.dart';
import 'package:webrtc_flutter/features/home/view/home_screen_mobile.dart';
import 'package:webrtc_flutter/ui/theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: theme,
      home: const HomeScreenMobile(),
    );
  }
}
