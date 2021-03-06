import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/utils/unfocuser.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graphx/graphx.dart';

import 'statemangement/index.dart';
import 'ui/index.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  traceConfig(
    argsSeparator: "=>",
    showClassname: true,
    showFilename: true,
    showLinenumber: true,
    showMethodname: true,
  );
  Get.put(FirebaseService());
  Get.put(UserCrud());
  Get.put(UserController());
  Get.put(AuthService());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return GetMaterialApp(
      debugShowCheckedModeBanner: kDebugMode,
      title: 'Ismail Chat App',
      themeMode: ThemeMode.system,
      theme: ThemeData(
        primaryColor: Color(0xFF208CD4),
        textTheme: GoogleFonts.poppinsTextTheme(),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          brightness: Brightness.dark,
          textTheme: context.textTheme,
        ),
      ),
      darkTheme: ThemeData(
        scaffoldBackgroundColor: Color(0xFF16162C),
        brightness: Brightness.dark,
        appBarTheme: AppBarTheme(
          brightness: Brightness.dark,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          actionsIconTheme: IconThemeData(
            color: Colors.white,
          ),
          textTheme: GoogleFonts.poppinsTextTheme(
            ThemeData(brightness: Brightness.dark).textTheme,
          ),
        ),
        accentColor: Colors.amber,
        textTheme: GoogleFonts.poppinsTextTheme(
          ThemeData(brightness: Brightness.dark).textTheme,
        ),
        primaryColor: Color(0xFF208CD4),
      ),
      initialBinding: AuthBinding(),
      home: Unfocuser(
        child: ('onBoarding'.getValue ?? false) ? Root() : OnBoardingPage(),
      ),
    );
  }
}
