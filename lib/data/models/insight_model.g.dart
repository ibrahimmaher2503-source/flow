// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insight_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetInsightCollection on Isar {
  IsarCollection<Insight> get insights => this.collection();
}

const InsightSchema = CollectionSchema(
  name: r'Insight',
  id: -5337822884227880275,
  properties: {
    r'actionRoute': PropertySchema(
      id: 0,
      name: r'actionRoute',
      type: IsarType.string,
    ),
    r'colorHex': PropertySchema(
      id: 1,
      name: r'colorHex',
      type: IsarType.string,
    ),
    r'descriptionAr': PropertySchema(
      id: 2,
      name: r'descriptionAr',
      type: IsarType.string,
    ),
    r'dismissedAt': PropertySchema(
      id: 3,
      name: r'dismissedAt',
      type: IsarType.dateTime,
    ),
    r'generatedAt': PropertySchema(
      id: 4,
      name: r'generatedAt',
      type: IsarType.dateTime,
    ),
    r'hash': PropertySchema(
      id: 5,
      name: r'hash',
      type: IsarType.string,
    ),
    r'iconName': PropertySchema(
      id: 6,
      name: r'iconName',
      type: IsarType.string,
    ),
    r'isDismissed': PropertySchema(
      id: 7,
      name: r'isDismissed',
      type: IsarType.bool,
    ),
    r'monthKey': PropertySchema(
      id: 8,
      name: r'monthKey',
      type: IsarType.string,
    ),
    r'priority': PropertySchema(
      id: 9,
      name: r'priority',
      type: IsarType.long,
    ),
    r'titleAr': PropertySchema(
      id: 10,
      name: r'titleAr',
      type: IsarType.string,
    ),
    r'type': PropertySchema(
      id: 11,
      name: r'type',
      type: IsarType.string,
    )
  },
  estimateSize: _insightEstimateSize,
  serialize: _insightSerialize,
  deserialize: _insightDeserialize,
  deserializeProp: _insightDeserializeProp,
  idName: r'id',
  indexes: {
    r'hash': IndexSchema(
      id: -7973251393006690288,
      name: r'hash',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'hash',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'monthKey': IndexSchema(
      id: -6349924167704926890,
      name: r'monthKey',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'monthKey',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _insightGetId,
  getLinks: _insightGetLinks,
  attach: _insightAttach,
  version: '3.1.0+1',
);

int _insightEstimateSize(
  Insight object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.actionRoute;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.colorHex;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.descriptionAr.length * 3;
  bytesCount += 3 + object.hash.length * 3;
  {
    final value = object.iconName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.monthKey.length * 3;
  bytesCount += 3 + object.titleAr.length * 3;
  bytesCount += 3 + object.type.length * 3;
  return bytesCount;
}

void _insightSerialize(
  Insight object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.actionRoute);
  writer.writeString(offsets[1], object.colorHex);
  writer.writeString(offsets[2], object.descriptionAr);
  writer.writeDateTime(offsets[3], object.dismissedAt);
  writer.writeDateTime(offsets[4], object.generatedAt);
  writer.writeString(offsets[5], object.hash);
  writer.writeString(offsets[6], object.iconName);
  writer.writeBool(offsets[7], object.isDismissed);
  writer.writeString(offsets[8], object.monthKey);
  writer.writeLong(offsets[9], object.priority);
  writer.writeString(offsets[10], object.titleAr);
  writer.writeString(offsets[11], object.type);
}

Insight _insightDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Insight();
  object.actionRoute = reader.readStringOrNull(offsets[0]);
  object.colorHex = reader.readStringOrNull(offsets[1]);
  object.descriptionAr = reader.readString(offsets[2]);
  object.dismissedAt = reader.readDateTimeOrNull(offsets[3]);
  object.generatedAt = reader.readDateTime(offsets[4]);
  object.hash = reader.readString(offsets[5]);
  object.iconName = reader.readStringOrNull(offsets[6]);
  object.id = id;
  object.isDismissed = reader.readBool(offsets[7]);
  object.monthKey = reader.readString(offsets[8]);
  object.priority = reader.readLong(offsets[9]);
  object.titleAr = reader.readString(offsets[10]);
  object.type = reader.readString(offsets[11]);
  return object;
}

P _insightDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _insightGetId(Insight object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _insightGetLinks(Insight object) {
  return [];
}

void _insightAttach(IsarCollection<dynamic> col, Id id, Insight object) {
  object.id = id;
}

extension InsightByIndex on IsarCollection<Insight> {
  Future<Insight?> getByHash(String hash) {
    return getByIndex(r'hash', [hash]);
  }

  Insight? getByHashSync(String hash) {
    return getByIndexSync(r'hash', [hash]);
  }

  Future<bool> deleteByHash(String hash) {
    return deleteByIndex(r'hash', [hash]);
  }

  bool deleteByHashSync(String hash) {
    return deleteByIndexSync(r'hash', [hash]);
  }

  Future<List<Insight?>> getAllByHash(List<String> hashValues) {
    final values = hashValues.map((e) => [e]).toList();
    return getAllByIndex(r'hash', values);
  }

  List<Insight?> getAllByHashSync(List<String> hashValues) {
    final values = hashValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'hash', values);
  }

  Future<int> deleteAllByHash(List<String> hashValues) {
    final values = hashValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'hash', values);
  }

  int deleteAllByHashSync(List<String> hashValues) {
    final values = hashValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'hash', values);
  }

  Future<Id> putByHash(Insight object) {
    return putByIndex(r'hash', object);
  }

  Id putByHashSync(Insight object, {bool saveLinks = true}) {
    return putByIndexSync(r'hash', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByHash(List<Insight> objects) {
    return putAllByIndex(r'hash', objects);
  }

  List<Id> putAllByHashSync(List<Insight> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'hash', objects, saveLinks: saveLinks);
  }
}

extension InsightQueryWhereSort on QueryBuilder<Insight, Insight, QWhere> {
  QueryBuilder<Insight, Insight, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension InsightQueryWhere on QueryBuilder<Insight, Insight, QWhereClause> {
  QueryBuilder<Insight, Insight, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Insight, Insight, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Insight, Insight, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Insight, Insight, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterWhereClause> hashEqualTo(String hash) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'hash',
        value: [hash],
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterWhereClause> hashNotEqualTo(
      String hash) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'hash',
              lower: [],
              upper: [hash],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'hash',
              lower: [hash],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'hash',
              lower: [hash],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'hash',
              lower: [],
              upper: [hash],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Insight, Insight, QAfterWhereClause> monthKeyEqualTo(
      String monthKey) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'monthKey',
        value: [monthKey],
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterWhereClause> monthKeyNotEqualTo(
      String monthKey) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'monthKey',
              lower: [],
              upper: [monthKey],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'monthKey',
              lower: [monthKey],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'monthKey',
              lower: [monthKey],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'monthKey',
              lower: [],
              upper: [monthKey],
              includeUpper: false,
            ));
      }
    });
  }
}

extension InsightQueryFilter
    on QueryBuilder<Insight, Insight, QFilterCondition> {
  QueryBuilder<Insight, Insight, QAfterFilterCondition> actionRouteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'actionRoute',
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> actionRouteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'actionRoute',
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> actionRouteEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'actionRoute',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> actionRouteGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'actionRoute',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> actionRouteLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'actionRoute',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> actionRouteBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'actionRoute',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> actionRouteStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'actionRoute',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> actionRouteEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'actionRoute',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> actionRouteContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'actionRoute',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> actionRouteMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'actionRoute',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> actionRouteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'actionRoute',
        value: '',
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition>
      actionRouteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'actionRoute',
        value: '',
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> colorHexIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'colorHex',
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> colorHexIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'colorHex',
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> colorHexEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'colorHex',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> colorHexGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'colorHex',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> colorHexLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'colorHex',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> colorHexBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'colorHex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> colorHexStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'colorHex',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> colorHexEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'colorHex',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> colorHexContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'colorHex',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> colorHexMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'colorHex',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> colorHexIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'colorHex',
        value: '',
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> colorHexIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'colorHex',
        value: '',
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> descriptionArEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'descriptionAr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition>
      descriptionArGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'descriptionAr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> descriptionArLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'descriptionAr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> descriptionArBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'descriptionAr',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> descriptionArStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'descriptionAr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> descriptionArEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'descriptionAr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> descriptionArContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'descriptionAr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> descriptionArMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'descriptionAr',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> descriptionArIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'descriptionAr',
        value: '',
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition>
      descriptionArIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'descriptionAr',
        value: '',
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> dismissedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dismissedAt',
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> dismissedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dismissedAt',
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> dismissedAtEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dismissedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> dismissedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dismissedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> dismissedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dismissedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> dismissedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dismissedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> generatedAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'generatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> generatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'generatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> generatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'generatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> generatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'generatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> hashEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> hashGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> hashLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> hashBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hash',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> hashStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'hash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> hashEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'hash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> hashContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'hash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> hashMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'hash',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> hashIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hash',
        value: '',
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> hashIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'hash',
        value: '',
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> iconNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'iconName',
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> iconNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'iconName',
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> iconNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'iconName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> iconNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'iconName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> iconNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'iconName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> iconNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'iconName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> iconNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'iconName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> iconNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'iconName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> iconNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'iconName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> iconNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'iconName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> iconNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'iconName',
        value: '',
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> iconNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'iconName',
        value: '',
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> isDismissedEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isDismissed',
        value: value,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> monthKeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'monthKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> monthKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'monthKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> monthKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'monthKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> monthKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'monthKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> monthKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'monthKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> monthKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'monthKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> monthKeyContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'monthKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> monthKeyMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'monthKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> monthKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'monthKey',
        value: '',
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> monthKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'monthKey',
        value: '',
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> priorityEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'priority',
        value: value,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> priorityGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'priority',
        value: value,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> priorityLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'priority',
        value: value,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> priorityBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'priority',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> titleArEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'titleAr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> titleArGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'titleAr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> titleArLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'titleAr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> titleArBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'titleAr',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> titleArStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'titleAr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> titleArEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'titleAr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> titleArContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'titleAr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> titleArMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'titleAr',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> titleArIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'titleAr',
        value: '',
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> titleArIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'titleAr',
        value: '',
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> typeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> typeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> typeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> typeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> typeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> typeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> typeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> typeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'type',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<Insight, Insight, QAfterFilterCondition> typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'type',
        value: '',
      ));
    });
  }
}

extension InsightQueryObject
    on QueryBuilder<Insight, Insight, QFilterCondition> {}

extension InsightQueryLinks
    on QueryBuilder<Insight, Insight, QFilterCondition> {}

extension InsightQuerySortBy on QueryBuilder<Insight, Insight, QSortBy> {
  QueryBuilder<Insight, Insight, QAfterSortBy> sortByActionRoute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actionRoute', Sort.asc);
    });
  }

  QueryBuilder<Insight, Insight, QAfterSortBy> sortByActionRouteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actionRoute', Sort.desc);
    });
  }

  QueryBuilder<Insight, Insight, QAfterSortBy> sortByColorHex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorHex', Sort.asc);
    });
  }

  QueryBuilder<Insight, Insight, QAfterSortBy> sortByColorHexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorHex', Sort.desc);
    });
  }

  QueryBuilder<Insight, Insight, QAfterSortBy> sortByDescriptionAr() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'descriptionAr', Sort.asc);
    });
  }

  QueryBuilder<Insight, Insight, QAfterSortBy> sortByDescriptionArDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'descriptionAr', Sort.desc);
    });
  }

  QueryBuilder<Insight, Insight, QAfterSortBy> sortByDismissedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dismissedAt', Sort.asc);
    });
  }

  QueryBuilder<Insight, Insight, QAfterSortBy> sortByDismissedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dismissedAt', Sort.desc);
    });
  }

  QueryBuilder<Insight, Insight, QAfterSortBy> sortByGeneratedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generatedAt', Sort.asc);
    });
  }

  QueryBuilder<Insight, Insight, QAfterSortBy> sortByGeneratedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generatedAt', Sort.desc);
    });
  }

  QueryBuilder<Insight, Insight, QAfterSortBy> sortByHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hash', Sort.asc);
    });
  }

  QueryBuilder<Insight, Insight, QAfterSortBy> sortByHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hash', Sort.desc);
    });
  }

  QueryBuilder<Insight, Insight, QAfterSortBy> sortByIconName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconName', Sort.asc);
    });
  }

  QueryBuilder<Insight, Insight, QAfterSortBy> sortByIconNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconName', Sort.desc);
    });
  }

  QueryBuilder<Insight, Insight, QAfterSortBy> sortByIsDismissed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDismissed', Sort.asc);
    });
  }

  QueryBuilder<Insight, Insight, QAfterSortBy> sortByIsDismissedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDismissed', Sort.desc);
    });
  }

  QueryBuilder<Insight, Insight, QAfterSortBy> sortByMonthKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthKey', Sort.asc);
    });
  }

  QueryBuilder<Insight, Insight, QAfterSortBy> sortByMonthKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthKey', Sort.desc);
    });
  }

  QueryBuilder<Insight, Insight, QAfterSortBy> sortByPriority() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priority', Sort.asc);
    });
  }

  QueryBuilder<Insight, Insight, QAfterSortBy> sortByPriorityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priority', Sort.desc);
    });
  }

  QueryBuilder<Insight, Insight, QAfterSortBy> sortByTitleAr() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titleAr', Sort.asc);
    });
  }

  QueryBuilder<Insight, Insight, QAfterSortBy> sortByTitleArDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titleAr', Sort.desc);
    });
  }

  QueryBuilder<Insight, Insight, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<Insight, Insight, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension InsightQuerySortThenBy
    on QueryBuilder<Insight, Insight, QSortThenBy> {
  QueryBuilder<Insight, Insight, QAfterSortBy> thenByActionRoute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actionRoute', Sort.asc);
    });
  }

  QueryBuilder<Insight, Insight, QAfterSortBy> thenByActionRouteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actionRoute', Sort.desc);
    });
  }

  QueryBuilder<Insight, Insight, QAfterSortBy> thenByColorHex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorHex', Sort.asc);
    });
  }

  QueryBuilder<Insight, Insight, QAfterSortBy> thenByColorHexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorHex', Sort.desc);
    });
  }

  QueryBuilder<Insight, Insight, QAfterSortBy> thenByDescriptionAr() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'descriptionAr', Sort.asc);
    });
  }

  QueryBuilder<Insight, Insight, QAfterSortBy> thenByDescriptionArDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'descriptionAr', Sort.desc);
    });
  }

  QueryBuilder<Insight, Insight, QAfterSortBy> thenByDismissedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dismissedAt', Sort.asc);
    });
  }

  QueryBuilder<Insight, Insight, QAfterSortBy> thenByDismissedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dismissedAt', Sort.desc);
    });
  }

  QueryBuilder<Insight, Insight, QAfterSortBy> thenByGeneratedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generatedAt', Sort.asc);
    });
  }

  QueryBuilder<Insight, Insight, QAfterSortBy> thenByGeneratedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generatedAt', Sort.desc);
    });
  }

  QueryBuilder<Insight, Insight, QAfterSortBy> thenByHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hash', Sort.asc);
    });
  }

  QueryBuilder<Insight, Insight, QAfterSortBy> thenByHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hash', Sort.desc);
    });
  }

  QueryBuilder<Insight, Insight, QAfterSortBy> thenByIconName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconName', Sort.asc);
    });
  }

  QueryBuilder<Insight, Insight, QAfterSortBy> thenByIconNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconName', Sort.desc);
    });
  }

  QueryBuilder<Insight, Insight, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Insight, Insight, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Insight, Insight, QAfterSortBy> thenByIsDismissed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDismissed', Sort.asc);
    });
  }

  QueryBuilder<Insight, Insight, QAfterSortBy> thenByIsDismissedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDismissed', Sort.desc);
    });
  }

  QueryBuilder<Insight, Insight, QAfterSortBy> thenByMonthKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthKey', Sort.asc);
    });
  }

  QueryBuilder<Insight, Insight, QAfterSortBy> thenByMonthKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthKey', Sort.desc);
    });
  }

  QueryBuilder<Insight, Insight, QAfterSortBy> thenByPriority() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priority', Sort.asc);
    });
  }

  QueryBuilder<Insight, Insight, QAfterSortBy> thenByPriorityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priority', Sort.desc);
    });
  }

  QueryBuilder<Insight, Insight, QAfterSortBy> thenByTitleAr() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titleAr', Sort.asc);
    });
  }

  QueryBuilder<Insight, Insight, QAfterSortBy> thenByTitleArDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titleAr', Sort.desc);
    });
  }

  QueryBuilder<Insight, Insight, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<Insight, Insight, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension InsightQueryWhereDistinct
    on QueryBuilder<Insight, Insight, QDistinct> {
  QueryBuilder<Insight, Insight, QDistinct> distinctByActionRoute(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'actionRoute', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Insight, Insight, QDistinct> distinctByColorHex(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'colorHex', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Insight, Insight, QDistinct> distinctByDescriptionAr(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'descriptionAr',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Insight, Insight, QDistinct> distinctByDismissedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dismissedAt');
    });
  }

  QueryBuilder<Insight, Insight, QDistinct> distinctByGeneratedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'generatedAt');
    });
  }

  QueryBuilder<Insight, Insight, QDistinct> distinctByHash(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hash', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Insight, Insight, QDistinct> distinctByIconName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'iconName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Insight, Insight, QDistinct> distinctByIsDismissed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isDismissed');
    });
  }

  QueryBuilder<Insight, Insight, QDistinct> distinctByMonthKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'monthKey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Insight, Insight, QDistinct> distinctByPriority() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'priority');
    });
  }

  QueryBuilder<Insight, Insight, QDistinct> distinctByTitleAr(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'titleAr', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Insight, Insight, QDistinct> distinctByType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type', caseSensitive: caseSensitive);
    });
  }
}

extension InsightQueryProperty
    on QueryBuilder<Insight, Insight, QQueryProperty> {
  QueryBuilder<Insight, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Insight, String?, QQueryOperations> actionRouteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'actionRoute');
    });
  }

  QueryBuilder<Insight, String?, QQueryOperations> colorHexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'colorHex');
    });
  }

  QueryBuilder<Insight, String, QQueryOperations> descriptionArProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'descriptionAr');
    });
  }

  QueryBuilder<Insight, DateTime?, QQueryOperations> dismissedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dismissedAt');
    });
  }

  QueryBuilder<Insight, DateTime, QQueryOperations> generatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'generatedAt');
    });
  }

  QueryBuilder<Insight, String, QQueryOperations> hashProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hash');
    });
  }

  QueryBuilder<Insight, String?, QQueryOperations> iconNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'iconName');
    });
  }

  QueryBuilder<Insight, bool, QQueryOperations> isDismissedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isDismissed');
    });
  }

  QueryBuilder<Insight, String, QQueryOperations> monthKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'monthKey');
    });
  }

  QueryBuilder<Insight, int, QQueryOperations> priorityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'priority');
    });
  }

  QueryBuilder<Insight, String, QQueryOperations> titleArProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'titleAr');
    });
  }

  QueryBuilder<Insight, String, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }
}
