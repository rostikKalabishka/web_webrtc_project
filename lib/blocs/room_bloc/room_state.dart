part of 'room_bloc.dart';

sealed class RoomState extends Equatable {
  const RoomState();

  @override
  List<Object> get props => [];
}

final class RoomInitial extends RoomState {}

final class RoomListLoaded extends RoomState {}

final class RoomListLoading extends RoomState {}

final class RoomListFailure extends RoomState {}
