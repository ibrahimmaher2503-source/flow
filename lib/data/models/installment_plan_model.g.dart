// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'installment_plan_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetInstallmentPlanCollection on Isar {
  IsarCollection<InstallmentPlan> get installmentPlans => this.collection();
}

const InstallmentPlanSchema = CollectionSchema(
  name: r'InstallmentPlan',
  id: 1919034546922502101,
  properties: {
    r'autoAdd': PropertySchema(
      id: 0,
      name: r'autoAdd',
      type: IsarType.bool,
    ),
    r'category': PropertySchema(
      id: 1,
      name: r'category',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 2,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'dayOfMonth': PropertySchema(
      id: 3,
      name: r'dayOfMonth',
      type: IsarType.long,
    ),
    r'firstPaymentDate': PropertySchema(
      id: 4,
      name: r'firstPaymentDate',
      type: IsarType.dateTime,
    ),
    r'itemName': PropertySchema(
      id: 5,
      name: r'itemName',
      type: IsarType.string,
    ),
    r'monthlyAmount': PropertySchema(
      id: 6,
      name: r'monthlyAmount',
      type: IsarType.double,
    ),
    r'originalPrice': PropertySchema(
      id: 7,
      name: r'originalPrice',
      type: IsarType.double,
    ),
    r'paidAmount': PropertySchema(
      id: 8,
      name: r'paidAmount',
      type: IsarType.double,
    ),
    r'paidInstallments': PropertySchema(
      id: 9,
      name: r'paidInstallments',
      type: IsarType.long,
    ),
    r'providerId': PropertySchema(
      id: 10,
      name: r'providerId',
      type: IsarType.long,
    ),
    r'providerIndex': PropertySchema(
      id: 11,
      name: r'providerIndex',
      type: IsarType.long,
    ),
    r'status': PropertySchema(
      id: 12,
      name: r'status',
      type: IsarType.string,
    ),
    r'statusIndex': PropertySchema(
      id: 13,
      name: r'statusIndex',
      type: IsarType.string,
    ),
    r'totalInstallments': PropertySchema(
      id: 14,
      name: r'totalInstallments',
      type: IsarType.long,
    ),
    r'totalWithInterest': PropertySchema(
      id: 15,
      name: r'totalWithInterest',
      type: IsarType.double,
    ),
    r'walletId': PropertySchema(
      id: 16,
      name: r'walletId',
      type: IsarType.long,
    )
  },
  estimateSize: _installmentPlanEstimateSize,
  serialize: _installmentPlanSerialize,
  deserialize: _installmentPlanDeserialize,
  deserializeProp: _installmentPlanDeserializeProp,
  idName: r'id',
  indexes: {
    r'statusIndex': IndexSchema(
      id: -3068638669929638322,
      name: r'statusIndex',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'statusIndex',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'providerIndex': IndexSchema(
      id: 3098101074204618879,
      name: r'providerIndex',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'providerIndex',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _installmentPlanGetId,
  getLinks: _installmentPlanGetLinks,
  attach: _installmentPlanAttach,
  version: '3.1.0+1',
);

int _installmentPlanEstimateSize(
  InstallmentPlan object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.category.length * 3;
  bytesCount += 3 + object.itemName.length * 3;
  bytesCount += 3 + object.status.length * 3;
  bytesCount += 3 + object.statusIndex.length * 3;
  return bytesCount;
}

void _installmentPlanSerialize(
  InstallmentPlan object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.autoAdd);
  writer.writeString(offsets[1], object.category);
  writer.writeDateTime(offsets[2], object.createdAt);
  writer.writeLong(offsets[3], object.dayOfMonth);
  writer.writeDateTime(offsets[4], object.firstPaymentDate);
  writer.writeString(offsets[5], object.itemName);
  writer.writeDouble(offsets[6], object.monthlyAmount);
  writer.writeDouble(offsets[7], object.originalPrice);
  writer.writeDouble(offsets[8], object.paidAmount);
  writer.writeLong(offsets[9], object.paidInstallments);
  writer.writeLong(offsets[10], object.providerId);
  writer.writeLong(offsets[11], object.providerIndex);
  writer.writeString(offsets[12], object.status);
  writer.writeString(offsets[13], object.statusIndex);
  writer.writeLong(offsets[14], object.totalInstallments);
  writer.writeDouble(offsets[15], object.totalWithInterest);
  writer.writeLong(offsets[16], object.walletId);
}

InstallmentPlan _installmentPlanDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = InstallmentPlan();
  object.autoAdd = reader.readBool(offsets[0]);
  object.category = reader.readString(offsets[1]);
  object.createdAt = reader.readDateTime(offsets[2]);
  object.dayOfMonth = reader.readLong(offsets[3]);
  object.firstPaymentDate = reader.readDateTime(offsets[4]);
  object.id = id;
  object.itemName = reader.readString(offsets[5]);
  object.monthlyAmount = reader.readDouble(offsets[6]);
  object.originalPrice = reader.readDouble(offsets[7]);
  object.paidAmount = reader.readDouble(offsets[8]);
  object.paidInstallments = reader.readLong(offsets[9]);
  object.providerId = reader.readLong(offsets[10]);
  object.status = reader.readString(offsets[12]);
  object.totalInstallments = reader.readLong(offsets[14]);
  object.totalWithInterest = reader.readDouble(offsets[15]);
  object.walletId = reader.readLong(offsets[16]);
  return object;
}

P _installmentPlanDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readDouble(offset)) as P;
    case 7:
      return (reader.readDouble(offset)) as P;
    case 8:
      return (reader.readDouble(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readLong(offset)) as P;
    case 11:
      return (reader.readLong(offset)) as P;
    case 12:
      return (reader.readString(offset)) as P;
    case 13:
      return (reader.readString(offset)) as P;
    case 14:
      return (reader.readLong(offset)) as P;
    case 15:
      return (reader.readDouble(offset)) as P;
    case 16:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _installmentPlanGetId(InstallmentPlan object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _installmentPlanGetLinks(InstallmentPlan object) {
  return [];
}

void _installmentPlanAttach(
    IsarCollection<dynamic> col, Id id, InstallmentPlan object) {
  object.id = id;
}

extension InstallmentPlanQueryWhereSort
    on QueryBuilder<InstallmentPlan, InstallmentPlan, QWhere> {
  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterWhere>
      anyProviderIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'providerIndex'),
      );
    });
  }
}

extension InstallmentPlanQueryWhere
    on QueryBuilder<InstallmentPlan, InstallmentPlan, QWhereClause> {
  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterWhereClause> idBetween(
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

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterWhereClause>
      statusIndexEqualTo(String statusIndex) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'statusIndex',
        value: [statusIndex],
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterWhereClause>
      statusIndexNotEqualTo(String statusIndex) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'statusIndex',
              lower: [],
              upper: [statusIndex],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'statusIndex',
              lower: [statusIndex],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'statusIndex',
              lower: [statusIndex],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'statusIndex',
              lower: [],
              upper: [statusIndex],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterWhereClause>
      providerIndexEqualTo(int providerIndex) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'providerIndex',
        value: [providerIndex],
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterWhereClause>
      providerIndexNotEqualTo(int providerIndex) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'providerIndex',
              lower: [],
              upper: [providerIndex],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'providerIndex',
              lower: [providerIndex],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'providerIndex',
              lower: [providerIndex],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'providerIndex',
              lower: [],
              upper: [providerIndex],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterWhereClause>
      providerIndexGreaterThan(
    int providerIndex, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'providerIndex',
        lower: [providerIndex],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterWhereClause>
      providerIndexLessThan(
    int providerIndex, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'providerIndex',
        lower: [],
        upper: [providerIndex],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterWhereClause>
      providerIndexBetween(
    int lowerProviderIndex,
    int upperProviderIndex, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'providerIndex',
        lower: [lowerProviderIndex],
        includeLower: includeLower,
        upper: [upperProviderIndex],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension InstallmentPlanQueryFilter
    on QueryBuilder<InstallmentPlan, InstallmentPlan, QFilterCondition> {
  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      autoAddEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'autoAdd',
        value: value,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      categoryEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      categoryGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      categoryLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      categoryBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'category',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      categoryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      categoryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      categoryContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      categoryMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'category',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      categoryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'category',
        value: '',
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      categoryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'category',
        value: '',
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      createdAtGreaterThan(
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

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      createdAtLessThan(
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

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      createdAtBetween(
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

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      dayOfMonthEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dayOfMonth',
        value: value,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      dayOfMonthGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dayOfMonth',
        value: value,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      dayOfMonthLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dayOfMonth',
        value: value,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      dayOfMonthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dayOfMonth',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      firstPaymentDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'firstPaymentDate',
        value: value,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      firstPaymentDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'firstPaymentDate',
        value: value,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      firstPaymentDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'firstPaymentDate',
        value: value,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      firstPaymentDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'firstPaymentDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      itemNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'itemName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      itemNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'itemName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      itemNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'itemName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      itemNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'itemName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      itemNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'itemName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      itemNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'itemName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      itemNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'itemName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      itemNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'itemName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      itemNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'itemName',
        value: '',
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      itemNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'itemName',
        value: '',
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      monthlyAmountEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'monthlyAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      monthlyAmountGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'monthlyAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      monthlyAmountLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'monthlyAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      monthlyAmountBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'monthlyAmount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      originalPriceEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'originalPrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      originalPriceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'originalPrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      originalPriceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'originalPrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      originalPriceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'originalPrice',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      paidAmountEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'paidAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      paidAmountGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'paidAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      paidAmountLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'paidAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      paidAmountBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'paidAmount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      paidInstallmentsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'paidInstallments',
        value: value,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      paidInstallmentsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'paidInstallments',
        value: value,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      paidInstallmentsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'paidInstallments',
        value: value,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      paidInstallmentsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'paidInstallments',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      providerIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'providerId',
        value: value,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      providerIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'providerId',
        value: value,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      providerIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'providerId',
        value: value,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      providerIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'providerId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      providerIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'providerIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      providerIndexGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'providerIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      providerIndexLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'providerIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      providerIndexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'providerIndex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      statusEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      statusGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      statusLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      statusBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      statusStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      statusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      statusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      statusMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'status',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      statusIndexEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'statusIndex',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      statusIndexGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'statusIndex',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      statusIndexLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'statusIndex',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      statusIndexBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'statusIndex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      statusIndexStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'statusIndex',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      statusIndexEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'statusIndex',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      statusIndexContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'statusIndex',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      statusIndexMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'statusIndex',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      statusIndexIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'statusIndex',
        value: '',
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      statusIndexIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'statusIndex',
        value: '',
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      totalInstallmentsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalInstallments',
        value: value,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      totalInstallmentsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalInstallments',
        value: value,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      totalInstallmentsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalInstallments',
        value: value,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      totalInstallmentsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalInstallments',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      totalWithInterestEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalWithInterest',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      totalWithInterestGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalWithInterest',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      totalWithInterestLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalWithInterest',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      totalWithInterestBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalWithInterest',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      walletIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'walletId',
        value: value,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      walletIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'walletId',
        value: value,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      walletIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'walletId',
        value: value,
      ));
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterFilterCondition>
      walletIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'walletId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension InstallmentPlanQueryObject
    on QueryBuilder<InstallmentPlan, InstallmentPlan, QFilterCondition> {}

extension InstallmentPlanQueryLinks
    on QueryBuilder<InstallmentPlan, InstallmentPlan, QFilterCondition> {}

extension InstallmentPlanQuerySortBy
    on QueryBuilder<InstallmentPlan, InstallmentPlan, QSortBy> {
  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy> sortByAutoAdd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoAdd', Sort.asc);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy>
      sortByAutoAddDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoAdd', Sort.desc);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy>
      sortByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy>
      sortByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy>
      sortByDayOfMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayOfMonth', Sort.asc);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy>
      sortByDayOfMonthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayOfMonth', Sort.desc);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy>
      sortByFirstPaymentDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstPaymentDate', Sort.asc);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy>
      sortByFirstPaymentDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstPaymentDate', Sort.desc);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy>
      sortByItemName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemName', Sort.asc);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy>
      sortByItemNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemName', Sort.desc);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy>
      sortByMonthlyAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyAmount', Sort.asc);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy>
      sortByMonthlyAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyAmount', Sort.desc);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy>
      sortByOriginalPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalPrice', Sort.asc);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy>
      sortByOriginalPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalPrice', Sort.desc);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy>
      sortByPaidAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paidAmount', Sort.asc);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy>
      sortByPaidAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paidAmount', Sort.desc);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy>
      sortByPaidInstallments() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paidInstallments', Sort.asc);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy>
      sortByPaidInstallmentsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paidInstallments', Sort.desc);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy>
      sortByProviderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'providerId', Sort.asc);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy>
      sortByProviderIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'providerId', Sort.desc);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy>
      sortByProviderIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'providerIndex', Sort.asc);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy>
      sortByProviderIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'providerIndex', Sort.desc);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy>
      sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy>
      sortByStatusIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statusIndex', Sort.asc);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy>
      sortByStatusIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statusIndex', Sort.desc);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy>
      sortByTotalInstallments() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalInstallments', Sort.asc);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy>
      sortByTotalInstallmentsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalInstallments', Sort.desc);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy>
      sortByTotalWithInterest() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalWithInterest', Sort.asc);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy>
      sortByTotalWithInterestDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalWithInterest', Sort.desc);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy>
      sortByWalletId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'walletId', Sort.asc);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy>
      sortByWalletIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'walletId', Sort.desc);
    });
  }
}

extension InstallmentPlanQuerySortThenBy
    on QueryBuilder<InstallmentPlan, InstallmentPlan, QSortThenBy> {
  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy> thenByAutoAdd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoAdd', Sort.asc);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy>
      thenByAutoAddDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoAdd', Sort.desc);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy>
      thenByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy>
      thenByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy>
      thenByDayOfMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayOfMonth', Sort.asc);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy>
      thenByDayOfMonthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayOfMonth', Sort.desc);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy>
      thenByFirstPaymentDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstPaymentDate', Sort.asc);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy>
      thenByFirstPaymentDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstPaymentDate', Sort.desc);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy>
      thenByItemName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemName', Sort.asc);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy>
      thenByItemNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemName', Sort.desc);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy>
      thenByMonthlyAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyAmount', Sort.asc);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy>
      thenByMonthlyAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyAmount', Sort.desc);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy>
      thenByOriginalPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalPrice', Sort.asc);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy>
      thenByOriginalPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalPrice', Sort.desc);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy>
      thenByPaidAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paidAmount', Sort.asc);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy>
      thenByPaidAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paidAmount', Sort.desc);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy>
      thenByPaidInstallments() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paidInstallments', Sort.asc);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy>
      thenByPaidInstallmentsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paidInstallments', Sort.desc);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy>
      thenByProviderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'providerId', Sort.asc);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy>
      thenByProviderIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'providerId', Sort.desc);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy>
      thenByProviderIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'providerIndex', Sort.asc);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy>
      thenByProviderIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'providerIndex', Sort.desc);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy>
      thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy>
      thenByStatusIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statusIndex', Sort.asc);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy>
      thenByStatusIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statusIndex', Sort.desc);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy>
      thenByTotalInstallments() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalInstallments', Sort.asc);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy>
      thenByTotalInstallmentsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalInstallments', Sort.desc);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy>
      thenByTotalWithInterest() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalWithInterest', Sort.asc);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy>
      thenByTotalWithInterestDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalWithInterest', Sort.desc);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy>
      thenByWalletId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'walletId', Sort.asc);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QAfterSortBy>
      thenByWalletIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'walletId', Sort.desc);
    });
  }
}

extension InstallmentPlanQueryWhereDistinct
    on QueryBuilder<InstallmentPlan, InstallmentPlan, QDistinct> {
  QueryBuilder<InstallmentPlan, InstallmentPlan, QDistinct>
      distinctByAutoAdd() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'autoAdd');
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QDistinct> distinctByCategory(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'category', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QDistinct>
      distinctByDayOfMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dayOfMonth');
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QDistinct>
      distinctByFirstPaymentDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'firstPaymentDate');
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QDistinct> distinctByItemName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'itemName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QDistinct>
      distinctByMonthlyAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'monthlyAmount');
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QDistinct>
      distinctByOriginalPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'originalPrice');
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QDistinct>
      distinctByPaidAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'paidAmount');
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QDistinct>
      distinctByPaidInstallments() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'paidInstallments');
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QDistinct>
      distinctByProviderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'providerId');
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QDistinct>
      distinctByProviderIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'providerIndex');
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QDistinct> distinctByStatus(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QDistinct>
      distinctByStatusIndex({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'statusIndex', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QDistinct>
      distinctByTotalInstallments() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalInstallments');
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QDistinct>
      distinctByTotalWithInterest() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalWithInterest');
    });
  }

  QueryBuilder<InstallmentPlan, InstallmentPlan, QDistinct>
      distinctByWalletId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'walletId');
    });
  }
}

extension InstallmentPlanQueryProperty
    on QueryBuilder<InstallmentPlan, InstallmentPlan, QQueryProperty> {
  QueryBuilder<InstallmentPlan, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<InstallmentPlan, bool, QQueryOperations> autoAddProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'autoAdd');
    });
  }

  QueryBuilder<InstallmentPlan, String, QQueryOperations> categoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'category');
    });
  }

  QueryBuilder<InstallmentPlan, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<InstallmentPlan, int, QQueryOperations> dayOfMonthProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dayOfMonth');
    });
  }

  QueryBuilder<InstallmentPlan, DateTime, QQueryOperations>
      firstPaymentDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'firstPaymentDate');
    });
  }

  QueryBuilder<InstallmentPlan, String, QQueryOperations> itemNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'itemName');
    });
  }

  QueryBuilder<InstallmentPlan, double, QQueryOperations>
      monthlyAmountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'monthlyAmount');
    });
  }

  QueryBuilder<InstallmentPlan, double, QQueryOperations>
      originalPriceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'originalPrice');
    });
  }

  QueryBuilder<InstallmentPlan, double, QQueryOperations> paidAmountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'paidAmount');
    });
  }

  QueryBuilder<InstallmentPlan, int, QQueryOperations>
      paidInstallmentsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'paidInstallments');
    });
  }

  QueryBuilder<InstallmentPlan, int, QQueryOperations> providerIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'providerId');
    });
  }

  QueryBuilder<InstallmentPlan, int, QQueryOperations> providerIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'providerIndex');
    });
  }

  QueryBuilder<InstallmentPlan, String, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<InstallmentPlan, String, QQueryOperations>
      statusIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'statusIndex');
    });
  }

  QueryBuilder<InstallmentPlan, int, QQueryOperations>
      totalInstallmentsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalInstallments');
    });
  }

  QueryBuilder<InstallmentPlan, double, QQueryOperations>
      totalWithInterestProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalWithInterest');
    });
  }

  QueryBuilder<InstallmentPlan, int, QQueryOperations> walletIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'walletId');
    });
  }
}
