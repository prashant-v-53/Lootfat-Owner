import 'dart:convert';

QuestionModel questionModelFromJson(String str) => QuestionModel.fromJson(json.decode(str));

String questionModelToJson(QuestionModel data) => json.encode(data.toJson());

class QuestionModel {
    final String id;
    final String question;
    final List<Option> options;
    final bool isActive;
    final dynamic deletedAt;
    final DateTime createdAt;
    final DateTime updatedAt;
    List<String> answers;

    QuestionModel({
        required this.id,
        required this.question,
        required this.options,
        required this.isActive,
        required this.deletedAt,
        required this.createdAt,
        required this.updatedAt,
        required this.answers,
    });

    factory QuestionModel.fromJson(Map<String, dynamic> json) => QuestionModel(
        id: json["_id"],
        question: json["question"],
        options: List<Option>.from(json["options"].map((x) => Option.fromJson(x))),
        isActive: json["isActive"],
        deletedAt: json["deletedAt"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        answers: [],
    );

    Map<String, dynamic> toJson() => {
        "question": id,
        "answer": answers,
    };
}

class Option {
    final String option;
    final String id;

    Option({
        required this.option,
        required this.id,
    });

    factory Option.fromJson(Map<String, dynamic> json) => Option(
        option: json["option"],
        id: json["_id"],
    );

    Map<String, dynamic> toJson() => {
        "option": option,
        "_id": id,
    };
}

class AnswerModel {
    final String question;
    final List<String> answer;

    AnswerModel({
        required this.question,
        required this.answer,
    });

    factory AnswerModel.fromJson(Map<String, dynamic> json) => AnswerModel(
        question: json["question"],
        answer: List<String>.from(json["answer"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "question": question,
        "answer": List<dynamic>.from(answer.map((x) => x)),
    };
}
