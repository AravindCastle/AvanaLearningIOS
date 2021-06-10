import 'dart:async';
import 'dart:io';
import 'package:avana_academy/MessageEditor.dart';
import 'package:avana_academy/editUser.dart';
import 'package:avana_academy/facultyDetails.dart';
import 'package:avana_academy/facultyList.dart';
import 'package:avana_academy/feed.dart';
import 'package:avana_academy/feedDetails.dart';
import 'package:avana_academy/feedEditor.dart';
import 'package:avana_academy/galleryPage.dart';
import 'package:avana_academy/home.dart';
import 'package:avana_academy/messageView.dart';
import 'package:avana_academy/messagescreen.dart';
import 'package:avana_academy/photoview.dart';
import 'package:avana_academy/userDetailsPage.dart';
import 'package:avana_academy/userList.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';

import 'Utils.dart';
import 'addUser.dart';
import 'login.dart';

void main() => runApp(AvanaHome());

class AvanaHome extends StatelessWidget {
  // This widget is the root of your application.
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return PageTransition(
            child: LoginPage(),
            type: PageTransitionType.fade,
            settings:
                settings); //MaterialPageRoute(builder: (_) => LoginPage());
        break;
      /* case '/home':
        return PageTransition(
            child: HomePage(),
            type: PageTransitionType.fade,
            settings:
                settings); //MaterialPageRoute(builder: (_) => LoginPage());
        break;*/
      case '/messagePage':
        return PageTransition(
            child: MessagePage(),
            type: PageTransitionType.fade,
            settings: settings);
        break;
      case '/userlist':
        return PageTransition(
            child: userListPage(),
            type: PageTransitionType.fade,
            settings: settings);
        break;
      case '/adduser':
        return PageTransition(
            child: AddUserPage(),
            type: PageTransitionType.fade,
            settings: settings);
        break;
      case '/userdetailpage':
        Map<dynamic, dynamic> arguments = settings.arguments;

        return PageTransition(
            child: EditUser(
              currentUserId: arguments["userid"],
              currentUserName: arguments["username"],
            ),
            type: PageTransitionType.leftToRightWithFade,
            settings: settings);
        break;
      case '/messageeditor':
        return PageTransition(
            child: MessageEditor(),
            type: PageTransitionType.fade,
            settings: settings);
        break;
      case '/messageview':
        return PageTransition(
            child: MessageViewScreen(),
            type: PageTransitionType.fade,
            settings: settings);
        break;
      case '/photoview':
        return PageTransition(
            child: PhotoViewr(),
            type: PageTransitionType.fade,
            settings: settings);
        break;

      case '/gallery':
        return PageTransition(
            child: GalleryPage(),
            type: PageTransitionType.fade,
            settings: settings);
      case '/facultyPage':
        return PageTransition(
            child: facultyListPage(),
            type: PageTransitionType.fade,
            settings: settings);
      case '/facultyDetail':
        Map<dynamic, dynamic> arguments = settings.arguments;

        String userID = arguments["userid"];
        return PageTransition(
            child: FacultyDetailsPage(
              currentUserId: userID,
            ),
            type: PageTransitionType.fade,
            settings: settings);
      case '/feed':
        return PageTransition(
            child: FeedPage(),
            type: PageTransitionType.fade,
            settings: settings);
      case '/feededitor':
        return PageTransition(
            child: FeedEditor(),
            type: PageTransitionType.fade,
            settings: settings);
        break;
      case '/feeddetails':
        return PageTransition(
            child: FeedDetailScreen(),
            type: PageTransitionType.fade,
            settings: settings);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Avana Academy',
      onGenerateRoute: generateRoute,
      theme: ThemeData(
          backgroundColor: Colors.white54,
          textTheme: GoogleFonts.robotoTextTheme(),
          primaryIconTheme: IconThemeData(color: Colors.white),
          primarySwatch: MaterialColor(Color.fromRGBO(0, 0, 0, 1).value, {
            50: Color.fromRGBO(0, 0, 0, 0),
            100: Color.fromRGBO(0, 0, 0, .1),
            200: Color.fromRGBO(0, 0, 0, .2),
            300: Color.fromRGBO(0, 0, 0, .3),
            400: Color.fromRGBO(0, 0, 0, .4),
            500: Color.fromRGBO(0, 0, 0, .5),
            600: Color.fromRGBO(0, 0, 0, .6),
            700: Color.fromRGBO(0, 0, 0, .7),
            800: Color.fromRGBO(0, 0, 0, .8),
            900: Color.fromRGBO(0, 0, 0, .9)
          }),
          secondaryHeaderColor: Colors.white

          /* MaterialColor(Color.fromRGBO(117, 117, 117, 1).value, {
          50: Color.fromRGBO(117, 117, 117, 0),
          100: Color.fromRGBO(117, 117, 117, .1),
          200: Color.fromRGBO(117, 117, 117, .2), 
          300: Color.fromRGBO(117, 117, 117, .3),
          400: Color.fromRGBO(117, 117, 117, .4),
          500: Color.fromRGBO(117, 117, 117, .5),
          600: Color.fromRGBO(117, 117, 117, .6),
          700: Color.fromRGBO(117, 117, 117, .7),
          800: Color.fromRGBO(117, 117, 117, .8),
          900: Color.fromRGBO(117, 117, 117, .9)
        }),*/
          ),
      home: SplashScreen.navigate(
        name: 'assets/splashScreen.flr',
        next: (context) => AvanaHomePage(title: 'Avana Academy'),
        until: () => Future.delayed(Duration(seconds: 1)),
        startAnimation: 'splash',
        loopAnimation: "splash",
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(0.0, 1.0);
          var end = Offset.zero;
          var curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }
}

class BackgroundNotify {
  static Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) {
    if (message["data"]["screen"] == "resource" &&
        Utils.userId != message["data"]["ownerId"]) {
      Fluttertoast.showToast(
          msg: "New resources added please checkout",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else if ("messageview" == message["data"]["screen"]) {
      Utils.addNotificationId(
          message["data"]["docid"], message["data"]["ownerId"]);
    }

    // Or do other work.
  }
}

class AvanaHomePage extends StatefulWidget {
  AvanaHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _AvanaHomePageState createState() => _AvanaHomePageState();
}

class _AvanaHomePageState extends State<AvanaHomePage> {
  bool isUserLogged = false;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  StreamSubscription iosSubscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkUserLogged();
    _fcm.subscribeToTopic(Utils.notifyTopic);
    if (Platform.isIOS) {
      iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
        // save the token  OR subscribe to a topic here
      });

      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        if (this.mounted) {
          setState(() {
            if (message["data"]["screen"] == "resource" &&
                Utils.userId != message["data"]["ownerId"]) {
              Fluttertoast.showToast(
                  msg: "New resources added please checkout",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 3,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            } else if ("messageview" == message["data"]["screen"]) {
              Utils.addNotificationId(
                  message["data"]["docid"], message["data"]["ownerId"]);
            }
          });
        }
      },
      onLaunch: (Map<String, dynamic> message) async {
        if (this.mounted) {
          setState(() {
            if (message["data"]["screen"] == "resource") {
              Utils.isNewResourcesAdded = true;
              Fluttertoast.showToast(
                  msg: "New resources added please checkout",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 3,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            } else if ("messageview" == message["data"]["screen"]) {
              Utils.addNotificationId(
                  message["data"]["docid"], message["data"]["ownerId"]);
            }
          });
        }
      },
      onResume: (Map<String, dynamic> message) async {
        if (this.mounted) {
          setState(() {
            if (message["data"]["screen"] == "resource") {
              Utils.isNewResourcesAdded = true;
              Fluttertoast.showToast(
                  msg: "New resources added please checkout",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 3,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            } else if ("messageview" == message["data"]["screen"]) {
              Utils.addNotificationId(
                  message["data"]["docid"], message["data"]["ownerId"]);
            }
          });
        }
      },
    );
  }

  void checkUserLogged() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
	if (prefs.containsKey('userId')) {
      String userId = prefs.getString("userId");
      DocumentSnapshot userDetails = await Firestore.instance
          .collection('userdata')
          .document(userId)
          .get();
      if (userDetails.data.length > 0) {
        Utils.getAllUsersProfilePics();
        bool activeState = userDetails.data["isactive"];
        int membershipDate = userDetails.data["membershipdate"];
        int currDate = new DateTime.now().millisecondsSinceEpoch;
        Utils.userRole = userDetails.data["userrole"];
        Utils.userName = userDetails.data["username"];
        Utils.userEmail = userDetails.data["email"];
        Utils.userId = userId;

        isUserLogged =
            (currDate - membershipDate) > 31540000000 ? false : activeState;
      }
    }
    if (!isUserLogged) {
      Navigator.pushReplacementNamed(context, "/login");
    } else {
      Navigator.pushReplacementNamed(context, "/feed");
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData md = MediaQuery.of(context);
    return Scaffold(
      body: new Container(
          decoration: BoxDecoration(
              color: Colors.black, border: Border.all(color: Colors.black)),
          child: FlareActor('assets/splashScreen.flr', animation: 'splash')),
    );
  }
}
