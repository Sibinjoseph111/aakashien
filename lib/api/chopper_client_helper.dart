import 'package:aakashien/api/json_type_converter.dart';
import 'package:aakashien/models/userModel.dart';
import 'package:chopper/chopper.dart';

class ChopperClientHelper {
  ChopperClient create(service) {
    final _chopperClient = ChopperClient(
        baseUrl: 'https://vast-journey-45935.herokuapp.com',
        services: [service],
        converter: JsonToTypeConverter(
            {UserModel: (jsonData) => UserModel.fromJson(jsonData)}),
        interceptors: [
          HttpLoggingInterceptor(),
        ]);

    return _chopperClient;
  }
}
