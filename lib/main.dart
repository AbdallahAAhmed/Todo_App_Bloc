import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todo/home_layout.dart';

import 'cubit_observe.dart';

void main() {
  BlocOverrides.runZoned(
        () {
      // Use blocs...
    },
    blocObserver: MyBlocObserver(),
  );
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeLayout(),
    );
  }
}