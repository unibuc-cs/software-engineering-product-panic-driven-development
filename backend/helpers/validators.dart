void discardFromBody(Map<String, dynamic> body, {required List<String> fields}) {
  for (var field in fields) {
    if (body[field] != null) {
      body.remove(field);
    }
  }
}

void validateBody(Map<String, dynamic> body, {required List<String> fields}) {
  for (var field in fields) {
    if (body[field] == null) {
      throw Exception('$field is required');
    }
    else if (body[field].runtimeType == String && body[field] == "") {
      throw Exception('$field cannot be empty');
    }
  }
}

void populateBody(Map<String, dynamic> body, {required Map<String, dynamic> defaultFields}) {
  defaultFields.forEach((key,value) {
    if (body[key] == null) {
      body[key] = value;
    }
  });
}

Future<void> validateExistence(dynamic id, String table, dynamic _supabase) async {
  try {
    await _supabase
      .from(table)
      .select()
      .eq('id', id)
      .single();
  }
  catch (e) {
    throw Exception('${table.toLowerCase()}Id not found');
  }
}

void validateService(String service) {
  final List<String> validServices = [
    'pcgamingwiki',
    'howlongtobeat',
    'steam',
    'goodreads',
    'tmdbmovie',
    'tmdbseries',
    'anilistanime',
    'anilistmanga',
    'igdb'
  ];
  if (!validServices.contains(service.toLowerCase())) {
    throw Exception('Service not found');
  }
}

void validateMethod(String method) {
  final List<String> validMethods = [
    'options',
    'info',
    'recommendations'
  ];
  if (!validMethods.contains(method.toLowerCase())) {
    throw Exception('Method not found');
  }
}