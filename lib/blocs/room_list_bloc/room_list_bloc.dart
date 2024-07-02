import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:webrtc_flutter/domain/repositories/room_repository/models/room_model.dart';
import 'package:webrtc_flutter/domain/repositories/room_repository/room_repository.dart';

part 'room_list_event.dart';
part 'room_list_state.dart';

class RoomListBloc extends Bloc<RoomListEvent, RoomListState> {
  final RoomRepository _roomRepository;
  Timer? searchDebounce;
  RoomListBloc({required RoomRepository roomRepository})
      : _roomRepository = roomRepository,
        super(RoomListInitial()) {
    on<RoomListEvent>((event, emit) async {
      if (event is RoomListLoadEvent) {
        await _loadRoomList(event, emit);
      } else if (event is SearchRooms) {
        await _searchRoomQuery(event, emit);
      }
    }, transformer: (events, mapper) => events.asyncExpand(mapper));
  }

  Future<void> _loadRoomList(RoomListLoadEvent event, emit) async {
    if (state is! RoomListLoaded) {
      emit(RoomListLoading());
    }
    try {
      final List<RoomModel> roomsList = await _roomRepository.getAllRooms();
      emit(RoomListLoaded(roomsList: roomsList));
    } catch (e) {
      emit(RoomListFailure(error: e));
    }
  }

  Future<void> _searchRoomQuery(SearchRooms event, emit) async {
    try {
      searchDebounce?.cancel();

      final completer = Completer<void>();
      searchDebounce = Timer(const Duration(milliseconds: 200), () async {
        final roomsList = await _roomRepository.searchRooms(event.roomName);

        emit(RoomListLoaded(roomsList: roomsList));

        completer.complete();
      });

      await completer.future;
    } catch (e) {
      emit(RoomListFailure(error: e));
    }
  }
}
