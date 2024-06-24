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
            ),
          ),
        ],
      ),
    );
  }
}
