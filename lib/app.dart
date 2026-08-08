import 'package:flutter/material.dart';

import 'core/router/app_router.dart';

class VisionCompanionApp extends StatelessWidget {
  const VisionCompanionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Vision Companion',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
    );
  }
}