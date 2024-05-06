import 'package:auto_route/auto_route.dart';
import 'package:webrtc_flutter/features/home/view/home_screen_mobile.dart';

import '../features/auth/mobile_auth/login/view/view.dart';
import '../features/auth/mobile_auth/registration/registration.dart';
import '../features/list_rooms/view/view.dart';
import '../features/loader/loader.dart';
import '../features/settings/settings.dart';

part 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: LoaderRoute.page,
          path: '/',
        ),
        AutoRoute(page: LoginRoute.page, path: '/login', children: [
          AutoRoute(
            page: RegistrationRoute.page,
            path: 'registration',
          ),
        ]),
        AutoRoute(page: HomeRouteMobile.page, path: '/home', children: [
          AutoRoute(
            page: SettingsRoute.page,
            path: 'settings',
          ),
          AutoRoute(
            page: ListRoomsRoute.page,
            path: 'list_rooms',
          )
        ])
      ];
}
