import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:login_bueno_randy/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices extends ChangeNotifier {
  final String _baseUrl ='xtestlogin.somee.com'; // Aquí va la URL de nuestro login. No lleva http ni www.
  final storage = new FlutterSecureStorage();

  // Método para registrar un nuevo usuario
  Future<String?> createUser(String email, String password) async {
    final Map<String, dynamic> authData = {
      'Email': email,
      'Password': password
    };

    // Crear la URL
    final url = Uri.http(_baseUrl, '/api/Cuentas/Registrar');

    // Realizar la petición HTTP
    final resp = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(authData),
    );

    // Decodificar la respuesta
    if (resp.body.contains('code')) {
      List<dynamic> decodeResp2 = json.decode(resp.body);
      if (decodeResp2[0].containsKey('description')) {
        print('Error en Password: ${decodeResp2[0]['description']}');
        return decodeResp2[0]['description'];
      }
    }

    final decodeResp = json.decode(resp.body);

    // Si en la respuesta tenemos token, lo guardamos en el dispositivo móvil
    if (decodeResp.containsKey('token')) {
      await storage.write(key: 'token', value: decodeResp['token']);
      return null; // Registro exitoso
    } else if (decodeResp.containsKey('errors')) {
      final errors = decodeResp['errors'];
      if (errors.containsKey('Email')) {
        print('Error en Email: ${errors['Email'][0]}');
        return errors['Email'][0];
      }
      if (errors.containsKey('Password')) {
        print('Error en Password: ${errors['Password'][0]}');
        return errors['Password'][0];
      }
    }

    // Retorno por defecto si no hay token ni errores
    return 'Error desconocido al registrar el usuario';
  }

  // Método para login
  Future<String?> login(String email, String password) async {
    final Map<String, dynamic> authData = {
      'Email': email,
      'Password': password,
    };

    final url = Uri.http(_baseUrl, '/api/Cuentas/Login');

    final resp = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(authData),
    );

    // Aquí imprimimos el cuerpo de la respuesta para ver si es lo que esperamos
    print('Response body: ${resp.body}');

    final decodeResp = json.decode(resp.body);

    // Verificar si la respuesta contiene un token
    if (decodeResp.containsKey('token')) {
      String token = decodeResp['token'];

      // Validar que el token esté en el formato JWT correcto (header.payload.signature)
      if (token.split('.').length != 3) {
        return 'Token no válido'; // Retorna error si no es un JWT válido
      }

      // Guardamos el token en el almacenamiento seguro
      await storage.write(key: 'token', value: decodeResp['token']);
      return token; // Login exitoso
    } else if (decodeResp.containsKey('errors')) {
      // Si hay errores en la respuesta, los manejamos
      final errors = decodeResp['errors'];
      if (errors.containsKey('Email')) {
        print('Error en Email: ${errors['Email'][0]}');
        return errors['Email'][0];
      }
      if (errors.containsKey('Password')) {
        print('Error en Password: ${errors['Password'][0]}');
        return errors['Password'][0];
      }
    }

    // Retorno por defecto si no hay token ni errores
    return 'Error desconocido al iniciar sesión';
  }

  // Método para leer el token almacenado (si existe)
  Future<String> readToken() async {
    return await storage.read(key: 'token') ?? '';
  }

  // Método para hacer logout (borrar el token)
 Future<void> logout() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  
  // no agregar esta linea a menos de que quieras que se elimine todo cada vez que se cierra la sesion
  //await prefs.clear(); // Limpiamos el almacenamiento, incluyendo el token

  await storage.delete(key: 'token'); // Elimina el token del almacenamiento seguro
}
  }