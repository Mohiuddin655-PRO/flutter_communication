class Response<T> {
  final bool isCancel;
  final bool isSuccessful;
  final bool isFailed;
  final String message;
  final T? result;
  final dynamic snapshot;
  final Status status;
  final String tag;

  const Response({
    this.result,
    this.message = '',
    this.isCancel = false,
    this.isSuccessful = false,
    this.isFailed = false,
    this.snapshot,
    this.status = Status.noContent,
    this.tag = "",
  });

  Response<T> copyWith({
    bool? isCancel,
    bool? isSuccessful,
    bool? isFailed,
    T? result,
    String? message,
    dynamic snapshot,
    Status? status,
    String? tag,
  }) {
    return Response(
      isCancel: isCancel ?? this.isCancel,
      isSuccessful: isSuccessful ?? result != null ? true : this.isSuccessful,
      isFailed: isFailed ?? this.isFailed,
      result: result ?? this.result,
      snapshot: snapshot ?? this.snapshot,
      tag: tag ?? this.tag,
      message:
          message ?? (isSuccessful ?? false ? "Successful!" : this.message),
      status: status ??
          (result != null
              ? Status.ok
              : (snapshot != null
                  ? Status.created
                  : (message != null ? Status.notFound : this.status))),
    );
  }

  Snapshot? getSnapshot<Snapshot>() {
    return snapshot != null && snapshot is Snapshot ? snapshot : null;
  }

  get statusCode => status.value;
}

enum Status {
  processing(200),
  ok(200),
  created(201),
  accepted(202),
  noContent(204),
  resetContent(205),
  partialContent(206),
  multipleChoices(300),
  movedPermanently(301),
  notFound(404),
  notAcceptable(406),
  requestTimeout(408);

  const Status(this.value);

  final int value;
}
