class Answer{
  final String question_id;

  Answer({this.question_id});
}

class AnswersData{
  final String uid;
  final String question_id;
  final String answer;

  AnswersData({this.uid, this.question_id, this.answer});
}