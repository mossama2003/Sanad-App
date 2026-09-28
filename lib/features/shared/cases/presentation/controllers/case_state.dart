part of 'case_cubit.dart';

abstract class CasesState {}

class Initial extends CasesState {}

class Loading extends CasesState {}

class Error extends CasesState {}

class Sending extends CasesState {}

class CaseCreated extends CasesState {
  final int caseId;

  CaseCreated(this.caseId);

  List<Object?> get props => [caseId];
}

class Success extends CasesState {}
