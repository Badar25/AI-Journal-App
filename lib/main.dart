import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '/di.dart';
import 'features/auth/presentation/views/login_view.dart';
import 'features/home_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  /// lock orientation
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await initDependency();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadApp.custom(appBuilder: (ctx, theme) {
      return GetMaterialApp(
        title: 'AI Journal',
        theme: theme,
        home: FirebaseAuth.instance.currentUser == null ? LoginView() : HomeScreen(),
      );
    });
  }
}
