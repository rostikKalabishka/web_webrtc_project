import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:webrtc_flutter/common/utils/utils.dart';

import '../widgets/widgets.dart';

@RoutePage()
class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({super.key});

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  late TextEditingController roomNameController;
  late TextEditingController maxUserCountController;
  final _formKey = GlobalKey<FormState>();
  final utils = Utils();

  @override
  void initState() {
    maxUserCountController = TextEditingController(text: '2');
    roomNameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    maxUserCountController.dispose();
    roomNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width * 0.82;
    final TextEditingController menuController = TextEditingController();
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            title: Text('Create Room'),
          ),
          SliverToBoxAdapter(
            child: CreateRoomWidget(
              roomNameController: roomNameController,
              maxUserCountController: maxUserCountController,
              formKey: _formKey,
              utils: utils,
              onTap: () {},
              width: width,
              menuController: menuController,
              menuItems: menuItems,
            ),
          ),
        ],
      ),
    );
  }
}

class MenuItem {
  final int id;
  final String label;

  MenuItem(
    this.id,
    this.label,
  );
}

List<MenuItem> menuItems = [
  MenuItem(
    1,
    'Home',
  ),
  MenuItem(
    2,
    'Profile',
  ),
  MenuItem(
    3,
    'Settings',
  ),
  MenuItem(
    4,
    'Favorites',
  ),
  MenuItem(
    5,
    'Notifications',
  )
];
