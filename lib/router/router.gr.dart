// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    CreateRoomRoute.name: (routeData) {
      final args = routeData.argsAs<CreateRoomRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: CreateRoomScreen(
          key: args.key,
          remoteRenderer: args.remoteRenderer,
        ),
      );
    },
    HomeRouteMobile.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HomeScreenMobile(),
      );
    },
    ListRoomsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ListRoomsScreen(),
      );
    },
    LoaderRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LoaderScreen(),
      );
    },
    LoginRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LoginScreen(),
      );
    },
    RegistrationRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const RegistrationScreen(),
      );
    },
    RoomRoute.name: (routeData) {
      final args = routeData.argsAs<RoomRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: RoomScreen(
          key: args.key,
          roomModel: args.roomModel,
          remoteRenderer: args.remoteRenderer,
        ),
      );
    },
    SettingsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SettingsScreen(),
      );
    },
  };
}

/// generated route for
/// [CreateRoomScreen]
class CreateRoomRoute extends PageRouteInfo<CreateRoomRouteArgs> {
  CreateRoomRoute({
    Key? key,
    required RTCVideoRenderer remoteRenderer,
    List<PageRouteInfo>? children,
  }) : super(
          CreateRoomRoute.name,
          args: CreateRoomRouteArgs(
            key: key,
            remoteRenderer: remoteRenderer,
          ),
          initialChildren: children,
        );

  static const String name = 'CreateRoomRoute';

  static const PageInfo<CreateRoomRouteArgs> page =
      PageInfo<CreateRoomRouteArgs>(name);
}

class CreateRoomRouteArgs {
  const CreateRoomRouteArgs({
    this.key,
    required this.remoteRenderer,
  });

  final Key? key;

  final RTCVideoRenderer remoteRenderer;

  @override
  String toString() {
    return 'CreateRoomRouteArgs{key: $key, remoteRenderer: $remoteRenderer}';
  }
}

/// generated route for
/// [HomeScreenMobile]
class HomeRouteMobile extends PageRouteInfo<void> {
  const HomeRouteMobile({List<PageRouteInfo>? children})
      : super(
          HomeRouteMobile.name,
          initialChildren: children,
        );

  static const String name = 'HomeRouteMobile';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ListRoomsScreen]
class ListRoomsRoute extends PageRouteInfo<void> {
  const ListRoomsRoute({List<PageRouteInfo>? children})
      : super(
          ListRoomsRoute.name,
          initialChildren: children,
        );

  static const String name = 'ListRoomsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LoaderScreen]
class LoaderRoute extends PageRouteInfo<void> {
  const LoaderRoute({List<PageRouteInfo>? children})
      : super(
          LoaderRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoaderRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LoginScreen]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [RegistrationScreen]
class RegistrationRoute extends PageRouteInfo<void> {
  const RegistrationRoute({List<PageRouteInfo>? children})
      : super(
          RegistrationRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegistrationRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [RoomScreen]
class RoomRoute extends PageRouteInfo<RoomRouteArgs> {
  RoomRoute({
    Key? key,
    required RoomModel roomModel,
    required RTCVideoRenderer remoteRenderer,
    List<PageRouteInfo>? children,
  }) : super(
          RoomRoute.name,
          args: RoomRouteArgs(
            key: key,
            roomModel: roomModel,
            remoteRenderer: remoteRenderer,
          ),
          initialChildren: children,
        );

  static const String name = 'RoomRoute';

  static const PageInfo<RoomRouteArgs> page = PageInfo<RoomRouteArgs>(name);
}

class RoomRouteArgs {
  const RoomRouteArgs({
    this.key,
    required this.roomModel,
    required this.remoteRenderer,
  });

  final Key? key;

  final RoomModel roomModel;

  final RTCVideoRenderer remoteRenderer;

  @override
  String toString() {
    return 'RoomRouteArgs{key: $key, roomModel: $roomModel, remoteRenderer: $remoteRenderer}';
  }
}

/// generated route for
/// [SettingsScreen]
class SettingsRoute extends PageRouteInfo<void> {
  const SettingsRoute({List<PageRouteInfo>? children})
      : super(
          SettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
