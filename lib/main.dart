import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/Model/provider_model.dart';
import 'package:task_manager/screens/accountInfo_screen.dart';
import 'package:task_manager/screens/home_screen.dart';
import 'package:task_manager/screens/settings_screen.dart';
import 'package:task_manager/screens/signIn_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:task_manager/screens/signUp_screen.dart';
import 'firebase_options.dart';

void main() async {
  ////
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  ///
  ///
  
  runApp(
    ChangeNotifierProvider(create: (context) => ProviderModel(),
    child: const MainApp()
    ),
    
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Defi Flutter',
      //home: SignInScreen(),
      initialRoute: '/signIn_screen',
      routes:{
        '/signIn_screen': (context) => const SignInScreen(),
        '/home_screen': (context) => const HomeScreen(),
        '/signUp_screen': (context) => const SignUpScreen(),
        '/settings_screen': (context) => const SettingsScreen(),
        '/accountInfo_screen' :(context) => const AccountInfoScreen()
      },
      
    );
  }
}
