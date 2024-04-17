import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class FigureInfo extends Equatable{

  FigureInfo({required this.id, required this.dx, required this.dy, required this.steps, required this.lvl, required this.color, this.levelUp= false});

  int id;
  double dx;
  double dy;
  int steps;
  int lvl;

  Color color;
  bool levelUp;
  
  @override
  // TODO: implement props
  List<Object?> get props => [id, dx, dy, steps, color, levelUp];

}