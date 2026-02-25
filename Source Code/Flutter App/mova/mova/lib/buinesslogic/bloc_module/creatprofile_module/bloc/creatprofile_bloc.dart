import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webtime_movie_ocean/buinesslogic/bloc_module/creatprofile_module/creatprofile_resources/creatprofile_repository.dart';

part 'creatprofile_event.dart';
part 'creatprofile_state.dart';

class CreateProfileBloc extends Bloc<CreatprofileEvent, CreatprofileState> {
  final CreatprofileRepository createProfileRepository;
  CreateProfileBloc(this.createProfileRepository) : super(CreatprofileInitial()) {
    on<CreatprofileEvent>(
      (event, emit) async {
        emit(CreatprofileLoading());
        final result = await createProfileRepository.creatprofile(
            event.email, event.password, event.loginType, event.fcmToken, event.identity, event.name, event.image);
        log("Result create profile :: $result");
        emit(CreatprofileSuccessful());
      },
    );
  }
}
