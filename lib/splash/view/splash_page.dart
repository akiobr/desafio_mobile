import 'package:desafio_mobile/components/widgets/custom_loader.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => SplashPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Desafio Mobile',
              style: Theme.of(context).textTheme.headline3,
            ),
            SizedBox(height: 40),
            CustomLoader(),
          ],
        ),
      ),
    );
  }
}
