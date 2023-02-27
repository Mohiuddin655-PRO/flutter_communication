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

enum SupportingLanguage {
  en('en'),
  bn('bn');

  final String code;

  const SupportingLanguage(this.code);
}
