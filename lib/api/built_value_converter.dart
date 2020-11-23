import 'package:aakashien/models/serializers.dart';
import 'package:chopper/chopper.dart';

class BuiltValueConverter extends JsonConverter {
  @override
  Request convertRequest(Request request) {
    return super.convertRequest(
      request.copyWith(
        body: serializers.serializeWith(
            serializers.serializerForType(request.body.runtimeType),
            request.body),
      ),
    );
  }
}
