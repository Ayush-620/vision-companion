import 'package:flutter/material.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

class VisionCompanionApp extends StatelessWidget {
  const VisionCompanionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Vision Companion',
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
    );
  }
}