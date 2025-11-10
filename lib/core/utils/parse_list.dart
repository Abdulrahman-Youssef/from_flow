
List<T> parseList<T>(String key,Map<String, dynamic> json  ,T Function(Map<String, dynamic>) fromJson ) {
  if (json[key] == null) return []; // Return empty list if key is missing
  final List<dynamic> list = json[key] as List<dynamic>;
  return list
      .map((item) => fromJson(item as Map<String, dynamic>))
      .toList();
}