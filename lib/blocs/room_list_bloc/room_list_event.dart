part of 'room_list_bloc.dart';

sealed class RoomListEvent extends Equatable {
  const RoomListEvent();

  @override
  List<Object> get props => [];
}

class RoomListLoadEvent extends RoomListEvent {}

class SearchRooms extends RoomListEvent {
  final String roomName;

  const SearchRooms({required this.roomName});

  @override
  List<Object> get props => super.props..add(roomName);
}
