import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

class FCMProvider {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  final _streamController = StreamController<String>.broadcast();
  Stream<String> get getNotificationsStream => _streamController.stream;

  void initNotifications() async {
    _firebaseMessaging.requestNotificationPermissions();
    String token = await _firebaseMessaging.getToken();
    print('TOKEN>> $token');

    _firebaseMessaging.configure(
      onMessage: (message) async {
        print('---On_Message>>> $message');
        if (Platform.isAndroid)
          _streamController.sink.add(message['data']['arg'] ?? '');

        if (Platform.isIOS) _streamController.sink.add(message['arg'] ?? '');
      },
      onLaunch: (message) async {
        print('---On_Launch>>> $message');
      },
      onResume: (message) async {
        print('---On_Resume>>> $message');
        if (Platform.isAndroid)
          _streamController.sink.add(message['data']['arg'] ?? '');
        if (Platform.isIOS) _streamController.sink.add(message['arg'] ?? '');
      },
    );
  }

  dispose() {
    _streamController?.close();
  }
}
