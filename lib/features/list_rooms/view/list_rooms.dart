import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:webrtc_flutter/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:webrtc_flutter/blocs/room_list_bloc/room_list_bloc.dart';

import 'package:webrtc_flutter/domain/repositories/room_repository/models/room_model.dart';
import 'package:webrtc_flutter/router/router.dart';

import '../widgets/widgets.dart';

@RoutePage()
class ListRoomsScreen extends StatefulWidget {
  const ListRoomsScreen({super.key});

  @override
  State<ListRoomsScreen> createState() => _ListRoomsScreenState();
}

class _ListRoomsScreenState extends State<ListRoomsScreen> {
  late TextEditingController searchController;
  RTCVideoRenderer remoteRenderer = RTCVideoRenderer();
  @override
  void initState() {
    searchController = TextEditingController();
    super.initState();
    context.read<RoomListBloc>().add(RoomListLoadEvent());
  }

  @override
  Widget build(BuildContext context) {
    late RoomModel currentRoom;
    return BlocConsumer<RoomListBloc, RoomListState>(
      builder: (BuildContext context, state) {
        if (state is RoomListLoaded) {
          final List<RoomModel> roomsList = state.roomsList;
          return Scaffold(
            body: RefreshIndicator.adaptive(
              onRefresh: () async {
                context.read<RoomListBloc>().add(RoomListLoadEvent());
              },
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                      actions: [
                        IconButton(
                            onPressed: () {
                              _navigateTo(CreateRoomRoute(
                                  remoteRenderer: remoteRenderer));
                            },
                            icon: const Icon(Icons.add))
                      ],
                      title: const Text('List Rooms'),
                      pinned: true,
                      snap: true,
                      floating: true,
                      surfaceTintColor: Colors.transparent,
                      elevation: 0,
                      bottom: PreferredSize(
                        preferredSize: const Size.fromHeight(80),
                        child: SearchRoomWidget(
                          searchController: searchController,
                          onChanged: (String text) {
                            searchRooms(text, context);
                          },
                        ),
                      )),
                  SliverList.separated(
                      itemCount: roomsList.length,
                      itemBuilder: (context, index) {
                        currentRoom = roomsList[index];
                        return GestureDetector(
                          onTap: () {
                            _joinRoom(context, currentRoom);
                          },
                          child: CustomRoomWidget(
                            room: roomsList[index],
                          ),
                        );
                      },
                      separatorBuilder: (context, _) {
                        return const SizedBox(
                          height: 10,
                        );
                      })
                ],
              ),
            ),
          );
        } else if (state is RoomListFailure) {
          return Center(
            child: Text(state.error.toString()),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
      },
      listener: (BuildContext context, RoomListState state) {
        if (state is JoinRoomInSuccess) {
          _navigateTo(RoomRoute(
              roomModel: currentRoom, remoteRenderer: remoteRenderer));
        }
      },
    );
  }

  void _joinRoom(BuildContext context, RoomModel currentRoom) {
    final calleeUser = context.read<AuthenticationBloc>().state.user;
    if (calleeUser != null) {
      context.read<RoomListBloc>().add(JoinRoomEvent(
          remoteVideo: remoteRenderer,
          roomModel: currentRoom,
          calleeUser: calleeUser));
    }
  }

  void searchRooms(String text, BuildContext context) {
    if (text.isNotEmpty) {
      context.read<RoomListBloc>().add(SearchRooms(roomName: text));
    } else if (text.isEmpty) {
      context.read<RoomListBloc>().add(RoomListLoadEvent());
    }
  }

  void _navigateTo(PageRouteInfo<dynamic> route) {
    AutoRouter.of(context).push(route);
  }
}
