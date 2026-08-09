import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/cubit/auth_cubit.dart';
import '../../features/auth/repository/auth_repository.dart';
import '../../features/history/repository/history_repository.dart';
import '../../features/detector/cubit/detector_cubit.dart';
import '../../features/detector/services/detector_service.dart';
import '../../features/detector/services/speech_service.dart';


final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  getIt.registerLazySingleton<FirebaseAuth>(
    () => FirebaseAuth.instance,
  );

  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );

  getIt.registerLazySingleton<FirebaseStorage>(
    () => FirebaseStorage.instance,
  );

  getIt.registerLazySingleton<FirebaseAnalytics>(
    () => FirebaseAnalytics.instance,
  );

  getIt.registerLazySingleton<FirebaseCrashlytics>(
    () => FirebaseCrashlytics.instance,
  );

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(
      auth: getIt<FirebaseAuth>(),
    ),
  );

  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(
      getIt<AuthRepository>(),
    ),
  );

  getIt.registerLazySingleton(
   () => HistoryRepository(
     firestore: getIt(),
     auth: getIt(),
   ),
 );
     getIt.registerFactory<DetectorService>(
    () => DetectorService(),
  );

  getIt.registerFactory<SpeechService>(
    () => SpeechService(),
  );

  getIt.registerFactory<DetectorCubit>(
    () => DetectorCubit(
      detectorService: getIt<DetectorService>(),
      speechService: getIt<SpeechService>(),
      historyRepository: getIt<HistoryRepository>(),
    ),
  );
}