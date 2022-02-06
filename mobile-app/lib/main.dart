import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mobile_app/services/amplify.dart';
import 'package:mobile_app/services/auth/auth_repository.dart';
import 'package:mobile_app/services/session/session_cubit.dart';
import 'package:mobile_app/structure/data_repository.dart';
import 'package:mobile_app/app_navigator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  ///Theme data returned after initalization
  ThemeData? themeData;

  //async initStateMethod handling the futures
  initStateAsync() async {
    await AmplifyIntegration.initialize();

    // todo: set _isAmplifyConfigured Flag for showing loading view?

    ///todo: dummy data, replace with db-version
    setState(() {
      themeData = ThemeData();
    });
  }

  @override
  void initState() {
    super.initState();
    initStateAsync();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: themeData ?? ThemeData.light(),
        home: MultiRepositoryProvider(
                providers: [
                  RepositoryProvider(create: (context) => AuthRepository()),
                  RepositoryProvider(create: (context) => DataRepository())
                ],
                child: BlocProvider(
                  create: (context) => SessionCubit(
                    authRepo: context.read<AuthRepository>(),
                    dataRepo: context.read<DataRepository>(),
                  ),
                  child: const AppNavigator(),
                ),
              )
            );
  }
}
