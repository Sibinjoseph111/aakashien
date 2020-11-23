import 'package:aakashien/api/chopper_client_helper.dart';
import 'package:aakashien/models/userModel.dart';
import 'package:chopper/chopper.dart';

part 'user_api_service.chopper.dart';

@ChopperApi(baseUrl: '/user')
abstract class UserApiService extends ChopperService {
  @Post(path: '/login')
  Future<Response<UserModel>> login(
      @Body() Map<String, dynamic> loginCredentials);

  @Post(path: '/register')
  Future<Response<UserModel>> signup(
      @Body() Map<String, dynamic> registerCredentials);

  @Post(path: '/update')
  Future<Response<UserModel>> updateDetails(
      @Header('Auth-Token') String authToken,
      @Body() Map<String, dynamic> updateDetails);

  @Post(path: '/updatephone')
  Future<Response<UserModel>> updatePhone(
      @Header('Auth-Token') String authToken,
      @Body() Map<String, dynamic> phone);

  @Get(path: '/getdetails')
  Future<Response<UserModel>> userDetails(
      @Header('Auth-Token') String authToken);

  static UserApiService create() {
    final chopperClient = new ChopperClientHelper().create(_$UserApiService());

    return _$UserApiService(chopperClient);
  }
}
