import '../common/attributes.dart';

final class Resource {
  final Attributes attributes;

  const Resource(this.attributes);

  static const Resource empty = Resource(const Attributes.empty());

  Resource merge(Resource other) {
    if (other.attributes.isEmpty) return this;
    return Resource(attributes.merge(other.attributes));
  }

  @override
  bool operator ==(Object other) =>
      other is Resource && other.attributes == attributes;

  @override
  int get hashCode => attributes.hashCode;

  @override
  String toString() => 'Resource($attributes)';
}
