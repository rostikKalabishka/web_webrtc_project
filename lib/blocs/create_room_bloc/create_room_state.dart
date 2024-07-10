part of 'create_room_bloc.dart';

sealed class CreateRoomState extends Equatable {
  const CreateRoomState();

  @override
  List<Object> get props => [];
}

final class CreateRoomInitial extends CreateRoomState {}

final class RoomLanguagesListLoaded extends CreateRoomState {
  final List<LanguagesModel> languagesList;

  const RoomLanguagesListLoaded({required this.languagesList});

  @override
  List<Object> get props => super.props..add(languagesList);
}

final class RoomLanguagesLoading extends CreateRoomState {}

final class CreateRoomFailure extends CreateRoomState {
  final Object error;

  const CreateRoomFailure({required this.error});

  @override
  List<Object> get props => super.props..add(error);
}

class CreateRoomInProcess extends CreateRoomState {}

class CreateRoomInSuccess extends CreateRoomState {
  final RoomModel roomModel;

  const CreateRoomInSuccess({required this.roomModel});
  @override
  List<Object> get props => super.props..add(roomModel);
}
