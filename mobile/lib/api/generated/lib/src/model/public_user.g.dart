// @dart=2.19


// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_user.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PublicUser extends PublicUser {
  @override
  final String? id;
  @override
  final String? email;
  @override
  final String? displayName;
  @override
  final num? heightCm;
  @override
  final num? weightKg;
  @override
  final DateTime? birthDate;
  @override
  final DateTime? createdAt;

  factory _$PublicUser([void Function(PublicUserBuilder)? updates]) =>
      (PublicUserBuilder()..update(updates))._build();

  _$PublicUser._(
      {this.id,
      this.email,
      this.displayName,
      this.heightCm,
      this.weightKg,
      this.birthDate,
      this.createdAt})
      : super._();
  @override
  PublicUser rebuild(void Function(PublicUserBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PublicUserBuilder toBuilder() => PublicUserBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PublicUser &&
        id == other.id &&
        email == other.email &&
        displayName == other.displayName &&
        heightCm == other.heightCm &&
        weightKg == other.weightKg &&
        birthDate == other.birthDate &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, heightCm.hashCode);
    _$hash = $jc(_$hash, weightKg.hashCode);
    _$hash = $jc(_$hash, birthDate.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PublicUser')
          ..add('id', id)
          ..add('email', email)
          ..add('displayName', displayName)
          ..add('heightCm', heightCm)
          ..add('weightKg', weightKg)
          ..add('birthDate', birthDate)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class PublicUserBuilder implements Builder<PublicUser, PublicUserBuilder> {
  _$PublicUser? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  num? _heightCm;
  num? get heightCm => _$this._heightCm;
  set heightCm(num? heightCm) => _$this._heightCm = heightCm;

  num? _weightKg;
  num? get weightKg => _$this._weightKg;
  set weightKg(num? weightKg) => _$this._weightKg = weightKg;

  DateTime? _birthDate;
  DateTime? get birthDate => _$this._birthDate;
  set birthDate(DateTime? birthDate) => _$this._birthDate = birthDate;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  PublicUserBuilder() {
    PublicUser._defaults(this);
  }

  PublicUserBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _email = $v.email;
      _displayName = $v.displayName;
      _heightCm = $v.heightCm;
      _weightKg = $v.weightKg;
      _birthDate = $v.birthDate;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PublicUser other) {
    _$v = other as _$PublicUser;
  }

  @override
  void update(void Function(PublicUserBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PublicUser build() => _build();

  _$PublicUser _build() {
    final _$result = _$v ??
        _$PublicUser._(
          id: id,
          email: email,
          displayName: displayName,
          heightCm: heightCm,
          weightKg: weightKg,
          birthDate: birthDate,
          createdAt: createdAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
