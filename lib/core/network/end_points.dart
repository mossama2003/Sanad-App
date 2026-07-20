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

/// Volunteering Events
String JOIN_EVENT = 'v1/events/join/';

String LEAVE_EVENT = 'v1/events/leave/';

/// Organization Events
String CREATE_ORGANIZATION_EVENT = 'v1/events/manage_event/';

String UPDATE_ORGANIZATION_EVENT(int ID) => 'v1/events/manage_event/$ID/';

String DELETE_ORGANIZATION_EVENT(int ID) => 'v1/events/manage_event/$ID/';
