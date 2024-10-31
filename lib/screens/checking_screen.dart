import 'package:flutter/material.dart';
import 'package:login_bueno_randy/screens/login_screen.dart';
import 'package:login_bueno_randy/screens/principal_screen.dart';
import 'package:login_bueno_randy/services/auth_services.dart';
import 'package:provider/provider.dart';

class CheckAuthScreen extends StatelessWidget {
  const CheckAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //manda llamar la clase authservices
    final authServices = Provider.of<AuthServices>(context, listen: false);
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          //lee el token de auth services
          future: authServices.readToken(),
          builder: (BuildContext context,
              //captura de lo q hay en la app
              AsyncSnapshot<String> snapshot) {
            //si no hay info, regresa vacio
            if (!snapshot.hasData) return Text('');
            //en caso de q si, entra al login page
            if (snapshot.hasData != '') {
              Future.microtask(() {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                      //se pone a fuerza ya que son parametros que se piden pero que no usaremos
                      pageBuilder: (_, __, ___) => LoginScreen(),
                      transitionDuration: Duration(seconds: 0)),
                );
              });
            }
            //y si es falso lo regresa a la pantalla principal
            else {
              Future.microtask(() {
                Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                        pageBuilder: (_, __, ___) => PrincipalScreen(
                              token: '',
                            ),
                        transitionDuration: Duration(seconds: 0)));
              });
            }
            return Container();
          },
        ),
      ),
    );
  }
}