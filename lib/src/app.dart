import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:project_citra/src/cubit/cubit.dart';
import 'package:project_citra/src/cubit/page_cubit.dart';

import 'package:project_citra/src/cubit/session_chat_cubit.dart';

import 'package:project_citra/src/ui/pages/pages.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => UserCubit()),
        BlocProvider(create: (_) => CitraServiceCubit()),
        BlocProvider(create: (_) => CitraPartnerCubit()),
        BlocProvider(create: (_) => TransactionCubit()),
        BlocProvider(create: (_) => PusherMessageCubit()),
        BlocProvider(create: (_) => SessionChatCubit()),
        BlocProvider(create: (_) => PageCubit()),
      ],
      child: GetMaterialApp(
        title: 'Citra Consulting',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(),
        home: const SplashScreen(),
      ),
    );
  }
}
