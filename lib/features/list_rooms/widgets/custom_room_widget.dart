import 'package:flutter/material.dart';

class CustomRoomWidget extends StatelessWidget {
  const CustomRoomWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
          color: theme.cardColor, borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(12),
      child: InkWell(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Text(
                    'Українська',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    '1/2',
                    style: theme.textTheme.titleMedium,
                  ),
                ]),
                Text('Room name',
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyLarge),
                const Text('21 h')
              ],
            ),
            const CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://upload.wikimedia.org/wikipedia/commons/2/23/Lil-Peep_PrettyPuke_Photoshoot.png'),
              radius: 30,
            )
          ],
        ),
      ),
    );
  }
}
