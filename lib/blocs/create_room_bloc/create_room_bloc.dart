import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webrtc_flutter/domain/repositories/room_repository/models/languages_model.dart';
import 'package:webrtc_flutter/domain/repositories/room_repository/models/room_model.dart';
import 'package:webrtc_flutter/domain/repositories/room_repository/room_repository.dart';

part 'create_room_event.dart';
part 'create_room_state.dart';

class CreateRoomBloc extends Bloc<CreateRoomEvent, CreateRoomState> {
  final RoomRepository _roomRepository;
  CreateRoomBloc({required RoomRepository roomRepository})
      : _roomRepository = roomRepository,
        super(CreateRoomInitial()) {
    on<CreateRoomEvent>((event, emit) async {
      if (event is GetLanguagesList) {
        await _getLanguages(event, emit);
      } else if (event is CreateRoom) {
        await _createRoom(event, emit);
      }
    });
  }

  Future<void> _getLanguages(GetLanguagesList event, emit) async {
    if (state is! RoomLanguagesListLoaded) {
      emit(RoomLanguagesLoading());
    }

    try {
      final List<LanguagesModel> languagesList =
          await _roomRepository.getAllLanguage();

      emit(RoomLanguagesListLoaded(languagesList: languagesList));
    } catch (e) {
      log(e.toString());
      emit(CreateRoomFailure(error: e));
    }
  }

  Future<void> _createRoom(CreateRoom event, emit) async {
    emit(CreateRoomInProcess());
    try {
      await _roomRepository.createRoom(event.createRoomModel);
      emit(CreateRoomInSuccess());
    } catch (e) {
      emit(CreateRoomFailure(error: e));
    }
  }
}
