import 'package:flutter_app/main.dart';
import 'package:flutter_app/services/local_authentication_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

GetIt locator;

void setupLocator(){
  locator.registerLazySingleton(() =>LocalAuthenticationService());
}

void main(){
  setupLocator();
  runApp(MyApp());
}