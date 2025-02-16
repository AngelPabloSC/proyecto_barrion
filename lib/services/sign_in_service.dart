
import 'package:http/http.dart' as http;
import 'package:proyecto_barrion/core/constants/constants.dart';

class SignInService{
  final String _endPointLogin= "/user/register";


  Future<void> signIn() async{
    var params= {
      "email":"juanito123@gmail.com",
      "password":"Juanito123456"
    };

    try{
      var response = await http.post(Uri.parse("$domain$_endPointLogin"),body: params);
      print('>>>>>> ${response.body}');
    }catch (e){
      print('>>>>>> Error $e');
    }

  }
}