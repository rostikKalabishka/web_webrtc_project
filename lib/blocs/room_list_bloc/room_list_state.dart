part of 'room_list_bloc.dart';

sealed class RoomListState extends Equatable {
  const RoomListState();

  @override
  List<Object> get props => [];
}

final class RoomListInitial extends RoomListState {}

final class RoomListLoaded extends RoomListState {
  final List<RoomModel> roomsList;

  const RoomListLoaded({required this.roomsList});

  @override
  List<Object> get props => super.props..add(roomsList);
}

final class RoomListLoading extends RoomListState {}

final class RoomListFailure extends RoomListState {
  final Object error;

  const RoomListFailure({required this.error});

  @override
  List<Object> get props => super.props..add(error);
}

final class JoinRoomInProcess extends RoomListState {}

final class JoinRoomInSuccess extends RoomListState {}

final class SearchRoomList extends RoomListState {
  final List<RoomModel> roomsList;

  const SearchRoomList({required this.roomsList});

  @override
  List<Object> get props => super.props..add(roomsList);
}
