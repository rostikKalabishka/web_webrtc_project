import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:webrtc_flutter/domain/repositories/room_repository/models/languages_model.dart';

import 'package:webrtc_flutter/domain/repositories/room_repository/room_repository.dart';

part 'room_event.dart';
part 'room_state.dart';

class RoomBloc extends Bloc<RoomEvent, RoomState> {
  final RoomRepository _roomRepository;
  RoomBloc({required RoomRepository roomRepository})
      : _roomRepository = roomRepository,
        super(RoomInitial()) {
    on<RoomEvent>((event, emit) async {
      if (event is GetLanguagesList) {
        await _getLanguages(event, emit);
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
}
