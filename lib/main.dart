import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/database.dart';
import 'package:patient_app/home_carer.dart';
import 'package:patient_app/splash_checkup.dart';
import 'package:patient_app/splash_medicine.dart';
import 'package:patient_app/splash_personal.dart';

import 'home_patient.dart';
import 'notification_controller.dart';
import 'splash.dart';
import 'utils.dart';
Future<void> _firebaseMessagingBackgroundHandler (RemoteMessage message) async{
  print('Handling a background message ${message.messageId}');
}

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
            channelKey: 'Personal',
            channelName: 'D-Diary',
            channelDescription: 'D-Diary Notification',
            enableVibration: true
        ),
        NotificationChannel(
            channelKey: 'Check Up',
            channelName: 'D-Diary',
            channelDescription: 'D-Diary Notification',
            enableVibration: true
        ),
        NotificationChannel(
            channelKey: 'Medicine Intake',
            channelName: 'D-Diary',
            channelDescription: 'D-Diary Notification',
            enableVibration: true
        )
      ]
  );
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.getInitialMessage;
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
  //await AndroidAlarmManager.initialize();
}

//final navigatorKey = GlobalKey<NavigatorState>();
//final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static const Color mainColor = Colors.deepPurple;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {

    // Only after at least the action method is set, the notification events are delivered
    AwesomeNotifications().setListeners(
        onActionReceivedMethod:         NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:    NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:  NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:  NotificationController.onDismissActionReceivedMethod
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: MyApp.navigatorKey,
      scaffoldMessengerKey: Utils.messengerKey,

      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (context) =>
                Splash(),//Splash(),
            );

          case '/notification-page':
            return MaterialPageRoute(builder: (context) {
              return notifDetails!.nType == 'Personal' ? SplashPersonal() : notifDetails!.nType == 'Medicine Intake' ? SplashMedicine() : notifDetails!.nType == 'Check Up' ? SplashCheckUp() : currentUser!.type ? HomeCarer() :HomePatient();
            });

          default:
            assert(false, 'Page ${settings.name} not found');
            return null;
        }
      },
    );
  }
}
