// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations
class _$UserApiService extends UserApiService {
  _$UserApiService([ChopperClient client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = UserApiService;

  @override
  Future<Response<UserModel>> login(Map<String, dynamic> loginCredentials) {
    final $url = '/user/login';
    final $body = loginCredentials;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<UserModel, UserModel>($request);
  }

  @override
  Future<Response<UserModel>> signup(Map<String, dynamic> registerCredentials) {
    final $url = '/user/register';
    final $body = registerCredentials;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<UserModel, UserModel>($request);
  }

  @override
  Future<Response<UserModel>> updateDetails(
      String authToken, Map<String, dynamic> updateDetails) {
    final $url = '/user/update';
    final $headers = {'Auth-Token': authToken};
    final $body = updateDetails;
    final $request =
        Request('POST', $url, client.baseUrl, body: $body, headers: $headers);
    return client.send<UserModel, UserModel>($request);
  }

  @override
  Future<Response<UserModel>> updatePhone(
      String authToken, Map<String, dynamic> phone) {
    final $url = '/user/updatephone';
    final $headers = {'Auth-Token': authToken};
    final $body = phone;
    final $request =
        Request('POST', $url, client.baseUrl, body: $body, headers: $headers);
    return client.send<UserModel, UserModel>($request);
  }

  @override
  Future<Response<UserModel>> userDetails(String authToken) {
    final $url = '/user/getdetails';
    final $headers = {'Auth-Token': authToken};
    final $request = Request('GET', $url, client.baseUrl, headers: $headers);
    return client.send<UserModel, UserModel>($request);
  }
}
