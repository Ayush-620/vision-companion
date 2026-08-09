import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/locale_cubit.dart';
import '../cubit/locale_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: BlocBuilder<LocaleCubit, LocaleState>(
        builder: (context, state) {
          final selectedLocale =
              state is LocaleLoaded ? state.locale : const Locale('en');

          return ListView(
            children: [
              const ListTile(
                leading: Icon(Icons.language),
                title: Text('Language'),
              ),
              RadioListTile<Locale>(
                value: const Locale('en'),
                groupValue: selectedLocale,
                title: const Text('English'),
                onChanged: (locale) {
                  if (locale != null) {
                    context.read<LocaleCubit>().changeLocale(locale);
                  }
                },
              ),
              RadioListTile<Locale>(
                value: const Locale('hi'),
                groupValue: selectedLocale,
                title: const Text('हिंदी'),
                onChanged: (locale) {
                  if (locale != null) {
                    context.read<LocaleCubit>().changeLocale(locale);
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}