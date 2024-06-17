part of 'fire_coll_query.dart';

class FireCollFilter {
  final Filter _filter;

  FireCollFilter(
    String field, {
    dynamic isEqualTo,
    dynamic isNotEqualTo,
    dynamic isLessThan,
    dynamic isLessThanOrEqualTo,
    dynamic isGreaterThan,
    dynamic isGreaterThanOrEqualTo,
    List<dynamic>? arrayContains,
    List<dynamic>? arrayContainsAny,
    List<dynamic>? arrayContainsAll,
    Iterable<Object?>? whereIn,
    List<dynamic>? whereNotIn,
    bool? isNull,
  }) : _filter = Filter(
          field,
          isEqualTo: isEqualTo,
          isNotEqualTo: isNotEqualTo,
          isLessThan: isLessThan,
          isLessThanOrEqualTo: isLessThanOrEqualTo,
          isGreaterThan: isGreaterThan,
          isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
          arrayContains: arrayContains,
          arrayContainsAny: arrayContainsAny,
          whereIn: whereIn,
          whereNotIn: whereNotIn,
          isNull: isNull,
        );

  FireCollFilter._byFilter(this._filter);

  // override operator &&
  FireCollFilter operator &(FireCollFilter other) {
    return FireCollFilter._byFilter(Filter.and(_filter, other._filter));
  }

  // override operator ||
  FireCollFilter operator |(FireCollFilter other) {
    return FireCollFilter._byFilter(Filter.or(_filter, other._filter));
  }
}
