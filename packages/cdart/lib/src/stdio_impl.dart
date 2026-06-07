class FILE {
  final StringBuffer _buf = StringBuffer();
  bool _error = false;

  FILE();

  void write(String s) {
    if (!_error) _buf.write(s);
  }

  String get content => _buf.toString();
  bool get hasError => _error;
  void setError() { _error = true; }
  void clearError() { _error = false; }
}
