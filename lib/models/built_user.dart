import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'built_user.g.dart';

abstract class BuiltUser implements Built<BuiltUser, BuiltUserBuilder> {
  @nullable
  String get id;

  @nullable
  String get name;

  @nullable
  String get email;

  @nullable
  String get phone;

  @nullable
  String get institution;

  @nullable
  String get dob;

  @nullable
  String get gender;

  @nullable
  String get location;

  @nullable
  String get batch;

  @nullable
  String get branch;

  @nullable
  String get jobTitle;

  @nullable
  String get jobCompany;

  @nullable
  String get higherEducationInstitution;

  @nullable
  String get higherEducationBranch;

  @nullable
  String get higherEducationBatch;

  // @nullable
  // List get tags;
  //
  // @nullable
  // String get createdOn;
  //
  // @nullable
  // String get v;

  BuiltUser._();

  factory BuiltUser([updates(BuiltUserBuilder b)]) = _$BuiltUser;

  static Serializer<BuiltUser> get serializer => _$builtUserSerializer;
}
