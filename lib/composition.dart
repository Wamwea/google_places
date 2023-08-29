import 'package:dio/dio.dart';
// ignore: depend_on_referenced_packages
import 'package:ioc_container/ioc_container.dart';
import 'package:location_app/search_service.dart';


IocContainerBuilder compose() => IocContainerBuilder()
  ..add((container) => Dio())
  ..addSingleton((container) => SearchService(dioClient: container()));
