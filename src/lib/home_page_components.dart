import 'package:flutter/material.dart';

class CannotFindWord extends StatelessWidget {
  const CannotFindWord({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.quiz,
          color: Colors.green,
          size: 70,
        ),
        Text(
          'Cannot find your word',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}

class DefinitionAndExampleText extends StatelessWidget {
  const DefinitionAndExampleText({
    Key? key,
    required this.definition,
    required this.example,
  }) : super(key: key);

  final String definition;
  final String? example;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Meaning:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          definition,
          style: TextStyle(
            fontSize: 15,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          'Example:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          example == null ? '...' : example!,
          style: TextStyle(
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}

class WordAndTypeText extends StatelessWidget {
  const WordAndTypeText({
    Key? key,
    required this.word,
    required this.type,
  }) : super(key: key);

  final String word;
  final String type;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(children: [
        TextSpan(
          text: word,
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        TextSpan(
          text: " (" + type + ")",
          style: TextStyle(
            fontSize: 20,
            color: Colors.grey,
          ),
        ),
      ]),
    );
  }
}

class ImgView extends StatelessWidget {
  const ImgView({
    Key? key,
    required this.img,
  }) : super(key: key);
  final String img;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(
            img,
          ),
        ),
      ),
    );
  }
}