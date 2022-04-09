import 'dart:io';
import 'dart:math';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/services/pref_service.dart';
import 'package:intl/intl.dart';

class Utils {
  // FireSnackBar
  static fireSnackBar(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static String getMonthDayYear(String date) {
    final DateTime now = DateTime.parse(date);
    final String formatted = DateFormat.yMMMMd().format(now);
    return formatted;
  }

  static Future<bool> dialogCommon(
      BuildContext context, String title, String message, bool isSingle) async {
    return await showDialog(
      context: context,
      builder: (context) {
        if (Platform.isIOS) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              if (!isSingle)
                CupertinoDialogAction(
                  child: const Text("Cancel"),
                  onPressed: () {
                    Get.back(result: false);
                  },
                ),
              CupertinoDialogAction(
                child: const Text("Confirm"),
                onPressed: () {
                  Get.back(result: true);
                },
              ),
            ],
          );
        } else {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back(result: false);
                },
                child: Text("Cencel"),
              ),
              TextButton(
                onPressed: () {
                  Get.back(result: true);
                },
                child: Text("Confirm"),
              ),
            ],
          );
        }
      },
    );
  }

  static Future<Map<String, String>> deviceParams() async {
    Map<String, String> params = {};
    var deviceInfo = DeviceInfoPlugin();
    String fcmToken = (await Prefs.load(StorageKeys.TOKEN))!;

    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      params.addAll({
        'device_id': iosDeviceInfo.identifierForVendor!,
        'device_type': "I",
        'device_token': fcmToken,
      });
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      params.addAll({
        'device_id': androidDeviceInfo.androidId!,
        'device_type': "A",
        'device_token': fcmToken,
      });
    }

    return params;
  }

  static Future<void> showLocalNotification(RemoteMessage message) async {
    String title = message.notification!.title!;
    String body = message.notification!.body!;

    var android = const AndroidNotificationDetails('channelId', 'channelName',
        channelDescription: 'channelDescription');
    var iOS = const IOSNotificationDetails();
    var platform = NotificationDetails(android: android, iOS: iOS);

    int id = Random().nextInt((pow(2, 31) - 1).toInt());
    await FlutterLocalNotificationsPlugin().show(id, title, body, platform);
  }
}
