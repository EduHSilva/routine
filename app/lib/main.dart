import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config/app_config.dart';
import 'config/design_system.dart';
import 'views/categories/category_view.dart';
import 'views/finances/finances_view.dart';
import 'views/health/health_view.dart';
import 'views/home/home_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'views/tasks/tasks_view.dart';
import 'views/user/login_view.dart';
import 'views/user/register_view.dart';
import 'views/user/splash_view.dart';
import 'views/user/user_profile.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await dotenv.load(fileName: ".env");


  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en', ''), Locale('pt', '')],
      path: 'assets/i18n',
      fallbackLocale: const Locale('en', ''),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  String? _initialRoute;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('user_token');
    String? user = prefs.getString('user');

    if (token != null && token.isNotEmpty && user != null && user.isNotEmpty) {
      AppConfig.getUser();
      setState(() {
        _initialRoute = '/home';
      });
    } else {
      setState(() {
        _initialRoute = '/splash';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RoutineApp',
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      initialRoute: _initialRoute,
      showSemanticsDebugger: false,
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      routes: {
        '/splash': (context) => const SplashView(),
        '/login': (context) => const LoginView(),
        '/register': (context) => const RegisterView(),
        '/home': (context) => const HomeView(),
        '/tasks': (context) => const TasksView(),
        '/health': (context) => const HealthView(),
        '/categories': (context) => const CategoryView(),
        '/finances': (context) => const FinancesView(),
        '/profile': (context) => UserProfileView(id: AppConfig.user!.id,),
      },
    );
  }
}