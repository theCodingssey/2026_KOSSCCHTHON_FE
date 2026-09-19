abstract final class ApiEndpoints {
  static const health = '/health';

  static const users = '/users';
  static const usersMe = '/users/me';
  static const usersMeRooms = '/users/me/rooms';

  static const rooms = '/rooms';

  static String room(String code) => '/rooms/$code';
  static String hostRoom(String code) => '/host/rooms/$code';
  static String hostRoomTeamBuilding(String code) =>
      '/host/rooms/$code/team-building';
  static String hostRoomParticipants(String code) =>
      '/host/rooms/$code/participants';
  static String hostRoomParticipant(String code, int participantId) =>
      '/host/rooms/$code/participants/$participantId';
  static String hostRoomTeams(String code) => '/host/rooms/$code/teams';
  static String hostRoomTeamMembers(String code, int teamId) =>
      '/host/rooms/$code/teams/$teamId/members';
  static String hostRoomFinalQuestions(String code) =>
      '/host/rooms/$code/final-questions';
  static String hostRoomFinish(String code) => '/host/rooms/$code/finish';
  static String hostRoomEvents(String code) => '/host/rooms/$code/events';

  static String roomParticipants(String code) => '/rooms/$code/participants';
  static String roomMe(String code) => '/rooms/$code/me';
  static String roomMeSurvey(String code) => '/rooms/$code/me/survey';
  static String roomMeTeam(String code) => '/rooms/$code/me/team';
  static String roomMeEvents(String code) => '/rooms/$code/me/events';

  static String team(int teamId) => '/teams/$teamId';
  static String teamStart(int teamId) => '/teams/$teamId/start';
  static String teamName(int teamId) => '/teams/$teamId/name';
  static String teamQuestions(int teamId) => '/teams/$teamId/questions';
  static String teamCurrentQuestion(int teamId) =>
      '/teams/$teamId/questions/current';
  static String teamNextQuestion(int teamId) => '/teams/$teamId/questions/next';
  static String teamQuestion(int teamId, int questionId) =>
      '/teams/$teamId/questions/$questionId';
  static String teamQuestionAnswer(int teamId, int questionId) =>
      '/teams/$teamId/questions/$questionId/answer';
  static String teamQuestionRetry(int teamId, int questionId) =>
      '/teams/$teamId/questions/$questionId/retry';
  static String teamSummary(int teamId) => '/teams/$teamId/summary';
  static String teamEvents(int teamId) => '/teams/$teamId/events';
}
