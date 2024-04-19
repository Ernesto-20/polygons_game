import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class FigureInfo extends Equatable{

  FigureInfo({required this.id, required this.rowIndex, required this.columnIndex, required this.steps, required this.lvl, this.levelUp= false});

  int id;
  int rowIndex;
  int columnIndex;
  int steps;
  int lvl;

  bool levelUp;
  
  @override
  List<Object?> get props => [id, rowIndex, columnIndex, steps, levelUp];

}