import 'package:desafio_mobile/authentication/authentication.dart';
import 'package:desafio_mobile/components/widgets/custom_loader.dart';
import 'package:desafio_mobile/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'components/components.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => HomePage());
  }

  Widget _errorPage(String message) {
    return Column(
      children: [
        Text('Houve um erro inesperado!'),
        Text(message),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Desafio Mobile'),
        actions: [
          ButtonBar(
            children: [
              IconButton(
                icon: Icon(Icons.logout),
                onPressed: () => context
                    .read<AuthenticationBloc>()
                    .add(AuthenticationLogoutRequested()),
              ),
            ],
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) => HomeBloc(),
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeInitial)
              context.read<HomeBloc>().add(HomeCheckPermissions());

            if (state is HomePermissionDenied) return HomeDenied();

            if (state is HomeShowingMap)
              return HomeMap(coordinates: state.coordinates);

            if (state is HomeError) return _errorPage(state.errorMessage);

            return CustomLoader();
          },
        ),
      ),
    );
  }
}
