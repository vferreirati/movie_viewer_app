import 'package:equatable/equatable.dart';

class Pagination extends Equatable {
  final int size;

  final int page;

  final bool canLoadMore;

  const Pagination({
    required this.size,
    this.page = 1,
    this.canLoadMore = true,
  });

  Pagination paginate({
    required bool canLoadMore,
  }) {
    return Pagination(
      page: page + 1,
      canLoadMore: canLoadMore,
      size: size,
    );
  }

  Pagination copyWith({
    int? size,
    int? page,
    bool? canLoadMore,
  }) {
    return Pagination(
      size: size ?? this.size,
      page: page ?? this.page,
      canLoadMore: canLoadMore ?? this.canLoadMore,
    );
  }

  @override
  List<Object> get props => [
        size,
        page,
        canLoadMore,
      ];
}
