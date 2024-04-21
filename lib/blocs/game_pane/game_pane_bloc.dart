import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'game_pane_event.dart';
part 'game_pane_state.dart';

class GamePaneBloc extends Bloc<GamePaneEvent, GamePaneState> {
  GamePaneBloc() : super(const GamePaneState.intial()) {
    on<GamePaneScoreIncreased>((event, emit) {
      emit(state.copyWidth(score: state.score + event.increase, record: state.record < state.score + event.increase? state.score + event.increase: state.record));
    });

    on<GamePaneEnabledSound>((event, emit){
      emit(state.copyWidth(enableSound: event.enable));
    });

    on<GamePaneEnabledMusic>((event, emit){
      emit(state.copyWidth(enableMusic: event.enable));
    });
  }
}
