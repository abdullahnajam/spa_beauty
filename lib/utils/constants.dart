import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const darkBrown = Color(0xFF5f3926);
const lightBrown = Color(0xFFc59b6c);
const red = Color(0xFFc1272d);
const String genderPref="gender";
const String popupPref="popup";
const String genderImagePref="image";
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.max,
);