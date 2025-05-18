import 'package:get_it/get_it.dart';
import 'package:vgv/features/home/presentation/cubit/counter_cubit.dart';

/// Global service locator instance
final getIt = GetIt.instance;

/// Shorthand for the GetIt instance
final sl = getIt;

/// Configure dependency injection
Future<void> configureDependencies() async {
  // // Register app config
  // getIt.registerSingleton<AppConfig>(config);

  // // Register services
  // getIt.registerLazySingleton<HttpService>(
  //   () => HttpService(config: getIt<AppConfig>()),
  // );

  // // Register repositories
  // getIt.registerLazySingleton<UserRepository>(
  //   () => UserRepository(httpService: getIt<HttpService>()),
  // );

  // Register blocs/cubits
  getIt.registerFactory<CounterCubit>(
    () => CounterCubit(),
  );
}
