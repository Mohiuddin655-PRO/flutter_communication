class StateValue<T> {
  final T activeValue;
  final T? inactiveValue;

  const StateValue({
    required this.activeValue,
    this.inactiveValue,
  });

  T get active => activeValue;

  T get inactive => inactiveValue ?? activeValue;

  T detect(bool activated) => activated ? active : inactive;
}
