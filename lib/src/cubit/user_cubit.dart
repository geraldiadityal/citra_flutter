import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:project_citra/src/cubit/page_cubit.dart';
import 'package:project_citra/src/models/models.dart';
import 'package:project_citra/src/services/services.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  Future<void> signIn(String email, String password) async {
    ApiReturnValue<User> result = await UserServices.signIn(email, password);
    if (result.value != null) {
      emit(UserLoaded(result.value!));
    } else {
      emit(UserLoadingFailed(result.message));
    }
  }

  Future<void> registerUser(User user, String password,
      {File? pictureFile}) async {
    ApiReturnValue<User> result = await UserServices.signUp(
      user,
      password,
      pictureFile: (pictureFile != null) ? pictureFile : null,
    );

    if (result.value != null) {
      emit(UserLoaded(result.value!));
    } else {
      emit(UserLoadingFailed(result.message));
    }
  }

  Future<String> updateUser({
    File? pictureFile,
    required String name,
    required String companyName,
    required String phoneNumber,
  }) async {
    ApiReturnValue<User> result = await UserServices.updateProfile(
      name: name,
      companyName: companyName,
      phoneNumber: phoneNumber,
      pictureFile: (pictureFile != null) ? pictureFile : null,
    );

    if (result.value != null) {
      emit(UserLoaded(result.value!));
      return "Update profile berhasil";
    } else {
      return result.message;
    }
  }

  Future<void> signOut(String token) async {
    ApiReturnValue<bool> result = await UserServices.logoutUser(token);
    if (result.value != null) {
      emit(UserInitial());
    } else {
      emit(UserLoadingFailed(result.message));
    }
  }

  Future<void> loginWithPrefs(String token) async {
    ApiReturnValue<User> result = await UserServices.getUser(token);
    if (result.value != null) {
      emit(UserLoaded(result.value!));
    } else {
      emit(UserLoadingFailed(result.message));
    }
  }
}
