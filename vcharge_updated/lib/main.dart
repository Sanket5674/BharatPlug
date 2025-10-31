import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';
import 'package:vcharge/utils/providers/customize_charging_provider/CustomizeProvider.dart';
import 'package:vcharge/utils/providers/darkThemeProvider.dart';
import 'package:vcharge/view/Security/LoginScreen.dart';
import 'package:vcharge/view/homeScreen/homeScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<bool> checkAuthToken() async {
    final storage = FlutterSecureStorage();
    final authToken = await storage.read(key: 'authToken');
    return authToken != null;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DarkThemeProvider()),
        ChangeNotifierProvider(create: (_) => CustomizeProvider()),
      ],
      child: Builder(builder: (BuildContext context) {
        final themeChanger = Provider.of<DarkThemeProvider>(context);

        return FutureBuilder<bool>(
          future: checkAuthToken(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final initialRoute = snapshot.data == true ? '/home' : '/login';

              return GetMaterialApp(
                title: 'vCharge',
                debugShowCheckedModeBanner: false,
                navigatorKey: navigatorKey,
                themeMode: themeChanger.themeMode,
                theme: ThemeData(
                  useMaterial3: false,
                  brightness: Brightness.light,
                  primarySwatch: Colors.green,
                  dividerColor: Colors.black,
                ),
                darkTheme: ThemeData(
                  dividerColor: Colors.white,
                  brightness: Brightness.dark,
                  iconTheme: const IconThemeData(
                    color: Colors.green,
                  ),
                  floatingActionButtonTheme:
                      const FloatingActionButtonThemeData(
                          backgroundColor: Colors.green),
                  drawerTheme: const DrawerThemeData(
                      backgroundColor: Colors.amberAccent),
                  textTheme: Typography.whiteRedwoodCity,
                  appBarTheme: const AppBarTheme(color: Colors.brown),
                ),
                initialRoute: initialRoute,
                routes: {
                  '/login': (context) => LoginScreen(),
                  '/home': (context) {
                    if (snapshot.data == true) {
                      final login = Login('userName', 'password');
                      return HomeScreen(login: login);
                    } else {
                      return LoginScreen();
                    }
                  },
                },
              );
            } else {
              Future.delayed(Duration(seconds: 1));
              return Container(
                  color: Colors.white,
                  child: Center(
                      child: Container(
                          child: Image.asset("assets/images/logo.png"))));
            }
          },
        );
      }),
    );
  }
}
