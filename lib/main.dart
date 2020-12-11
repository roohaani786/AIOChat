import 'package:after_layout/after_layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:techstagram/Login/login_screen.dart';
import 'package:techstagram/Welcome/welcome_screen.dart';
import 'package:techstagram/intro/intro_page.dart';
import 'package:techstagram/resources/repository.dart';
import 'package:techstagram/ui/HomePage.dart';
import 'package:techstagram/ui/ProfilePage.dart';
import 'Signup/signup_screen.dart';

int initScreen;
int initialindexg;
bool seen;

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  // SharedPreferences.setMockInitialValues({});
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp());

}


class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Yammerly',
      debugShowCheckedModeBanner: false,

      routes: {
        '/Login': (context) => LoginScreen(),
        '/Welcome': (context) => WelcomeScreen(),
        '/nayasignup': (context) => SignUpScreen(),
        '/Profile': (context) => AccountBottomIconScreen(),
        '/HomePage': (context) => HomePage(),
      },

      theme: new ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.black,
        primaryIconTheme: IconThemeData(color: Colors.black),
        primaryTextTheme: TextTheme(
            headline6: TextStyle(
              color: Colors.black,
            )),
        textTheme: TextTheme(
            headline6: TextStyle(
              color: Colors.black,
            )),
      ),

      home: Check(),
    );
  }
}

class Check extends StatefulWidget {
  @override
  CheckState createState() => new CheckState();
}

class CheckState extends State<Check> with AfterLayoutMixin<Check> {
//  final LocalAuthenticationService _localAuth = locator<LocalAuthenticationService>();

//  here we are checking if user cames in application first time
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //getting data using shared prefrence
    bool seen = (prefs.getBool('seen') ?? false);

    if (seen == false) {

      print("IntroScreen");
      //checking data using shared prefrence
      prefs.setBool('seen', true);
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new IntroPage()));

    } else {

      print("WelcomeScreen");
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new LoginCheck()));

    }
  }

  @override
  void afterFirstLayout(BuildContext context) => checkFirstSeen();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body:Center(),
    );
  }
}

class LoginCheck extends StatefulWidget{

  @override
  _LoginCheckState createState() => _LoginCheckState();
}

class _LoginCheckState extends State<LoginCheck> {

  var _repository = Repository();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder(
      future: _repository.getCurrentUser(),
      builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
        if (snapshot.hasData) {

          print("Already Loggedin");
          return HomePage();

        } else {
          print("Not loggedIn");
          return WelcomeScreen();
        }
      },
    );
  }
}





// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:techstagram/Login/login_screen.dart';
// import 'package:techstagram/Welcome/welcome_screen.dart';
// import 'package:techstagram/intro/intro_page.dart';
// import 'package:techstagram/resources/repository.dart';
// import 'package:techstagram/ui/HomePage.dart';
// import 'package:techstagram/ui/ProfilePage.dart';
// import 'Signup/signup_screen.dart';
//
// int initScreen;
// int initialindexg;
//
// Future<void> main() async {
// //  setupLocator();
//   WidgetsFlutterBinding.ensureInitialized();
//   SharedPreferences.setMockInitialValues({});
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   initScreen = await prefs.getInt("initScreen");
//   await prefs.setInt("initScreen", 1);
//   print('initScreen ${initScreen}');
//   runApp(MyApp());
// }
//
// //Main entry-point class
//
// class MyApp extends StatefulWidget {
//   @override
//   MyAppState createState() {
//     return new MyAppState();
//   }
// }
//
// class MyAppState extends State<MyApp> {
//   var _repository = Repository();
//
//   @override
//   Widget build(BuildContext context) {
//
//       return MaterialApp(
//
//           title: 'AIOChat',
//           debugShowCheckedModeBanner: false,
//
//           //navigatorKey: Catcher.navigatorKey,
//
//
//           routes: {
//             '/Login': (context) => LoginScreen(),
//             '/Welcome': (context) => WelcomeScreen(),
//             '/nayasignup': (context) => SignUpScreen(),
// //            '/Twit': (context) => TwitterLoginScreen(),
//             '/Profile': (context) => AccountBottomIconScreen(),
//             '/HomePage': (context) => HomePage(),
//           },
//
//
//           theme: new ThemeData(
//             primarySwatch: Colors.blue,
//             primaryColor: Colors.black,
//             primaryIconTheme: IconThemeData(color: Colors.black),
//             primaryTextTheme: TextTheme(
//                 headline6: TextStyle(
//                   color: Colors.black,)),
//             textTheme: TextTheme(headline6: TextStyle(
//               color: Colors.black,)),
//           ),
//
//
//           home:
//           FutureBuilder(
//             future: _repository.getCurrentUser(),
//             builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
//               if (snapshot.hasData) {
// //                return Biometricauth();
//                 return HomePage();
//               } else {
// //                return Biometricauth();
//                 return Check();
//               }
//             },
//           )
//       );
//   }
// }
//
// class Check extends StatefulWidget {
//   @override
//   CheckState createState() => new CheckState();
// }
//
// class CheckState extends State<Check> {
//
// //  final LocalAuthenticationService _localAuth = locator<LocalAuthenticationService>();
//
//
//   @override
//   Widget build(BuildContext context) {
//     if (initScreen == 0 || initScreen == null) {
//       return IntroPage();
//     }
//     else {
//       return WelcomeScreen();
//     }
//   }
//
//
// }
