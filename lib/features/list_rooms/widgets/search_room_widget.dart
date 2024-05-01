import 'package:flutter/material.dart';

class SearchRoomWidget extends StatelessWidget {
  const SearchRoomWidget({
    super.key,
    required this.searchController,
  });
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: theme.hintColor.withOpacity(0.1)),
      margin: const EdgeInsets.symmetric(horizontal: 12).copyWith(bottom: 8),
      padding: const EdgeInsets.all(8),
      width: double.infinity,
      child: TextFormField(
        controller: searchController,
        decoration: InputDecoration(
            hintText: 'Search Room',
            hintStyle: TextStyle(
                fontSize: 16,
                color: theme.hintColor.withOpacity(0.4),
                fontWeight: FontWeight.w500),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            border: const OutlineInputBorder(borderSide: BorderSide.none),
            enabledBorder:
                const OutlineInputBorder(borderSide: BorderSide.none)),
      ),
    );
  }
}
