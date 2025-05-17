import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vgv/dependency_injection.dart';
import 'package:vgv/features/counter/cubit/counter_cubit.dart';
import 'package:vgv/l10n/l10n.dart';
import 'package:vgv/navigation/app_router.dart';
import 'package:vgv/shared/language/cubit/language_cubit.dart';
import 'package:vgv/shared/theme/cubit/theme_cubit.dart';
import 'package:vgv/shared/theme/themes/dark_theme.dart';
import 'package:vgv/shared/theme/themes/light_theme.dart';

/// Main application widget that configures the app-wide settings
class App extends StatelessWidget {
  /// Creates a new App instance
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<CounterCubit>(),
        ),
        BlocProvider(
          create: (context) => ThemeCubit(),
        ),
        BlocProvider(
          create: (context) => LanguageCubit(),
        ),
        // Add additional BlocProviders here
      ],
      child: Builder(
        builder: (context) {
          return MaterialApp.router(
            title: 'VGV App',
            theme: getLightTheme(),
            darkTheme: getDarkTheme(),
            themeMode: context.watch<ThemeCubit>().state,
            locale: context.watch<LanguageCubit>().state,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: appRouter,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
