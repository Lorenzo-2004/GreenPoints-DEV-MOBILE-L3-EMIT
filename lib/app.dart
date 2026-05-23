import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'data/repositories/auth_repository.dart';
import 'presentation/blocs/auth/auth_cubit.dart';
import 'presentation/blocs/user/user_cubit.dart';
import 'presentation/providers/theme_provider.dart';
import 'presentation/providers/locale_provider.dart';

class GreenPointsApp extends StatelessWidget {
  const GreenPointsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AuthCubit(AuthRepository())),
          BlocProvider(create: (context) => UserCubit()),
        ],
        child: MaterialApp.router(
          title: 'GreenPoints',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          routerConfig: appRouter,
        ),
      ),
    );
  }
}