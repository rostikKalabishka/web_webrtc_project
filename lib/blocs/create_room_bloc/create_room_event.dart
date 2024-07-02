part of 'create_room_bloc.dart';

sealed class CreateRoomEvent extends Equatable {
  const CreateRoomEvent();

  @override
  List<Object> get props => [];
}

class GetLanguagesList extends CreateRoomEvent {}

class CreateRoom extends CreateRoomEvent {
  final RoomModel createRoomModel;

  const CreateRoom({required this.createRoomModel});

  @override
  List<Object> get props => super.props..add(createRoomModel);
}
