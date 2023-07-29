import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'Repoistry/Repoistry.dart';
import 'Repoistry/Sqflite.dart';
import 'View/home2.dart';
import 'ViewModel/Cubit.dart';

void main (
    )async
{

  WidgetsFlutterBinding.ensureInitialized();




  runApp(MyApp());
}



class MyApp extends StatelessWidget
{
  MyApp();

  @override
  Widget build(BuildContext context)
  {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,

        builder: (context , child) {
          return  MultiBlocProvider(
              providers: [

          BlocProvider(create: (context) => RoomCubit(MyRepository(SqfliteDataSource()))..createDatabase())

          ],child:MaterialApp(
            debugShowCheckedModeBanner: false,
            home: RoomScreen()

            ));
        });
  }
}