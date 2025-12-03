import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'welcome_page.dart';
import 'get_started.dart';
import 'signup.dart';
import 'login.dart';



void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Enable device preview in debug mode
  runApp(
    DevicePreview(
      enabled: !kReleaseMode, // Disable in release builds automatically
      builder: (context) => const CERVApp(),
    ),
  );
}

class CERVApp extends StatelessWidget {
  const CERVApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Use DevicePreview.of(context) to get the correct locale and builder
    return MaterialApp(
      title: 'CERV',
      debugShowCheckedModeBanner: false,
      // Use DevicePreview's locale and builder
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey[50],
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomePage(),
        '/login': (context) => const LoginPage(),
        '/get_started': (context) => const GetStartedPage(),
        '/signup': (context) => const SignUpPage(),
      }
    );
  }
}
