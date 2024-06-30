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

final class RoomLanguagesListLoaded extends RoomState {
  final List<LanguagesModel> languagesList;

  const RoomLanguagesListLoaded({required this.languagesList});

  @override
  List<Object> get props => super.props..add(languagesList);
}

final class RoomLanguagesLoading extends RoomState {}

final class RoomLanguagesListFailure extends RoomState {
  final Object error;

  const RoomLanguagesListFailure({required this.error});

  @override
  List<Object> get props => super.props..add(error);
}
