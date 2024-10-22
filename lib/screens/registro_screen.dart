import 'package:flutter/material.dart';
//import 'package:login_bueno_randy/providers/login_form_provider.dart';
import 'package:login_bueno_randy/services/auth_services.dart';
import 'package:login_bueno_randy/services/notifications_services.dart';
import 'package:provider/provider.dart';

class RegistroScreen extends StatelessWidget{
  RegistroScreen({super.key});
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  @override
  Widget build(BuildContext context){
    //final loginForm = Provider.of<LoginFormProvider>(context);
    final size = MediaQuery.of(context).size;


    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 192, 131, 51)
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: size.width * 0.80,
                height: size.height* 0.17,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  //todo: agregar una imagen
                ),
              ),
              Container(
                width: size.width * 0.80,
                height: size.height* 0.05,
                alignment: Alignment.center,
              ),
              TextField(
                controller:  _emailController,
                decoration: const InputDecoration(
                  hintText: 'ejemplo@email.com',
                  labelText: 'Email',
                  labelStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 255, 244, 244)
                  )
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller:  _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: '*****',
                  labelText: 'Contraseña',
                  labelStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 255, 244, 244)
                  )
                ),
              ),
              const SizedBox(
                  height: 16,
                ),
                TextButton(
                  onPressed: (){}, 
                  child: const Text('Olvidaste tu contraseña?', 
                    style: TextStyle(color: Color.fromARGB(255, 255, 244, 244))
                  ), 
                ),
                ElevatedButton(
                  onPressed: () async {
                    final authService = Provider.of<AuthServices>(context, listen: false);

                    final String? errorMessage = await authService.createUser(
                      //loginForm.email, loginForm.password
                      _emailController.text, _passwordController.text
                    );

                    if(errorMessage == null){
                      Navigator.pushReplacementNamed(context, 'register');
                    }
                    else {
                      NotificationsServices.showSnackbar(errorMessage);
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(255, 181, 184, 187
                    )
                  )
                ),
                child: const Text(
                  'Registra tu usuario',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 250, 253, 247)
                  )
                )
              ),
              const SizedBox(
                height: 16,
              ),
              TextButton(
                onPressed: (){
                  print('Boton iniciar sesion');
                  Navigator.pushNamed(context, 'login', arguments: '');
                }, 
                child: const Text(
                  'Ya tienes una cuenta? Iniciar sesion', 
                  style: TextStyle(color: Color.fromARGB(255, 255, 244, 244),
                  )
                ),
              ),
              // const SizedBox(
              //   height: 16,
              // ),
              // ElevatedButton(
              //   style: ButtonStyle(
              //     backgroundColor: MaterialStateProperty.all<Color>(
              //       Color.fromARGB(255, 255, 244, 244)
              //     )
              //   ),
              //   onPressed: (){

              //   },
              // )
            ],
          ),
        ),
      ),
    );
  }
}