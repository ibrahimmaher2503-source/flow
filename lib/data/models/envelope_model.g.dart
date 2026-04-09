// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'envelope_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetEnvelopeCollection on Isar {
  IsarCollection<Envelope> get envelopes => this.collection();
}

const EnvelopeSchema = CollectionSchema(
  name: r'Envelope',
  id: 1961730508026666265,
  properties: {
    r'allocatedAmount': PropertySchema(
      id: 0,
      name: r'allocatedAmount',
      type: IsarType.double,
    ),
    r'categoryName': PropertySchema(
      id: 1,
      name: r'categoryName',
      type: IsarType.string,
    ),
    r'colorHex': PropertySchema(
      id: 2,
      name: r'colorHex',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 3,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'iconName': PropertySchema(
      id: 4,
      name: r'iconName',
      type: IsarType.string,
    ),
    r'isEssential': PropertySchema(
      id: 5,
      name: r'isEssential',
      type: IsarType.bool,
    ),
    r'month': PropertySchema(
      id: 6,
      name: r'month',
      type: IsarType.long,
    ),
    r'monthKey': PropertySchema(
      id: 7,
      name: r'monthKey',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 8,
      name: r'name',
      type: IsarType.string,
    ),
    r'rolloverEnabled': PropertySchema(
      id: 9,
      name: r'rolloverEnabled',
      type: IsarType.bool,
    ),
    r'sortOrder': PropertySchema(
      id: 10,
      name: r'sortOrder',
      type: IsarType.long,
    ),
    r'year': PropertySchema(
      id: 11,
      name: r'year',
      type: IsarType.long,
    )
  },
  estimateSize: _envelopeEstimateSize,
  serialize: _envelopeSerialize,
  deserialize: _envelopeDeserialize,
  deserializeProp: _envelopeDeserializeProp,
  idName: r'id',
  indexes: {
    r'year_month': IndexSchema(
      id: -3509244304425196138,
      name: r'year_month',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'year',
          type: IndexType.value,
          caseSensitive: false,
        ),
        IndexPropertySchema(
          name: r'month',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _envelopeGetId,
  getLinks: _envelopeGetLinks,
  attach: _envelopeAttach,
  version: '3.1.0+1',
);

int _envelopeEstimateSize(
  Envelope object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.categoryName.length * 3;
  bytesCount += 3 + object.colorHex.length * 3;
  bytesCount += 3 + object.iconName.length * 3;
  bytesCount += 3 + object.monthKey.length * 3;
  bytesCount += 3 + object.name.length * 3;
  return bytesCount;
}

void _envelopeSerialize(
  Envelope object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.allocatedAmount);
  writer.writeString(offsets[1], object.categoryName);
  writer.writeString(offsets[2], object.colorHex);
  writer.writeDateTime(offsets[3], object.createdAt);
  writer.writeString(offsets[4], object.iconName);
  writer.writeBool(offsets[5], object.isEssential);
  writer.writeLong(offsets[6], object.month);
  writer.writeString(offsets[7], object.monthKey);
  writer.writeString(offsets[8], object.name);
  writer.writeBool(offsets[9], object.rolloverEnabled);
  writer.writeLong(offsets[10], object.sortOrder);
  writer.writeLong(offsets[11], object.year);
}

Envelope _envelopeDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Envelope();
  object.allocatedAmount = reader.readDouble(offsets[0]);
  object.categoryName = reader.readString(offsets[1]);
  object.colorHex = reader.readString(offsets[2]);
  object.createdAt = reader.readDateTime(offsets[3]);
  object.iconName = reader.readString(offsets[4]);
  object.id = id;
  object.isEssential = reader.readBool(offsets[5]);
  object.month = reader.readLong(offsets[6]);
  object.name = reader.readString(offsets[8]);
  object.rolloverEnabled = reader.readBool(offsets[9]);
  object.sortOrder = reader.readLong(offsets[10]);
  object.year = reader.readLong(offsets[11]);
  return object;
}

P _envelopeDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readBool(offset)) as P;
    case 10:
      return (reader.readLong(offset)) as P;
    case 11:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _envelopeGetId(Envelope object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _envelopeGetLinks(Envelope object) {
  return [];
}

void _envelopeAttach(IsarCollection<dynamic> col, Id id, Envelope object) {
  object.id = id;
}

extension EnvelopeQueryWhereSort on QueryBuilder<Envelope, Envelope, QWhere> {
  QueryBuilder<Envelope, Envelope, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterWhere> anyYearMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'year_month'),
      );
    });
  }
}

extension EnvelopeQueryWhere on QueryBuilder<Envelope, Envelope, QWhereClause> {
  QueryBuilder<Envelope, Envelope, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Envelope, Envelope, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterWhereClause> idBetween(
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

  QueryBuilder<Envelope, Envelope, QAfterWhereClause> yearEqualToAnyMonth(
      int year) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'year_month',
        value: [year],
      ));
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterWhereClause> yearNotEqualToAnyMonth(
      int year) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'year_month',
              lower: [],
              upper: [year],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'year_month',
              lower: [year],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'year_month',
              lower: [year],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'year_month',
              lower: [],
              upper: [year],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterWhereClause> yearGreaterThanAnyMonth(
    int year, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'year_month',
        lower: [year],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterWhereClause> yearLessThanAnyMonth(
    int year, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'year_month',
        lower: [],
        upper: [year],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterWhereClause> yearBetweenAnyMonth(
    int lowerYear,
    int upperYear, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'year_month',
        lower: [lowerYear],
        includeLower: includeLower,
        upper: [upperYear],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterWhereClause> yearMonthEqualTo(
      int year, int month) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'year_month',
        value: [year, month],
      ));
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterWhereClause>
      yearEqualToMonthNotEqualTo(int year, int month) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'year_month',
              lower: [year],
              upper: [year, month],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'year_month',
              lower: [year, month],
              includeLower: false,
              upper: [year],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'year_month',
              lower: [year, month],
              includeLower: false,
              upper: [year],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'year_month',
              lower: [year],
              upper: [year, month],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterWhereClause>
      yearEqualToMonthGreaterThan(
    int year,
    int month, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'year_month',
        lower: [year, month],
        includeLower: include,
        upper: [year],
      ));
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterWhereClause> yearEqualToMonthLessThan(
    int year,
    int month, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'year_month',
        lower: [year],
        upper: [year, month],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterWhereClause> yearEqualToMonthBetween(
    int year,
    int lowerMonth,
    int upperMonth, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'year_month',
        lower: [year, lowerMonth],
        includeLower: includeLower,
        upper: [year, upperMonth],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension EnvelopeQueryFilter
    on QueryBuilder<Envelope, Envelope, QFilterCondition> {
  QueryBuilder<Envelope, Envelope, QAfterFilterCondition>
      allocatedAmountEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'allocatedAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition>
      allocatedAmountGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'allocatedAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition>
      allocatedAmountLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'allocatedAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition>
      allocatedAmountBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'allocatedAmount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition> categoryNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'categoryName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition>
      categoryNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'categoryName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition> categoryNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'categoryName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition> categoryNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'categoryName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition>
      categoryNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'categoryName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition> categoryNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'categoryName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition> categoryNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'categoryName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition> categoryNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'categoryName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition>
      categoryNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'categoryName',
        value: '',
      ));
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition>
      categoryNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'categoryName',
        value: '',
      ));
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition> colorHexEqualTo(
    String value, {
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

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition> colorHexGreaterThan(
    String value, {
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

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition> colorHexLessThan(
    String value, {
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

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition> colorHexBetween(
    String lower,
    String upper, {
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

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition> colorHexStartsWith(
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

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition> colorHexEndsWith(
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

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition> colorHexContains(
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

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition> colorHexMatches(
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

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition> colorHexIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'colorHex',
        value: '',
      ));
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition> colorHexIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'colorHex',
        value: '',
      ));
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition> createdAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition> createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition> iconNameEqualTo(
    String value, {
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

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition> iconNameGreaterThan(
    String value, {
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

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition> iconNameLessThan(
    String value, {
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

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition> iconNameBetween(
    String lower,
    String upper, {
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

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition> iconNameStartsWith(
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

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition> iconNameEndsWith(
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

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition> iconNameContains(
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

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition> iconNameMatches(
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

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition> iconNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'iconName',
        value: '',
      ));
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition> iconNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'iconName',
        value: '',
      ));
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition> isEssentialEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isEssential',
        value: value,
      ));
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition> monthEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'month',
        value: value,
      ));
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition> monthGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'month',
        value: value,
      ));
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition> monthLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'month',
        value: value,
      ));
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition> monthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'month',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition> monthKeyEqualTo(
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

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition> monthKeyGreaterThan(
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

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition> monthKeyLessThan(
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

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition> monthKeyBetween(
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

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition> monthKeyStartsWith(
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

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition> monthKeyEndsWith(
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

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition> monthKeyContains(
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

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition> monthKeyMatches(
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

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition> monthKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'monthKey',
        value: '',
      ));
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition> monthKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'monthKey',
        value: '',
      ));
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition>
      rolloverEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rolloverEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition> sortOrderEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sortOrder',
        value: value,
      ));
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition> sortOrderGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sortOrder',
        value: value,
      ));
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition> sortOrderLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sortOrder',
        value: value,
      ));
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition> sortOrderBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sortOrder',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition> yearEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'year',
        value: value,
      ));
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition> yearGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'year',
        value: value,
      ));
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition> yearLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'year',
        value: value,
      ));
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterFilterCondition> yearBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'year',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension EnvelopeQueryObject
    on QueryBuilder<Envelope, Envelope, QFilterCondition> {}

extension EnvelopeQueryLinks
    on QueryBuilder<Envelope, Envelope, QFilterCondition> {}

extension EnvelopeQuerySortBy on QueryBuilder<Envelope, Envelope, QSortBy> {
  QueryBuilder<Envelope, Envelope, QAfterSortBy> sortByAllocatedAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'allocatedAmount', Sort.asc);
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterSortBy> sortByAllocatedAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'allocatedAmount', Sort.desc);
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterSortBy> sortByCategoryName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryName', Sort.asc);
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterSortBy> sortByCategoryNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryName', Sort.desc);
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterSortBy> sortByColorHex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorHex', Sort.asc);
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterSortBy> sortByColorHexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorHex', Sort.desc);
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterSortBy> sortByIconName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconName', Sort.asc);
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterSortBy> sortByIconNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconName', Sort.desc);
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterSortBy> sortByIsEssential() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isEssential', Sort.asc);
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterSortBy> sortByIsEssentialDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isEssential', Sort.desc);
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterSortBy> sortByMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'month', Sort.asc);
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterSortBy> sortByMonthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'month', Sort.desc);
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterSortBy> sortByMonthKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthKey', Sort.asc);
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterSortBy> sortByMonthKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthKey', Sort.desc);
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterSortBy> sortByRolloverEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rolloverEnabled', Sort.asc);
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterSortBy> sortByRolloverEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rolloverEnabled', Sort.desc);
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterSortBy> sortBySortOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sortOrder', Sort.asc);
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterSortBy> sortBySortOrderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sortOrder', Sort.desc);
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterSortBy> sortByYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.asc);
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterSortBy> sortByYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.desc);
    });
  }
}

extension EnvelopeQuerySortThenBy
    on QueryBuilder<Envelope, Envelope, QSortThenBy> {
  QueryBuilder<Envelope, Envelope, QAfterSortBy> thenByAllocatedAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'allocatedAmount', Sort.asc);
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterSortBy> thenByAllocatedAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'allocatedAmount', Sort.desc);
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterSortBy> thenByCategoryName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryName', Sort.asc);
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterSortBy> thenByCategoryNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryName', Sort.desc);
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterSortBy> thenByColorHex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorHex', Sort.asc);
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterSortBy> thenByColorHexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorHex', Sort.desc);
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterSortBy> thenByIconName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconName', Sort.asc);
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterSortBy> thenByIconNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconName', Sort.desc);
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterSortBy> thenByIsEssential() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isEssential', Sort.asc);
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterSortBy> thenByIsEssentialDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isEssential', Sort.desc);
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterSortBy> thenByMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'month', Sort.asc);
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterSortBy> thenByMonthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'month', Sort.desc);
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterSortBy> thenByMonthKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthKey', Sort.asc);
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterSortBy> thenByMonthKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthKey', Sort.desc);
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterSortBy> thenByRolloverEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rolloverEnabled', Sort.asc);
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterSortBy> thenByRolloverEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rolloverEnabled', Sort.desc);
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterSortBy> thenBySortOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sortOrder', Sort.asc);
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterSortBy> thenBySortOrderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sortOrder', Sort.desc);
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterSortBy> thenByYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.asc);
    });
  }

  QueryBuilder<Envelope, Envelope, QAfterSortBy> thenByYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.desc);
    });
  }
}

extension EnvelopeQueryWhereDistinct
    on QueryBuilder<Envelope, Envelope, QDistinct> {
  QueryBuilder<Envelope, Envelope, QDistinct> distinctByAllocatedAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'allocatedAmount');
    });
  }

  QueryBuilder<Envelope, Envelope, QDistinct> distinctByCategoryName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'categoryName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Envelope, Envelope, QDistinct> distinctByColorHex(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'colorHex', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Envelope, Envelope, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<Envelope, Envelope, QDistinct> distinctByIconName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'iconName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Envelope, Envelope, QDistinct> distinctByIsEssential() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isEssential');
    });
  }

  QueryBuilder<Envelope, Envelope, QDistinct> distinctByMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'month');
    });
  }

  QueryBuilder<Envelope, Envelope, QDistinct> distinctByMonthKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'monthKey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Envelope, Envelope, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Envelope, Envelope, QDistinct> distinctByRolloverEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rolloverEnabled');
    });
  }

  QueryBuilder<Envelope, Envelope, QDistinct> distinctBySortOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sortOrder');
    });
  }

  QueryBuilder<Envelope, Envelope, QDistinct> distinctByYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'year');
    });
  }
}

extension EnvelopeQueryProperty
    on QueryBuilder<Envelope, Envelope, QQueryProperty> {
  QueryBuilder<Envelope, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Envelope, double, QQueryOperations> allocatedAmountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'allocatedAmount');
    });
  }

  QueryBuilder<Envelope, String, QQueryOperations> categoryNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'categoryName');
    });
  }

  QueryBuilder<Envelope, String, QQueryOperations> colorHexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'colorHex');
    });
  }

  QueryBuilder<Envelope, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<Envelope, String, QQueryOperations> iconNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'iconName');
    });
  }

  QueryBuilder<Envelope, bool, QQueryOperations> isEssentialProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isEssential');
    });
  }

  QueryBuilder<Envelope, int, QQueryOperations> monthProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'month');
    });
  }

  QueryBuilder<Envelope, String, QQueryOperations> monthKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'monthKey');
    });
  }

  QueryBuilder<Envelope, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<Envelope, bool, QQueryOperations> rolloverEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rolloverEnabled');
    });
  }

  QueryBuilder<Envelope, int, QQueryOperations> sortOrderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sortOrder');
    });
  }

  QueryBuilder<Envelope, int, QQueryOperations> yearProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'year');
    });
  }
}
