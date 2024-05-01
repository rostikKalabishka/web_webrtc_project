import 'package:flutter/material.dart';
import 'package:webrtc_flutter/features/auth/mobile_auth/login/view/login.dart';
import 'package:webrtc_flutter/features/auth/mobile_auth/registration/view/registration.dart';

import 'package:webrtc_flutter/ui/theme/theme.dart';

import 'features/list_rooms/list_rooms.dart';

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
      theme: darkTheme,
      home: const ListRoomsScreen(),
    );
  }
}
