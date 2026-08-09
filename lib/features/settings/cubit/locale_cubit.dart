import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repository/locale_repository.dart';
import 'locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  final LocaleRepository _repository;

  LocaleCubit(this._repository) : super(const LocaleLoading());

  Future<void> loadSavedLocale() async {
    try {
      final languageCode = await _repository.getSavedLocale();

      final locale = languageCode == 'hi'
          ? const Locale('hi')
          : const Locale('en');

      emit(LocaleLoaded(locale));
    } catch (e) {
      emit(LocaleError(e.toString()));
    }
  }

  Future<void> changeLocale(Locale locale) async {
    try {
      await _repository.saveLocale(locale.languageCode);
      emit(LocaleLoaded(locale));
    } catch (e) {
      emit(LocaleError(e.toString()));
    }
  }
}