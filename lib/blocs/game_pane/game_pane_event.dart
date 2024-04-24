part of 'game_pane_bloc.dart';

abstract class GamePaneEvent{
}

class GamePaneLoaded extends GamePaneEvent{
  
}

class GamePaneScoreIncreased extends GamePaneEvent{
  GamePaneScoreIncreased({required this.increase});

  final double increase;
}


class GamePaneEnabledSound extends GamePaneEvent{
  GamePaneEnabledSound({required this.enable});

  final bool enable;
}

class GamePaneEnabledMusic extends GamePaneEvent{
  GamePaneEnabledMusic({required this.enable});

  final bool enable;
}
