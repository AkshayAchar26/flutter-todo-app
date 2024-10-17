import 'dart:io';

import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

abstract class NetworkInfo {
  Future<bool> hasInternet();
  Future<InternetConnectionStatus> getConnectionStatus();
}

class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionCheckerPlus _connectionCheckerPlus = InternetConnectionCheckerPlus();

  NetworkInfoImpl();

  @override
  Future<bool> hasInternet() async {
    try {
      final result = await _connectionCheckerPlus.hasConnection;
      return result;
    } on SocketException catch (e) {
      // Handle SocketException (e.g., log the error)
      print('SocketException: $e'); 
      return false;
    } on HttpException catch (e) {
      // Handle HttpException (e.g., log the error)
      print('HttpException: $e');
      return false;
    } catch (e) {
      // Handle other exceptions
      print('Error checking internet connection: $e');
      return false;
    }
  }
  
  @override
  Future<InternetConnectionStatus> getConnectionStatus() async {
    return await _connectionCheckerPlus.connectionStatus;
  }
}
