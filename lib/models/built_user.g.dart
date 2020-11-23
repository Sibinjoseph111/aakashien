// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'built_user.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<BuiltUser> _$builtUserSerializer = new _$BuiltUserSerializer();

class _$BuiltUserSerializer implements StructuredSerializer<BuiltUser> {
  @override
  final Iterable<Type> types = const [BuiltUser, _$BuiltUser];
  @override
  final String wireName = 'BuiltUser';

  @override
  Iterable<Object> serialize(Serializers serializers, BuiltUser object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[];
    if (object.id != null) {
      result
        ..add('id')
        ..add(serializers.serialize(object.id,
            specifiedType: const FullType(String)));
    }
    if (object.name != null) {
      result
        ..add('name')
        ..add(serializers.serialize(object.name,
            specifiedType: const FullType(String)));
    }
    if (object.email != null) {
      result
        ..add('email')
        ..add(serializers.serialize(object.email,
            specifiedType: const FullType(String)));
    }
    if (object.phone != null) {
      result
        ..add('phone')
        ..add(serializers.serialize(object.phone,
            specifiedType: const FullType(String)));
    }
    if (object.institution != null) {
      result
        ..add('institution')
        ..add(serializers.serialize(object.institution,
            specifiedType: const FullType(String)));
    }
    if (object.dob != null) {
      result
        ..add('dob')
        ..add(serializers.serialize(object.dob,
            specifiedType: const FullType(String)));
    }
    if (object.gender != null) {
      result
        ..add('gender')
        ..add(serializers.serialize(object.gender,
            specifiedType: const FullType(String)));
    }
    if (object.location != null) {
      result
        ..add('location')
        ..add(serializers.serialize(object.location,
            specifiedType: const FullType(String)));
    }
    if (object.batch != null) {
      result
        ..add('batch')
        ..add(serializers.serialize(object.batch,
            specifiedType: const FullType(String)));
    }
    if (object.branch != null) {
      result
        ..add('branch')
        ..add(serializers.serialize(object.branch,
            specifiedType: const FullType(String)));
    }
    if (object.jobTitle != null) {
      result
        ..add('jobTitle')
        ..add(serializers.serialize(object.jobTitle,
            specifiedType: const FullType(String)));
    }
    if (object.jobCompany != null) {
      result
        ..add('jobCompany')
        ..add(serializers.serialize(object.jobCompany,
            specifiedType: const FullType(String)));
    }
    if (object.higherEducationInstitution != null) {
      result
        ..add('higherEducationInstitution')
        ..add(serializers.serialize(object.higherEducationInstitution,
            specifiedType: const FullType(String)));
    }
    if (object.higherEducationBranch != null) {
      result
        ..add('higherEducationBranch')
        ..add(serializers.serialize(object.higherEducationBranch,
            specifiedType: const FullType(String)));
    }
    if (object.higherEducationBatch != null) {
      result
        ..add('higherEducationBatch')
        ..add(serializers.serialize(object.higherEducationBatch,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  BuiltUser deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new BuiltUserBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'email':
          result.email = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'phone':
          result.phone = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'institution':
          result.institution = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'dob':
          result.dob = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'gender':
          result.gender = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'location':
          result.location = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'batch':
          result.batch = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'branch':
          result.branch = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'jobTitle':
          result.jobTitle = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'jobCompany':
          result.jobCompany = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'higherEducationInstitution':
          result.higherEducationInstitution = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'higherEducationBranch':
          result.higherEducationBranch = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'higherEducationBatch':
          result.higherEducationBatch = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$BuiltUser extends BuiltUser {
  @override
  final String id;
  @override
  final String name;
  @override
  final String email;
  @override
  final String phone;
  @override
  final String institution;
  @override
  final String dob;
  @override
  final String gender;
  @override
  final String location;
  @override
  final String batch;
  @override
  final String branch;
  @override
  final String jobTitle;
  @override
  final String jobCompany;
  @override
  final String higherEducationInstitution;
  @override
  final String higherEducationBranch;
  @override
  final String higherEducationBatch;

  factory _$BuiltUser([void Function(BuiltUserBuilder) updates]) =>
      (new BuiltUserBuilder()..update(updates)).build();

  _$BuiltUser._(
      {this.id,
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
      this.higherEducationBatch})
      : super._();

  @override
  BuiltUser rebuild(void Function(BuiltUserBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuiltUserBuilder toBuilder() => new BuiltUserBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuiltUser &&
        id == other.id &&
        name == other.name &&
        email == other.email &&
        phone == other.phone &&
        institution == other.institution &&
        dob == other.dob &&
        gender == other.gender &&
        location == other.location &&
        batch == other.batch &&
        branch == other.branch &&
        jobTitle == other.jobTitle &&
        jobCompany == other.jobCompany &&
        higherEducationInstitution == other.higherEducationInstitution &&
        higherEducationBranch == other.higherEducationBranch &&
        higherEducationBatch == other.higherEducationBatch;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc(
                            $jc(
                                $jc(
                                    $jc(
                                        $jc(
                                            $jc(
                                                $jc(
                                                    $jc(
                                                        $jc($jc(0, id.hashCode),
                                                            name.hashCode),
                                                        email.hashCode),
                                                    phone.hashCode),
                                                institution.hashCode),
                                            dob.hashCode),
                                        gender.hashCode),
                                    location.hashCode),
                                batch.hashCode),
                            branch.hashCode),
                        jobTitle.hashCode),
                    jobCompany.hashCode),
                higherEducationInstitution.hashCode),
            higherEducationBranch.hashCode),
        higherEducationBatch.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('BuiltUser')
          ..add('id', id)
          ..add('name', name)
          ..add('email', email)
          ..add('phone', phone)
          ..add('institution', institution)
          ..add('dob', dob)
          ..add('gender', gender)
          ..add('location', location)
          ..add('batch', batch)
          ..add('branch', branch)
          ..add('jobTitle', jobTitle)
          ..add('jobCompany', jobCompany)
          ..add('higherEducationInstitution', higherEducationInstitution)
          ..add('higherEducationBranch', higherEducationBranch)
          ..add('higherEducationBatch', higherEducationBatch))
        .toString();
  }
}

class BuiltUserBuilder implements Builder<BuiltUser, BuiltUserBuilder> {
  _$BuiltUser _$v;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  String _email;
  String get email => _$this._email;
  set email(String email) => _$this._email = email;

  String _phone;
  String get phone => _$this._phone;
  set phone(String phone) => _$this._phone = phone;

  String _institution;
  String get institution => _$this._institution;
  set institution(String institution) => _$this._institution = institution;

  String _dob;
  String get dob => _$this._dob;
  set dob(String dob) => _$this._dob = dob;

  String _gender;
  String get gender => _$this._gender;
  set gender(String gender) => _$this._gender = gender;

  String _location;
  String get location => _$this._location;
  set location(String location) => _$this._location = location;

  String _batch;
  String get batch => _$this._batch;
  set batch(String batch) => _$this._batch = batch;

  String _branch;
  String get branch => _$this._branch;
  set branch(String branch) => _$this._branch = branch;

  String _jobTitle;
  String get jobTitle => _$this._jobTitle;
  set jobTitle(String jobTitle) => _$this._jobTitle = jobTitle;

  String _jobCompany;
  String get jobCompany => _$this._jobCompany;
  set jobCompany(String jobCompany) => _$this._jobCompany = jobCompany;

  String _higherEducationInstitution;
  String get higherEducationInstitution => _$this._higherEducationInstitution;
  set higherEducationInstitution(String higherEducationInstitution) =>
      _$this._higherEducationInstitution = higherEducationInstitution;

  String _higherEducationBranch;
  String get higherEducationBranch => _$this._higherEducationBranch;
  set higherEducationBranch(String higherEducationBranch) =>
      _$this._higherEducationBranch = higherEducationBranch;

  String _higherEducationBatch;
  String get higherEducationBatch => _$this._higherEducationBatch;
  set higherEducationBatch(String higherEducationBatch) =>
      _$this._higherEducationBatch = higherEducationBatch;

  BuiltUserBuilder();

  BuiltUserBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _name = _$v.name;
      _email = _$v.email;
      _phone = _$v.phone;
      _institution = _$v.institution;
      _dob = _$v.dob;
      _gender = _$v.gender;
      _location = _$v.location;
      _batch = _$v.batch;
      _branch = _$v.branch;
      _jobTitle = _$v.jobTitle;
      _jobCompany = _$v.jobCompany;
      _higherEducationInstitution = _$v.higherEducationInstitution;
      _higherEducationBranch = _$v.higherEducationBranch;
      _higherEducationBatch = _$v.higherEducationBatch;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuiltUser other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$BuiltUser;
  }

  @override
  void update(void Function(BuiltUserBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$BuiltUser build() {
    final _$result = _$v ??
        new _$BuiltUser._(
            id: id,
            name: name,
            email: email,
            phone: phone,
            institution: institution,
            dob: dob,
            gender: gender,
            location: location,
            batch: batch,
            branch: branch,
            jobTitle: jobTitle,
            jobCompany: jobCompany,
            higherEducationInstitution: higherEducationInstitution,
            higherEducationBranch: higherEducationBranch,
            higherEducationBatch: higherEducationBatch);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
