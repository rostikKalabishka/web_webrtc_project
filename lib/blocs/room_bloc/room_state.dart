part of 'room_bloc.dart';

sealed class RoomState extends Equatable {
  const RoomState();

  @override
  List<Object> get props => [];
}

final class RoomInitial extends RoomState {}

final class RoomFailure extends RoomState {
  final Object error;

  const RoomFailure({required this.error});

  @override
  List<Object> get props => super.props..add(error);
}

final class OpenCameraInProcess extends RoomState {}

final class OpenCameraSuccess extends RoomState {}

final class OpenInMicrophoneProcess extends RoomState {}

final class OpenMicrophoneSuccess extends RoomState {}

final class SwitchCameraInProcess extends RoomState {}

final class SwitchCameraSuccess extends RoomState {}

final class RoomLoaded extends RoomState {}

final class RoomLoading extends RoomState {}
