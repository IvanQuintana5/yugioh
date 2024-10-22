//esta libreria es pa q le diga a los demas widgets q va a haber cambios y q se debera actualziar
import 'package:flutter/material.dart';

//esto es pa validar el formulario de login
class LoginFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey =  GlobalKey<FormState>();
  String email = '';
  String password = '';

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value){
    _isLoading = value;
    //aqui es donde le dice a l widget que se actualice si usa esto.
    notifyListeners();
  }

  bool isValidForm(){
    print(formKey.currentState?.validate());
    print('$email - $password');
    return formKey.currentState?.validate() ?? false;
  }
}