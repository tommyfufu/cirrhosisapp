import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:number_connection_test/games/colors_vs_words_game/colors_vs_word_game_ending_view.dart';
import 'package:number_connection_test/games/colors_vs_words_game/colors_vs_word_ready_view.dart';
import 'package:number_connection_test/constants/routes.dart';
import 'package:number_connection_test/firebase_options.dart';
import 'package:number_connection_test/games/number_connection_game/number_connection_game_over_view.dart';
import 'package:number_connection_test/games/number_connection_game/number_connection_game_ready_view.dart';
import 'package:number_connection_test/games/soldiers_in_formation/soldiers_in_formation_game_ending_view.dart';
import 'package:number_connection_test/games/soldiers_in_formation/soldiers_in_formation_ready_view.dart';
import 'package:number_connection_test/services/auth/auth_service.dart';
import 'package:number_connection_test/views/account_view/account_view.dart';
import 'package:number_connection_test/views/login_email_view/forget_password_view.dart';
import 'package:number_connection_test/views/login_email_view/home_view.dart';
import 'package:number_connection_test/views/login_email_view/login_view.dart';
import 'package:number_connection_test/views/records_view/records_view.dart';
import 'package:number_connection_test/views/login_email_view/register_view.dart';
import 'package:number_connection_test/views/login_email_view/verified.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // lock the device orientation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
        // Corrected here
        title: 'Number Connection Test',
        theme: ThemeData(
          primarySwatch: Colors.green,
          primaryColor: const Color.fromARGB(255, 120, 169, 140),
          textTheme: TextTheme(
            displayLarge: TextStyle(
              fontSize: 50.0.sp,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 120, 169, 140),
            ),
            headlineLarge: TextStyle(
              fontSize: 36.0.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
            headlineMedium: TextStyle(
              fontSize: 30.0.sp,
              // fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
            headlineSmall: TextStyle(
              fontSize: 24.sp,
              // fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
            titleLarge: TextStyle(fontSize: 30.0.sp),
            bodyLarge: TextStyle(fontSize: 24.0.sp),
            bodyMedium: TextStyle(fontSize: 20.0.sp),
            bodySmall: TextStyle(fontSize: 14.0.sp),
            labelLarge: TextStyle(fontSize: 20.0.sp),
            labelMedium: TextStyle(fontSize: 16.0.sp),
          ),
          buttonTheme: const ButtonThemeData(
            buttonColor: Color.fromARGB(255, 120, 169, 140),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              textStyle: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
              foregroundColor: const Color.fromARGB(255, 120, 169, 140),
            ),
          ),
        ),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''), // English
          Locale('zh', 'TW'), // Traditional Chinese
        ],
        home: const MyHomePage(title: 'Home'),
        routes: {
          numberConnectionReadyRoute: (context) =>
              const NumberConnectionReadyView(),
          colorVsWordsGameReadyRoute: (context) =>
              const ColorsVsWordGameReadyView(),
          soldiersInFormationGameReadyRoute: (context) =>
              const SoldiersInFormationGameReadyView(),
          homeRoute: (context) => const HomeView(),
          loginRoute: (context) => const LoginView(),
          registerRoute: (context) => const RegisterView(),
          accountRoute: (context) => const AccountView(),
          recordsRoute: (context) => const RecordsView(),
          verifyEmailRoute: (context) => const VerifyEmailView(),
          ncgameoverRoute: (context) => const NCGameOverView(),
          cwgameoverRoute: (context) => const CWGameOverView(),
          sifgameoverRoute: (context) => const SIFGameOverView(),
          forgotPasswordRoute: (context) => const ForgetPassView(),
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return const HomeView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
