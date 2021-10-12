import 'package:flutter/material.dart';
import 'package:to_do_list_hive/ui/widgets/app/my_app.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
void main() async {
  await Hive.initFlutter();
  runApp(const MyApp());
}


