import 'package:aakashien/api/user_api_service.dart';
import 'package:aakashien/screens/profile/profile.dart';
import 'package:aakashien/utility/myColors.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

void main() {
  _setupLogging();
  runApp(MyApp());
}

void _setupLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((event) {
    debugPrint('${event.level.name}: ${event.time}: ${event.message}');
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => UserApiService.create(),
      dispose: (_, UserApiService service) => service.client.dispose(),
      lazy: false,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: myColors.background,
          accentColor: myColors.white,
        ),
        home: Profile(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
