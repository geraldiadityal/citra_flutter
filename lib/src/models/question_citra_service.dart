part of 'models.dart';

class QuestionCitraService extends Equatable {
  final int id;
  final int services_id;
  final String question;
  final String answer;

  QuestionCitraService({
    required this.id,
    required this.services_id,
    required this.question,
    required this.answer,
  });

  factory QuestionCitraService.fromJson(Map<String, dynamic> json) =>
      QuestionCitraService(
          id: json['id'],
          services_id: json['services_id'],
          question: json['question'],
          answer: json['answer']);

  @override
  List<Object> get props => [id, services_id, question, answer];
}
