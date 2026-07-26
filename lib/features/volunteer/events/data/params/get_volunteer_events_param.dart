class GetVolunteerEventsParam {
  List<String>? category;
  final int? creator;
  final String? dateAfter;
  final String? dateBefore;
  final List<int>? attendees;
  final List<int>? joiners;
  final bool? mostAvailableSpots;
  final bool? nearBy;
  final String? ordering;
  final int? page;
  final int? size;
  final String? search;
  final String? state;
  final List<String>? status;

  GetVolunteerEventsParam({
    this.category,
    this.creator,
    this.dateAfter,
    this.dateBefore,
    this.attendees,
    this.joiners,
    this.mostAvailableSpots,
    this.nearBy,
    this.ordering,
    this.page,
    this.size,
    this.search,
    this.state,
    this.status,
  });

  Map<String, dynamic> toQuery() {
    return {
      if (category != null) "category": category,

      if (creator != null) "creator": creator,

      if (dateAfter != null) "date_after": dateAfter,

      if (dateBefore != null) "date_before": dateBefore,

      if (attendees != null) "attendees": attendees,

      if (joiners != null) "joiners": joiners,

      if (mostAvailableSpots != null)
        "most_available_spots": mostAvailableSpots,

      if (nearBy != null) "near_by": nearBy,

      if (ordering != null) "ordering": ordering,

      if (page != null) "page": page,

      if (size != null) "size": size,

      if (search != null) "search": search,

      if (state != null) "state": state,

      if (status != null) "status": status!.join(','),
    };
  }
}
