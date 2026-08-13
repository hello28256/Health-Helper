// @dart=2.19


// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Food extends Food {
  @override
  final int? id;
  @override
  final String? name;
  @override
  final String? nameZh;
  @override
  final String? category;
  @override
  final num? servingSizeG;
  @override
  final num? kcalPer100g;
  @override
  final num? proteinG;
  @override
  final num? fatG;
  @override
  final num? carbsG;
  @override
  final num? fiberG;
  @override
  final num? sodiumMg;

  factory _$Food([void Function(FoodBuilder)? updates]) =>
      (FoodBuilder()..update(updates))._build();

  _$Food._(
      {this.id,
      this.name,
      this.nameZh,
      this.category,
      this.servingSizeG,
      this.kcalPer100g,
      this.proteinG,
      this.fatG,
      this.carbsG,
      this.fiberG,
      this.sodiumMg})
      : super._();
  @override
  Food rebuild(void Function(FoodBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FoodBuilder toBuilder() => FoodBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Food &&
        id == other.id &&
        name == other.name &&
        nameZh == other.nameZh &&
        category == other.category &&
        servingSizeG == other.servingSizeG &&
        kcalPer100g == other.kcalPer100g &&
        proteinG == other.proteinG &&
        fatG == other.fatG &&
        carbsG == other.carbsG &&
        fiberG == other.fiberG &&
        sodiumMg == other.sodiumMg;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, nameZh.hashCode);
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, servingSizeG.hashCode);
    _$hash = $jc(_$hash, kcalPer100g.hashCode);
    _$hash = $jc(_$hash, proteinG.hashCode);
    _$hash = $jc(_$hash, fatG.hashCode);
    _$hash = $jc(_$hash, carbsG.hashCode);
    _$hash = $jc(_$hash, fiberG.hashCode);
    _$hash = $jc(_$hash, sodiumMg.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Food')
          ..add('id', id)
          ..add('name', name)
          ..add('nameZh', nameZh)
          ..add('category', category)
          ..add('servingSizeG', servingSizeG)
          ..add('kcalPer100g', kcalPer100g)
          ..add('proteinG', proteinG)
          ..add('fatG', fatG)
          ..add('carbsG', carbsG)
          ..add('fiberG', fiberG)
          ..add('sodiumMg', sodiumMg))
        .toString();
  }
}

class FoodBuilder implements Builder<Food, FoodBuilder> {
  _$Food? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _nameZh;
  String? get nameZh => _$this._nameZh;
  set nameZh(String? nameZh) => _$this._nameZh = nameZh;

  String? _category;
  String? get category => _$this._category;
  set category(String? category) => _$this._category = category;

  num? _servingSizeG;
  num? get servingSizeG => _$this._servingSizeG;
  set servingSizeG(num? servingSizeG) => _$this._servingSizeG = servingSizeG;

  num? _kcalPer100g;
  num? get kcalPer100g => _$this._kcalPer100g;
  set kcalPer100g(num? kcalPer100g) => _$this._kcalPer100g = kcalPer100g;

  num? _proteinG;
  num? get proteinG => _$this._proteinG;
  set proteinG(num? proteinG) => _$this._proteinG = proteinG;

  num? _fatG;
  num? get fatG => _$this._fatG;
  set fatG(num? fatG) => _$this._fatG = fatG;

  num? _carbsG;
  num? get carbsG => _$this._carbsG;
  set carbsG(num? carbsG) => _$this._carbsG = carbsG;

  num? _fiberG;
  num? get fiberG => _$this._fiberG;
  set fiberG(num? fiberG) => _$this._fiberG = fiberG;

  num? _sodiumMg;
  num? get sodiumMg => _$this._sodiumMg;
  set sodiumMg(num? sodiumMg) => _$this._sodiumMg = sodiumMg;

  FoodBuilder() {
    Food._defaults(this);
  }

  FoodBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _nameZh = $v.nameZh;
      _category = $v.category;
      _servingSizeG = $v.servingSizeG;
      _kcalPer100g = $v.kcalPer100g;
      _proteinG = $v.proteinG;
      _fatG = $v.fatG;
      _carbsG = $v.carbsG;
      _fiberG = $v.fiberG;
      _sodiumMg = $v.sodiumMg;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Food other) {
    _$v = other as _$Food;
  }

  @override
  void update(void Function(FoodBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Food build() => _build();

  _$Food _build() {
    final _$result = _$v ??
        _$Food._(
          id: id,
          name: name,
          nameZh: nameZh,
          category: category,
          servingSizeG: servingSizeG,
          kcalPer100g: kcalPer100g,
          proteinG: proteinG,
          fatG: fatG,
          carbsG: carbsG,
          fiberG: fiberG,
          sodiumMg: sodiumMg,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
