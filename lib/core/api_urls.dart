abstract class ApiURL {
  static final String baseURL = "http://localhost:8000/v1";

  static final String createJournal = "/journals";
  static final String getJournals = "/journal";
  static String updateJournal(String id) => "/journals/$id";
  static String getJournal(String id) => "/journals/$id";
  static String deleteJournal(String id) => "/journals/$id";


  static String summary = "/summary";
  static String chat = "/chat";
}
