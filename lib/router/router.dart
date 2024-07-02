import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:webrtc_flutter/domain/repositories/room_repository/models/room_model.dart';
import 'package:webrtc_flutter/features/auth/mobile_auth/login/view/login.dart';
import 'package:webrtc_flutter/features/auth/mobile_auth/registration/view/registration.dart';
import 'package:webrtc_flutter/features/loader/view/loader.dart';
import 'package:webrtc_flutter/features/room/view/room.dart';
import 'package:webrtc_flutter/features/settings/view/settings.dart';

import '../features/create_room/view/create_room.dart';
import '../features/home/view/home_screen_mobile.dart';
import '../features/list_rooms/view/list_rooms.dart';

part 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: LoaderRoute.page,
          path: '/',
        ),
        AutoRoute(page: LoginRoute.page, path: '/login'),
        AutoRoute(
          page: RegistrationRoute.page,
          path: '/registration',
        ),
        AutoRoute(page: HomeRouteMobile.page, path: '/home', children: [
          AutoRoute(
            page: SettingsRoute.page,
            path: 'settings',
          ),
          AutoRoute(
            page: ListRoomsRoute.page,
            path: 'list_rooms',
          )
        ]),
        AutoRoute(page: CreateRoomRoute.page, path: '/list_rooms/create_room'),
        AutoRoute(page: RoomRoute.page, path: '/list_rooms/current_room'),
      ];
}
