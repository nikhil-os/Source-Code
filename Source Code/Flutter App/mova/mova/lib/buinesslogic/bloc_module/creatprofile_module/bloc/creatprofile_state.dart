// ignore_for_file: must_be_immutable

part of 'creatprofile_bloc.dart';

@immutable
abstract class CreatprofileState extends Equatable {}

class CreatprofileInitial extends CreatprofileState {

  @override
  List<Object?> get props => [];
}
class CreatprofileSuccessful extends CreatprofileState {

  @override
  List<Object?> get props => [];
}
class CreatprofileLoading extends CreatprofileState {

  @override
  List<Object?> get props => [];
}
class CreatprofileError extends CreatprofileState {
  String? msgError;
  CreatprofileError(this.msgError);
  @override
  List<Object?> get props => [msgError];
}

