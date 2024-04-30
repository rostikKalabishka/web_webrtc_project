import 'package:flutter/material.dart';

import '../../../ui/widgets/widgets.dart';

class HomeScreenMobile extends StatefulWidget {
  const HomeScreenMobile({super.key});

  @override
  State<HomeScreenMobile> createState() => _HomeScreenMobileState();
}

class _HomeScreenMobileState extends State<HomeScreenMobile> {
  late TextEditingController nameController;
  late TextEditingController urlController;

  @override
  void initState() {
    nameController = TextEditingController();
    urlController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: CustomScrollView(
          slivers: [
            const SliverAppBar(
              centerTitle: true,
              title: Text('Test WebRPC'),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: CustomTextField(controller: nameController),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 40,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: CustomTextField(controller: nameController),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 40,
              ),
            ),
            SliverToBoxAdapter(
              child: CustomButton(
                color: Colors.grey,
                onTap: () {},
                child: const Text('Join'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
