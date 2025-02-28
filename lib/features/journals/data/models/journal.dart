import 'package:ai_journal_app/features/journals/domain/entities/journal_entity.dart';

class Journal extends JournalEntity {
  Journal({
    required super.id,
    required super.date,
    super.title,
    super.content,
  });

  factory Journal.fromJson(Map<String, dynamic> json) {
    return Journal(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      date: DateTime.tryParse(json['date']) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
    };
  }

  static seedSingleJournal() {
    return Journal(
      id: '1',
      title: 'Journal 1',
      content: 'This is the content of journal 1',
      date: DateTime.now(),
    );
  }

  static List<Journal> seedMultipleJournals() {
    return [
      Journal(
        id: '1',
        title: 'Journal 1',
        content: 'This is the content of journal 1',
        date: DateTime.now(),
      ),
      Journal(
        id: '2',
        title: 'Journal 2',
        content: 'This is the content of journal 2',
        date: DateTime.now(),
      ),
    ];
  }
}
