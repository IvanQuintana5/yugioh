import 'package:flutter/material.dart';
import 'package:login_bueno_randy/services/auth_services.dart';
import 'package:login_bueno_randy/services/notifications_services.dart';
import 'package:provider/provider.dart';

class RegistroScreen extends StatelessWidget {
  RegistroScreen({super.key});
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 0, 0, 0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Contenedor para la imagen de fondo
              Center(
                child: Image.asset(
                  'assets/logo.png', // Asegúrate de que el archivo esté en la carpeta assets
                  width: size.width * 0.6,
                  height: size.height * 0.2,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: 'ejemplo@email.com',
                  labelText: 'Email',
                  labelStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 255, 244, 244),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: '*******',
                  labelText: 'Contraseña',
                  labelStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 255, 244, 244),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Olvidaste tu contraseña?',
                  style: TextStyle(color: Color.fromARGB(255, 255, 244, 244)),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  final authService =
                      Provider.of<AuthServices>(context, listen: false);

                  final String? errorMessage = await authService.createUser(
                    _emailController.text,
                    _passwordController.text,
                  );

                  if (errorMessage == null) {
                    // Navegar a PrincipalScreen
                    Navigator.pushReplacementNamed(context, 'login');

                    // Mostrar notificación de registro exitoso después de un pequeño retraso
                    Future.delayed(const Duration(milliseconds: 500), () {
                      NotificationsServices.showSnackbar(
                          'Registro exitoso: Email y contraseña registrados.');
                    });
                  } else {
                    NotificationsServices.showSnackbar(errorMessage);
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(255, 181, 184, 187),
                  ),
                ),
                child: const Text(
                  'Registra tu usuario',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 250, 253, 247),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'login', arguments: '');
                },
                child: const Text(
                  'Ya tienes una cuenta? Iniciar sesion',
                  style: TextStyle(color: Color.fromARGB(255, 255, 244, 244)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
