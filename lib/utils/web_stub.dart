// Stub implementation for non-web platforms
class Window {
  dynamic get localStorage => _Storage();
  dynamic get sessionStorage => _Storage();
  dynamic get navigator => _Navigator();
  dynamic get indexedDB => _IndexedDB();
}

class Document {
  String? cookie = '';
}

class _Storage {
  void clear() {}
}

class _Navigator {
  dynamic get serviceWorker => _ServiceWorker();
}

class _ServiceWorker {
  Future<List<_Registration>> getRegistrations() async {
    return [];
  }
}

class _Registration {
  void unregister() {}
}

class _IndexedDB {
  void deleteDatabase(String name) {}
}

// Stub window and document instances
final window = Window();
final document = Document();
