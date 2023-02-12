enum Levels {
  all(
    key: "all",
    enValue: "All",
    bnValue: "",
  );

  final String enValue, bnValue, key;

  const Levels({
    required this.key,
    required this.enValue,
    required this.bnValue,
  });
}
