import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vgv/features/counter/counter.dart';
import 'package:vgv/l10n/l10n.dart';
import 'package:vgv/shared/language/cubit/language_cubit.dart';
import 'package:vgv/shared/theme/cubit/theme_cubit.dart';

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CounterCubit(),
      child: const CounterView(),
    );
  }
}

class CounterView extends StatelessWidget {
  const CounterView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.counterAppBarTitle),
        leading: // Language selector
            DropdownButton<Locale>(
          value: context.watch<LanguageCubit>().state,
          underline: const SizedBox(),
          icon: const SizedBox(),
          padding: EdgeInsets.zero,
          items: const [
            DropdownMenuItem(
              value: Locale('en'),
              child: Text('🇺🇸', style: TextStyle(fontSize: 28)),
            ),
            DropdownMenuItem(
              value: Locale('es'),
              child: Text('🇪🇸', style: TextStyle(fontSize: 28)),
            ),
            DropdownMenuItem(
              value: Locale('pt'),
              child: Text('🇧🇷', style: TextStyle(fontSize: 28)),
            ),
            DropdownMenuItem(
              value: Locale('ja'),
              child: Text('🇯🇵', style: TextStyle(fontSize: 28)),
            ),
          ],
          onChanged: (Locale? locale) {
            if (locale != null) {
              context.read<LanguageCubit>().changeLanguage(locale);
            }
          },
        ),
        actions: [
          // Theme toggle
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.light
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            onPressed: () => context.read<ThemeCubit>().toggleTheme(),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.welcomeMessage,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            const CounterText(),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => context.read<CounterCubit>().increment(),
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            onPressed: () => context.read<CounterCubit>().decrement(),
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}

class CounterText extends StatelessWidget {
  const CounterText({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final count = context.select((CounterCubit cubit) => cubit.state);
    return Text('$count', style: theme.textTheme.displayLarge);
  }
}
