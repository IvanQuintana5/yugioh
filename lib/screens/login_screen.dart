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
      body: Container(
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

    //creamos instancia del loginfromprovider que ya tenemos hecho
    final loginForm = Provider.of<LoginFormProvider>(context);

    return Center(
      child: Scaffold(
        body: DecoratedBox(
          decoration:
              const BoxDecoration(color: Color.fromARGB(255, 0, 0, 0)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 16,
                ),
                Container(
                  width: size.width * 0.80,
                  height: size.height * 0.17,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                      //todo: poner image
                      //image: decorationimage(image: ...)
                      //es por si va una imagen en la parte de arriibita de, box
                      ),
                ),
                Container(
                  width: size.width * 0.80,
                  height: size.height * 0.05,
                  alignment: Alignment.center,
                ),
                TextFormField(
                  autocorrect: false, //sin autocorrector pq es el correo,
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  decoration: const InputDecoration(
                    hintText: 'ejemplo@cola.com',
                    labelText: 'Email',
                    labelStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 255, 244, 244)),
                  ),
                  style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                  validator: (value) {
                    String pattern =
                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                    RegExp regExp = RegExp(pattern);
                    return regExp.hasMatch(value ?? '')
                        ? null
                        : 'El valor ingresado no es un correo';
                  },
                ),
                TextFormField(
                  autocorrect: false,
                  controller: _passwordController,
                  obscureText: true, //tapa loq  escribes ,
                  decoration: const InputDecoration(
                      hintText: '********',
                      labelText: 'Password',
                      labelStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 253, 246, 246))),
                          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                  validator: (value) {
                    return (value != null && value.length >= 8)
                        ? null
                        : 'La contrasenia debe ser mayor a 7 caracteres';
                  },
                ),
                const SizedBox(
                  height: 18,
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Olvidaste tu contraseña?',
                      style:
                          TextStyle(color: Color.fromARGB(255, 255, 244, 244))),
                ),
                ElevatedButton(
                    onPressed: loginForm.isLoading
                        ? null
                        : () async {
                            final authService = Provider.of<AuthServices>(
                                context,
                                listen: false);
                            //if(!loginForm.isValidForm()) return;

                            if (_emailController.text.isEmpty ||
                                _passwordController.text.isEmpty) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text(
                                        'LOS CAMPOS ESTÁN VACÍOS'),
                                    content: const Text(
                                        'Verifique que ingreso la contraseña y/o Email por favor'),
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
                                _passwordController.text);

                            if (token != null) {
                              // Navegar a PrincipalScreen y pasar el token
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PrincipalScreen(token: token),
                                ),
                              );
                            } else {
                              // Mostrar un error si el token es nulo (login fallido)
                              NotificationsServices.showSnackbar(
                                  'Login failed, please try again');
                              loginForm.isLoading = false;
                            }
                          },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB(255, 181, 184, 187))),
                    child: const Text('Iniciar sesion',
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(255, 250, 253, 247)))),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(255, 173, 171, 171),
                  )),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, 'register',
                        arguments: '');
                  },
                  child: const Text(
                    'Registrate',
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 250, 253, 247)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}