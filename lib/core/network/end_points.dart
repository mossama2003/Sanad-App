// ignore_for_file: non_constant_identifier_names

// Test
// String BASE_URL = 'https://wazen.telasttechnologies.com/api/';

/// Production
String BASE_URL = 'https://testapi.joinsanad.org/api/';

/// Auth
String SIGN_UP = 'auth/registration/';

String SIGN_IN = 'auth/login/';

String GET_USER = 'auth/user/';

String REFRESH_TOKEN = 'auth/token/refresh/';

String LOG_OUT = 'auth/logout/';

String DELETE_ACCOUNT = 'v1/users/profile/delete/';

/// Skills
String GET_SKILLS = 'v1/categories/select_category/';

/// Both Volunteering and Organization
String GET_EVENTS = 'v1/events/read_event/';

String EVENT_QR(int ID) => 'v1/events/read_event/$ID/';

/// Chat
String GET_CHAT_TOKEN(int eventId) =>
    'v1/events/read_event/$eventId/chat_token/';

String GET_CHAT_HISTORY = 'v1/events/event_chat/';

String SEND_CHAT_MESSAGE = 'v1/events/event_chat/';

String EVENT_MEMBER_BATCH_UPDATE(int eventId) =>
    'v1/events/event_member_batch_update/$eventId/';

String EDIT_MESSAGE(int messageId) => 'v1/events/event_chat/$messageId/';

String DELETE_MESSAGE = 'v1/events/event_chat/batch_delete/';

String EVENT_MEMBERS = 'v1/events/read_event_member/';

String MANAGE_EVENT_MEMBER(int id) => 'v1/events/manage_event_member/$id/';

String LEAVE_EVENT_CHAT = 'v1/events/leave/';

String REPORT_EVENT_CHAT = 'v1/events/event_report/';

String SEARCH_CHAT_MESSAGES = 'v1/events/event_chat/search/';

String SEARCH_CHAT_CONTEXT = 'v1/events/event_chat/search_context/';

/// Volunteering Endpoints
String JOIN_EVENT = 'v1/events/join/';

String LEAVE_EVENT = 'v1/events/leave/';

String SCAN_QR = 'v1/events/scan/';

String VOLUNTEER_HOME = 'v1/dashboard/home/volunteer/';

String VOLUNTEER_COMMUNITIES = 'v1/events/read_event/';

/// Organization Endpoints
String CREATE_ORGANIZATION_EVENT = 'v1/events/manage_event/';

String UPDATE_ORGANIZATION_EVENT(int ID) => 'v1/events/manage_event/$ID/';

String DELETE_ORGANIZATION_EVENT(int ID) => 'v1/events/manage_event/$ID/';

String ORGANIZATION_HOME = 'v1/dashboard/home/organization/';
