import 'package:authentication_repository/authentication_repository.dart';
import 'package:desafio_mobile/app/app.dart';
import 'package:desafio_mobile/authentication/authentication.dart';
import 'package:desafio_mobile/home/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  runApp(DesafioMobileApp(
    authenticationRepository: AuthenticationRepository(),
  ));
}

class DesafioMobileApp extends StatelessWidget {
  final AuthenticationRepository authenticationRepository;

  DesafioMobileApp({
    Key? key,
    required this.authenticationRepository,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authenticationRepository),
      ],
      child: BlocProvider(
        create: (_) => AuthenticationBloc(
          authenticationRepository: authenticationRepository,
        ),
        child: AppView(),
      ),
    );
  }
}
