import 'package:desafio_mobile/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeDenied extends StatelessWidget {
  const HomeDenied({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Verifique as permissões de localização do seu dispositivo'),
        ElevatedButton(
          child: Text('Tentar novamente'),
          onPressed: () => context.read<HomeBloc>().add(HomeCheckPermissions()),
        ),
      ],
    );
  }
}
