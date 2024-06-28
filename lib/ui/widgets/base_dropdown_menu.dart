import 'package:flutter/material.dart';
import 'package:webrtc_flutter/features/create_room/view/create_room.dart';

class BaseDropdownMenu extends StatelessWidget {
  const BaseDropdownMenu({
    super.key,
    //required this.selectedMenu,
    required this.width,
    required this.menuController,
    required this.menuItems,
  });

  final double width;
  final TextEditingController menuController;
  final List<MenuItem> menuItems;

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width * 0.82;
    // final TextEditingController menuController = TextEditingController();
    MenuItem? selectedMenu;
    final theme = Theme.of(context);
    return DropdownMenu<MenuItem>(
      // initialSelection: menuItems.first,
      controller: menuController,
      width: width,
      hintText: "Select Language",
      requestFocusOnTap: true,
      enableFilter: true,
      label: const Text('Select Language'),
      onSelected: (MenuItem? menu) {
        selectedMenu = menu;
      },
      dropdownMenuEntries:
          menuItems.map<DropdownMenuEntry<MenuItem>>((MenuItem menu) {
        return DropdownMenuEntry<MenuItem>(
          value: menu,
          label: menu.label,
        );
      }).toList(),
    );
  }
}
