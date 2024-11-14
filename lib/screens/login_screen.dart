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
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      body: SafeArea(
        child: ChangeNotifierProvider(
          create: (_) => LoginFormProvider(),
          child: _LoginForm(),
        ),
      ),
    );
  }
}

class _LoginForm extends StatefulWidget {
  _LoginForm({super.key});

  @override
  __LoginFormState createState() => __LoginFormState();
}

class __LoginFormState extends State<_LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

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
          Center(
            child: Image.asset(
              'assets/logo.png',
              width: size.width * 0.6,
              height: size.height * 0.4,
            ),
          ),
          const SizedBox(height: 25),
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            controller: _emailController,
            decoration: const InputDecoration(
              hintText: 'ejemplo@correo.com',
              hintStyle: TextStyle(color: Colors.white54), // Hint en blanco opaco
              labelText: 'Email',
              labelStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 255, 244, 244),
              ),
              // Borde del cuadro
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
                borderSide: BorderSide(color: const Color.fromARGB(255, 245, 220, 33), width: 1.5),
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
            obscureText: _obscureText,
            decoration: InputDecoration(
              hintText: '********',
              hintStyle: TextStyle(color: Colors.white54), // Hint en blanco opaco
              labelText: 'Password',
              labelStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 253, 246, 246),
              ),
              // Borde del cuadro
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
                borderSide: BorderSide(color: const Color.fromARGB(255, 245, 220, 33), width: 1.5),
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

                    final String? response = await authService.login(
                      _emailController.text,
                      _passwordController.text,
                    );

                    if (response == null ||
                        response.contains('Login incorrecto')) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Login Failed"),
                            content: const Text(
                                "Correo o contraseña incorrectos. Por favor, intente de nuevo."),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("OK"),
                              ),
                            ],
                          );
                        },
                      );
                      loginForm.isLoading = false;
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PrincipalScreen(token: response),
                        ),
                      );
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
              Navigator.pushReplacementNamed(context, 'register', arguments: '');
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
