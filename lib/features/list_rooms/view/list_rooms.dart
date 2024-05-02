import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
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
                ),
              )),
          SliverList.separated(itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {},
              child: const CustomRoomWidget(),
            );
          }, separatorBuilder: (context, _) {
            return const SizedBox(
              height: 10,
            );
          })
        ],
      ),
    );
  }
}
