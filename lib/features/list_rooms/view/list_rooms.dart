import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  @override
  void initState() {
    searchController = TextEditingController();
    super.initState();
    context.read<RoomListBloc>().add(RoomListLoadEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoomListBloc, RoomListState>(
      builder: (BuildContext context, state) {
        if (state is RoomListLoaded) {
          final List<RoomModel> roomsList = state.roomsList;
          return Scaffold(
            body: RefreshIndicator.adaptive(
              onRefresh: () async {},
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                      actions: [
                        IconButton(
                            onPressed: () {
                              _navigateTo(const CreateRoomRoute());
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
                        return GestureDetector(
                          onTap: () {},
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
    );
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
