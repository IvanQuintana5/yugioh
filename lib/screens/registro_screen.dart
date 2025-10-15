import 'package:flutter/material.dart';
import 'package:login_bueno_randy/services/auth_services.dart';
import 'package:login_bueno_randy/services/notifications_services.dart';
import 'package:provider/provider.dart';

class RegistroScreen extends StatefulWidget {
  RegistroScreen({super.key});

  @override
  _RegistroScreenState createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

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
              Center(
                child: Image.asset(
                  'assets/logo.png',
                  width: size.width * 0.6,
                  height: size.height * 0.2,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                style: const TextStyle(color: Colors.white), // Texto en blanco
                decoration: const InputDecoration(
                  hintText: 'ejemplo@email.com',
                  hintStyle:
                      TextStyle(color: Colors.white54), // Hint en blanco opaco
                  labelText: 'Email',
                  labelStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.white, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                        color: const Color.fromARGB(255, 245, 220, 33),
                        width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              TextField(
                controller: _passwordController,
                obscureText: _obscureText,
                style: const TextStyle(color: Colors.white), // Texto en blanco
                decoration: InputDecoration(
                  hintText: '*******',
                  hintStyle: const TextStyle(
                      color: Colors.white54), // Hint en blanco opaco
                  labelText: 'Contraseña',
                  labelStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 255, 244, 244),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.white, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                        color: const Color.fromARGB(255, 245, 220, 33),
                        width: 1.5),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
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
                    Navigator.pushReplacementNamed(context, 'login');
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
                  'Ya tienes una cuenta? Iniciar sesión',
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
