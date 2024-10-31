import 'package:flutter/material.dart';
import 'package:login_bueno_randy/providers/login_form_provider.dart';
import 'package:login_bueno_randy/screens/principal_screen.dart';
import 'package:login_bueno_randy/services/auth_services.dart';
import 'package:login_bueno_randy/services/notifications_services.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          true, // Permite que la pantalla se adapte al teclado
      backgroundColor: Colors.black, // Fondo negro
      body: SafeArea(
        child: ChangeNotifierProvider(
          create: (_) => LoginFormProvider(),
          child: _LoginForm(),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  _LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final loginForm = Provider.of<LoginFormProvider>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 15),
          // Imagen en la parte superior
          Center(
            child: Image.asset(
              'assets/logo.png', // Asegúrate de que el archivo esté en la carpeta assets
              width: size.width * 0.6,
              height: size.height * 0.4,
            ),
          ),
          const SizedBox(
              height: 25), // Espacio entre la imagen y los campos de texto
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            controller: _emailController,
            decoration: const InputDecoration(
              hintText: 'ejemplo@correo.com',
              labelText: 'Email',
              labelStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 255, 244, 244),
              ),
            ),
            style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
            validator: (value) {
              String pattern =
                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              RegExp regExp = RegExp(pattern);
              return regExp.hasMatch(value ?? '')
                  ? null
                  : 'El valor ingresado no es un correo';
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            autocorrect: false,
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              hintText: '********',
              labelText: 'Password',
              labelStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 253, 246, 246),
              ),
            ),
            style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
            validator: (value) {
              return (value != null && value.length >= 8)
                  ? null
                  : 'La contraseña debe ser mayor a 7 caracteres';
            },
          ),
          const SizedBox(height: 18),
          TextButton(
            onPressed: () {},
            child: const Text(
              'Olvidaste tu contraseña?',
              style: TextStyle(color: Color.fromARGB(255, 255, 244, 244)),
            ),
          ),
          ElevatedButton(
            onPressed: loginForm.isLoading
                ? null
                : () async {
                    final authService = Provider.of<AuthServices>(
                      context,
                      listen: false,
                    );

                    if (_emailController.text.isEmpty ||
                        _passwordController.text.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('LOS CAMPOS ESTÁN VACÍOS'),
                            content: const Text(
                                'Verifique que ingresó la contraseña y/o Email, por favor'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('OK'),
                              )
                            ],
                          );
                        },
                      );
                      return;
                    }

                    final String? token = await authService.login(
                      _emailController.text,
                      _passwordController.text,
                    );

                    if (token != null) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PrincipalScreen(token: token),
                        ),
                      );
                    } else {
                      NotificationsServices.showSnackbar(
                          'Login failed, please try again');
                      loginForm.isLoading = false;
                    }
                  },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  Color.fromARGB(255, 181, 184, 187)),
            ),
            child: const Text(
              'Iniciar sesión',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 250, 253, 247),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                Color.fromARGB(255, 173, 171, 171),
              ),
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(context, 'register',
                  arguments: '');
            },
            child: const Text(
              'Regístrate',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 250, 253, 247),
              ),
            ),
          ),
        ],
      ),
    );
  }
}