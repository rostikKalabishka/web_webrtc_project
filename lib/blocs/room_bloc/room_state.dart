part of 'room_bloc.dart';

sealed class RoomState extends Equatable {
  const RoomState();

  @override
  List<Object> get props => [];
}

final class RoomInitial extends RoomState {}

final class CreateRoom extends RoomState {}

final class CreateRoomFailure extends RoomState {
  final Object error;

  const CreateRoomFailure({required this.error});

  @override
  List<Object> get props => super.props..add(error);
}

final class RoomListLoaded extends RoomState {
  final List<RoomModel> roomsList;

  const RoomListLoaded({required this.roomsList});

  @override
  List<Object> get props => super.props..add(roomsList);
}

final class RoomListLoading extends RoomState {}

final class RoomListFailure extends RoomState {
  final Object error;

  const RoomListFailure({required this.error});

  @override
  List<Object> get props => super.props..add(error);
}

final class RoomLanguagesListLoaded extends RoomState {
  final List<LanguagesModel> languagesList;

  const RoomLanguagesListLoaded({required this.languagesList});

  @override
  List<Object> get props => super.props..add(languagesList);
}

final class RoomLanguagesLoading extends RoomState {}

class SearchRoomsList extends RoomState {
  final List<RoomModel> searchRoomsList;

  const SearchRoomsList({required this.searchRoomsList});

  @override
  List<Object> get props => super.props..add(searchRoomsList);
}

final class RoomLanguagesListFailure extends RoomState {
  final Object error;

  const RoomLanguagesListFailure({required this.error});

  @override
  List<Object> get props => super.props..add(error);
}
