import 'package:church_service/models/Response.dart';


import '../httpHandler.dart';

class HttpRequest {
  HttpHandler handler = new HttpHandler();

  Future<Response> getLogin(String mobile, String password) {
    var result = handler.Login(mobile, password);
    return result;
  }

  Future<Response> signUp(String email, String mobile, String password) {
    var result = handler.sign(email, mobile, password);
    return result;
  }

  Future<Response> addSurvey(String username,
      String age,
      String gender,
      String EdLevel,
      String location,
      String microChurch,
      String yrsDcu,
      String child_below_13,
      String child_above_13,
      String prefered_service,
      String prof,
      String employment,
      String business,
      String dep_serve,
      String online_service) {
    var result = handler.survey(
        username,
        age,
        gender,
        EdLevel,
        location,
        microChurch,
        yrsDcu,
        child_below_13,
        child_above_13,
        prefered_service,
        prof,
        employment,
        business,
        dep_serve,
        online_service);
    return result;
  }


  Future<Response> bookSeat(String service, int seats, int church) {
    var result = handler.bookSeat(service, seats, church);
    return result;
  }
}