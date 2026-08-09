import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/router/app_router.dart';
import 'features/settings/cubit/locale_cubit.dart';
import 'features/settings/cubit/locale_state.dart';
import 'features/settings/repository/locale_repository.dart';
import 'l10n/app_localizations.dart';

class VisionCompanionApp extends StatelessWidget {
  const VisionCompanionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LocaleCubit(
        LocaleRepository(),
      )..loadSavedLocale(),
      child: BlocBuilder<LocaleCubit, LocaleState>(
        builder: (context, state) {
          final locale = state is LocaleLoaded
              ? state.locale
              : const Locale('en');

          return MaterialApp.router(
            title: 'Vision Companion',
            debugShowCheckedModeBanner: false,
            routerConfig: appRouter,

            locale: locale,

            localizationsDelegates:
                AppLocalizations.localizationsDelegates,

            supportedLocales:
                AppLocalizations.supportedLocales,
          );
        },
      ),
    );
  }
}