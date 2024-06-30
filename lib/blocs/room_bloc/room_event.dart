part of 'room_bloc.dart';

sealed class RoomEvent extends Equatable {
  const RoomEvent();

  @override
  List<Object> get props => [];
}

class RoomCreate extends RoomEvent {}

class RoomConnect extends RoomEvent {}

class GetLanguagesList extends RoomEvent {}
