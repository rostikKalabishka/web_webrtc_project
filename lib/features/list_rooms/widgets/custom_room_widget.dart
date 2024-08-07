import 'package:flutter/material.dart';

import 'package:webrtc_flutter/common/utils/utils.dart';
import 'package:webrtc_flutter/domain/repositories/room_repository/models/room_model.dart';

class CustomRoomWidget extends StatelessWidget {
  const CustomRoomWidget({
    super.key,
    required this.room,
  });

  final RoomModel room;

  @override
  Widget build(BuildContext context) {
    final Utils utils = Utils();
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
                    // room.roomLanguage.name,
                    'biba',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    '${room.roomUsersList.length}/${room.maxUserInRoom}',
                    style: theme.textTheme.titleMedium,
                  ),
                ]),
                Text(room.roomName,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyLarge),
                Text(utils.calculateTimeAgo(room.createTimeRoom))
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
