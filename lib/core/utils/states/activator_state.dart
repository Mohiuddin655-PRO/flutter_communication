class ActivatorState<T> {
  final T active;
  final T inactive;
  final String name;

  const ActivatorState({
    required this.active,
    required this.inactive,
    this.name = '',
  });
}
