abstract class ApiURL {
  static const Duration receiveTimeout = Duration(milliseconds: 15000); // 15 seconds
  static const Duration connectionTimeout = Duration(milliseconds: 15000); // 15 seconds
  static final String baseURL = "http://192.168.100.60:8000/api/v1";

  static final String createJournal = "/journals";
  static final String getJournals = "/journals/";
  static String updateJournal(String id) => "/journals/$id";
  static String getJournal(String id) => "/journals/$id";
  static String deleteJournal(String id) => "/journals/$id";


  static String summary = "/journals/summary";
  static String chat = "/journals/chat";
}
