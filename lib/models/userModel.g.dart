// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return UserModel(
    json['id'] as String,
    json['name'] as String,
    json['email'] as String,
    json['phone'] as String,
    json['institution'] as String,
    json['dob'] as String,
    json['gender'] as String,
    json['location'] as String,
    json['batch'] as String,
    json['branch'] as String,
    json['jobTitle'] as String,
    json['jobCompany'] as String,
    json['higherEducationInstitution'] as String,
    json['higherEducationBranch'] as String,
    json['higherEducationBatch'] as String,
    json['createdOn'] as String,
    json['profileImg'] as String,
    json['tags'] as List,
  );
}

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'institution': instance.institution,
      'dob': instance.dob,
      'gender': instance.gender,
      'location': instance.location,
      'batch': instance.batch,
      'branch': instance.branch,
      'jobTitle': instance.jobTitle,
      'jobCompany': instance.jobCompany,
      'higherEducationInstitution': instance.higherEducationInstitution,
      'higherEducationBranch': instance.higherEducationBranch,
      'higherEducationBatch': instance.higherEducationBatch,
      'profileImg': instance.profileImg,
      'createdOn': instance.createdOn,
      'tags': instance.tags,
    };
