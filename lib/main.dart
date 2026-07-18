import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'providers/role_provider.dart';
import 'providers/auth_provider.dart';
import 'screens/root_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => RoleProvider()),
      ],
      child: const JobListingApp(),
    ),
  );
}

class JobListingApp extends StatelessWidget {
  const JobListingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jobly',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const RootScreen(),
    );
  }
}
