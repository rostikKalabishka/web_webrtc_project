part of 'create_room_bloc.dart';

sealed class CreateRoomEvent extends Equatable {
  const CreateRoomEvent();

  @override
  List<Object> get props => [];
}

class GetLanguagesList extends CreateRoomEvent {}

class CreateRoom extends CreateRoomEvent {
  final RoomModel createRoomModel;
  final RTCVideoRenderer remoteRender;

  const CreateRoom({required this.createRoomModel, required this.remoteRender});

  @override
  List<Object> get props => super.props..add(createRoomModel);
}
