import 'package:flutter/material.dart';

class AboutSVA extends StatefulWidget {
  const AboutSVA({Key? key}) : super(key: key);

  @override
  State<AboutSVA> createState() => _AboutSVAState();
}

class _AboutSVAState extends State<AboutSVA> {

  @override
  Widget build(BuildContext context) {
    var pixelRatio = MediaQuery.of(context).devicePixelRatio;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(32, 32, 0, 0),
                  child: Container(
                      height: 100 / pixelRatio,
                      width: 100 / pixelRatio,
                      decoration: const BoxDecoration(
                          color: Color(0xff093f5c), shape: BoxShape.circle),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Color(0xffede2d8),
                        size: 20,
                      )),
                ),
                onTap: () { Navigator.pop(context); },
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0.0, 100 / pixelRatio, 0.0, 0.0),
              child: Text(
                'Smart Voice Assistant',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 75.0 / pixelRatio,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xffec8420),
                  fontFamily: 'Inter',
                ),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(32.0, 50 / pixelRatio, 32.0, 0.0),
                    child: Text(
                      'Smart Voice Assistant, or simply speech recognition, is the technology that allows computers to understand human speech. This can be used in many different ways, including voice command systems and computer-to-computer communication. Speech recognition is often described as a "natural language" interface because it is based on understanding human language rather than requiring a specific set of commands to be understood.\n\nSpeech recognition works by converting the sound of a person talking into digital data. This data is then compared with a database of words and phrases that have already been tagged as relevant to the speaker\'s voice. The computer uses this comparison to determine whether or not it should respond with an appropriate response back to its user.',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 40.0 / pixelRatio,
                        fontWeight: FontWeight.normal,
                        color: const Color(0xff000000),
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                  SizedBox(height: 100/pixelRatio,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
