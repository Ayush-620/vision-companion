import 'package:flutter/material.dart';

sealed class LocaleState {
  const LocaleState();
}

class LocaleLoading extends LocaleState {
  const LocaleLoading();
}

class LocaleLoaded extends LocaleState {
  final Locale locale;

  const LocaleLoaded(this.locale);
}

class LocaleError extends LocaleState {
  final String message;

  const LocaleError(this.message);
}