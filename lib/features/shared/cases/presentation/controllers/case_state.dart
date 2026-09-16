part of 'case_cubit.dart';

abstract class CasesState {}

class Initial extends CasesState {}

class Loading extends CasesState {}

class Error extends CasesState {}

class Sending extends CasesState {}

class Success extends CasesState {}
