import 'chat_model.dart';

class SearchResultMessageModel {
  final int id;
  final EventChatCreatorModel creator;
  final String message;
  final DateTime created;

  SearchResultMessageModel({
    required this.id,
    required this.creator,
    required this.message,
    required this.created,
  });

  factory SearchResultMessageModel.fromJson(Map<String, dynamic> json) {
    return SearchResultMessageModel(
      id: json['id'] ?? 0,
      creator: EventChatCreatorModel.fromJson(json['creator'] ?? {}),
      message: json['message'] ?? '',
      created: DateTime.tryParse(json['created'] ?? '') ?? DateTime.now(),
    );
  }
}

class PaginatedSearchResultModel {
  final int count;
  final String? next;
  final String? previous;
  final List<SearchResultMessageModel> results;

  PaginatedSearchResultModel({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory PaginatedSearchResultModel.fromJson(Map<String, dynamic> json) {
    return PaginatedSearchResultModel(
      count: json['count'] ?? 0,
      next: json['next'],
      previous: json['previous'],
      results: (json['results'] as List<dynamic>? ?? [])
          .map(
            (e) => SearchResultMessageModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  bool get hasMore => next != null;
}

class EventChatContextModel {
  final int eventId;
  final int highlightMessageId;
  final List<EventChatDetailModel> older;
  final EventChatDetailModel target;
  final List<EventChatDetailModel> newer;
  final bool hasMoreBefore;
  final bool hasMoreAfter;

  EventChatContextModel({
    required this.eventId,
    required this.highlightMessageId,
    required this.older,
    required this.target,
    required this.newer,
    required this.hasMoreBefore,
    required this.hasMoreAfter,
  });

  factory EventChatContextModel.fromJson(Map<String, dynamic> json) {
    return EventChatContextModel(
      eventId: json['event_id'] ?? 0,
      highlightMessageId: json['highlight_message_id'] ?? 0,
      older: (json['older'] as List<dynamic>? ?? [])
          .map((e) => EventChatDetailModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      target: EventChatDetailModel.fromJson(json['target'] ?? {}),
      newer: (json['newer'] as List<dynamic>? ?? [])
          .map((e) => EventChatDetailModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      hasMoreBefore: json['has_more_before'] ?? false,
      hasMoreAfter: json['has_more_after'] ?? false,
    );
  }

  /// كل الرسايل مرتبة زمنيًا: القديمة، الهدف، الجديدة
  List<EventChatDetailModel> get allMessages => [...older, target, ...newer];
}
