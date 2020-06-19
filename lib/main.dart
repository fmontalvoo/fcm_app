import 'package:flutter/material.dart';
import 'package:fcm_app/src/providers/fcm_provider.dart';

import 'package:fcm_app/src/pages/home_page.dart';
import 'package:fcm_app/src/pages/notification_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    final fcmProvider = FCMProvider();
    fcmProvider.initNotifications();
    fcmProvider.getNotificationsStream.listen((message) {
      _navigatorKey.currentState.pushNamed('notification', arguments: message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'FCM APP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: 'home',
      routes: <String, WidgetBuilder>{
        'home': (BuildContext context) => HomePage(),
        'notification': (BuildContext context) => NotificationPage()
      },
    );
  }
}
