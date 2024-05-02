import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:webrtc_flutter/router/router.dart';

@RoutePage()
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
    final theme = Theme.of(context);
    return AutoTabsRouter(
      routes: [ListRoomsRoute(), SettingsRoute()],
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);
        return Scaffold(
          body: child,
          bottomNavigationBar: BottomNavigationBar(
            onTap: (index) => _openPage(index, tabsRouter),
            currentIndex: tabsRouter.activeIndex,
            selectedItemColor: theme.primaryColor,
            unselectedItemColor: theme.hintColor,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings), label: 'Settings'),
            ],
          ),
        );
      },
    );
  }

  void _openPage(int index, TabsRouter tabsRouter) {
    tabsRouter.setActiveIndex(index);
  }
}
