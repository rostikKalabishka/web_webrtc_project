part of 'room_bloc.dart';

sealed class RoomEvent extends Equatable {
  const RoomEvent();

  @override
  List<Object> get props => [];
}

class RoomCreate extends RoomEvent {}

class RoomListLoadedEvent extends RoomEvent {}

class RoomConnect extends RoomEvent {}

class GetLanguagesList extends RoomEvent {}

class CreateRoomEvent extends RoomEvent {
  final RoomModel createRoomModel;

  const CreateRoomEvent({required this.createRoomModel});

  @override
  List<Object> get props => super.props..add(createRoomModel);
}
