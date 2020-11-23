import 'package:json_annotation/json_annotation.dart';

part 'userModel.g.dart';

@JsonSerializable()
class UserModel {
  String id,
      name,
      email,
      phone,
      institution,
      dob,
      gender,
      location,
      batch,
      branch,
      jobTitle,
      jobCompany,
      higherEducationInstitution,
      higherEducationBranch,
      higherEducationBatch,
      profileImg,
      createdOn;
  List tags;

  UserModel.general();

  UserModel(
      this.id,
      this.name,
      this.email,
      this.phone,
      this.institution,
      this.dob,
      this.gender,
      this.location,
      this.batch,
      this.branch,
      this.jobTitle,
      this.jobCompany,
      this.higherEducationInstitution,
      this.higherEducationBranch,
      this.higherEducationBatch,
      this.createdOn,
      this.profileImg,
      this.tags);

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
