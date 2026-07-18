import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config/app_config.dart';
import 'config/design_system.dart';
import 'views/health/health_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'views/user/login_view.dart';
import 'views/user/register_view.dart';
import 'views/user/splash_view.dart';
import 'views/user/user_profile.dart';

final appNavigatorKey = GlobalKey<NavigatorState>();

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
    AppConfig.onUnauthorized = _redirectToLogin;
    _checkLoginStatus();
  }

  @override
  void dispose() {
    AppConfig.onUnauthorized = null;
    super.dispose();
  }

  Future<void> _redirectToLogin() async {
    final navigator = appNavigatorKey.currentState;
    if (navigator != null) {
      navigator.pushNamedAndRemoveUntil('/login', (route) => false);
    }
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('user_token');
    String? user = prefs.getString('user');

    var route = '/splash';

    if (token != null && token.isNotEmpty && user != null && user.isNotEmpty) {
      try {
        await AppConfig.getUser();
        route = '/home';
      } catch (_) {
        await AppConfig.cleanStorage();
      }
    }

    if (!mounted) return;
    setState(() => _initialRoute = route);
  }

  @override
  Widget build(BuildContext context) {
    if (_initialRoute == null) {
      return const ColoredBox(
        color: Colors.white,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return MaterialApp(
      navigatorKey: appNavigatorKey,
      title: 'Fitness',
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
        '/home': (context) => const HealthView(),
        '/profile': (context) => UserProfileView(id: AppConfig.user!.id,),
      },
    );
  }
}
