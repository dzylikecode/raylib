class RaylibTranslator {
  final String content;
  final List<String> lines;

  RaylibTranslator(this.content) : lines = content.split('\n');
}