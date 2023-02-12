import '../feature/data/local/contents/languages.dart';

class RegionalTextProvider<T> {
  final T content;
  final SupportingLanguage language;
  final String Function(SupportingLanguage language, T content) builder;

  const RegionalTextProvider({
    required this.content,
    required this.language,
    required this.builder,
  });

  String get value => builder.call(language, content);
}
