import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:webrtc_flutter/domain/repositories/room_repository/models/languages_model.dart';
import 'package:webrtc_flutter/domain/repositories/room_repository/models/room_model.dart';

import 'package:webrtc_flutter/domain/repositories/room_repository/room_repository.dart';

part 'room_event.dart';
part 'room_state.dart';

class RoomBloc extends Bloc<RoomEvent, RoomState> {
  final RoomRepository _roomRepository;
  Timer? searchDebounce;
  RoomBloc({required RoomRepository roomRepository})
      : _roomRepository = roomRepository,
        super(RoomInitial()) {
    on<RoomEvent>((event, emit) async {
      if (event is GetLanguagesList) {
        await _getLanguages(event, emit);
      } else if (event is CreateRoomEvent) {
        await _createRoom(event, emit);
      }
    });
  }

  Future<void> _getLanguages(GetLanguagesList event, emit) async {
    emit(RoomLanguagesLoading());
    try {
      final List<LanguagesModel> languagesList =
          await _roomRepository.getAllLanguage();

      emit(RoomLanguagesListLoaded(languagesList: languagesList));
    } catch (e) {
      log(e.toString());
      emit(RoomLanguagesListFailure(error: e));
    }
  }

  Future<void> _createRoom(CreateRoomEvent event, emit) async {
    try {
      await _roomRepository.createRoom(event.createRoomModel);
    } catch (e) {
      emit(RoomListFailure(error: e));
    }
  }
}
