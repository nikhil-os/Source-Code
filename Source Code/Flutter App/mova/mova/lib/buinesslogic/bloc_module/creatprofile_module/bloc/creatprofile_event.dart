// ignore_for_file: must_be_immutable, override_on_non_overriding_member

part of 'creatprofile_bloc.dart';

@immutable
abstract class CreatprofileEvent {
  String? email;
  String? password;
  int loginType;
  String? fcmToken;
  String? identity;
  String? name;
  String? image;

   CreatprofileEvent({this.image,this.name,this.email,this.identity,this.fcmToken,required this.loginType,this.password});

   @override
  List<Object?> get props => [email,password,loginType,fcmToken,identity,name,image];

}


