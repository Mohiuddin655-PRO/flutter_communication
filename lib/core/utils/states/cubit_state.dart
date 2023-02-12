class CubitState<T> {
  final bool isFirstLoading;
  final bool isLoading;
  final String exception;
  final dynamic data;
  final List<T> result;

  CubitState({
    required this.isFirstLoading,
    required this.isLoading,
    required this.exception,
    this.data,
    this.result = const [],
  });

  CubitState copyWith({
    bool? isFirstLoading,
    bool? isLoading,
    String? exception,
    dynamic data,
    List<T>? result,
  }) {
    return CubitState(
      isFirstLoading: isFirstLoading ?? this.isFirstLoading,
      isLoading:
          isLoading ?? (result != null ? exception != null : this.isLoading),
      exception: exception ?? this.exception,
      data: data,
      result: result ?? this.result,
    );
  }

  @override
  String toString() {
    return 'CubitState: \n{'
        '\n isFirstLoading: $isFirstLoading\n isLoading: $isLoading\n exception: $exception\n result: $result\n}';
  }
}
