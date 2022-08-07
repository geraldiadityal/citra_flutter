part of 'widgets.dart';

class CustomQuestionCard extends StatefulWidget {
  final QuestionCitraService question;

  const CustomQuestionCard({Key? key, required this.question})
      : super(key: key);

  @override
  State<CustomQuestionCard> createState() => _CustomQuestionCardState();
}

class _CustomQuestionCardState extends State<CustomQuestionCard> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        widget.question.question,
        style: blackTextFont.copyWith(fontSize: 16, fontWeight: semiBold),
      ),
      children: [
        Text(
          widget.question.answer,
          style: blackTextFont,
        ),
      ],
    );
  }
}
