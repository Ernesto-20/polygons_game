part of 'game_pane_bloc.dart';

enum GamePaneStatus { initial, saved, muteSound, muteMusic }

class GamePaneState extends Equatable {
  const GamePaneState._(
      {required this.status,
      required this.record,
      required this.score,
      required this.enableSound,
      required this.enableMusic,
      this.users
      });

  const GamePaneState.intial()
      : this._(
            status: GamePaneStatus.initial,
            record: 0,
            score: 0,
            enableSound: true,
            enableMusic: true);

  final GamePaneStatus status;
  final double record;
  final double score;
  final List<({String name, double record})>? users;
  final bool enableSound;
  final bool enableMusic;

  GamePaneState copyWidth({
    final GamePaneStatus? status,
    final double? record,
    final double? score,
    final bool? enableSound,
    final bool? enableMusic,
  }) {
    return GamePaneState._(
      status: status ?? this.status,
      record: record ?? this.record,
      score: score ?? this.score,
      enableSound: enableSound ?? this.enableSound,
      enableMusic: enableMusic ?? this.enableMusic,
    );
  }

  @override
  List<Object> get props => [status, record, score, enableSound, enableMusic];
}
