import 'package:flutter/material.dart';
import 'package:webrtc_flutter/router/router.dart';

import 'package:webrtc_flutter/ui/theme/theme.dart';

import 'features/settings/view/settings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _appRouter = AppRouter();
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: darkTheme,
        routerConfig: _appRouter.config());
  }
}
