import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/gestures.dart'; // Added for TapGestureRecognizer

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ayuda')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with logo placeholder
            Center(
              child: Column(
                children: [
                  SvgPicture.asset('assets/images/h.svg', height: 120),
                  const SizedBox(height: 20),
                  const Text(
                    'artacho.org',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // Welcome section
            const Center(
              child: Text(
                'Benvingut/da a HArtacho!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                'Som-hi!!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(height: 25),

            // Main content
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: Colors.black87,
                ),
                children: [
                  const TextSpan(
                    text:
                        'Hartacho amb H potser no és un error, es tracta de tornar als orígens.\n\n'
                        'Aquest projecte és una aplicació web basada en Laravel que inclou...\n\n',
                  ),
                  TextSpan(
                    text: 'Autenticació i Notificacions.\n',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),

            // Features list
            _buildBulletPoint(
              'Autenticació d\'usuaris i diferents rols des d\'administrador fins a convidats, '
              'amb permisos específics per a cada rol',
            ),
            _buildBulletPoint(
              'Notificacions per comunicar-se amb els usuaris, via web o correu electrònic.',
            ),
            const SizedBox(height: 25),

            // GitHub section
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: Colors.black87,
                ),
                children: [
                  const TextSpan(
                    text: 'Per començar, pots fer una ullada al codi a ',
                  ),
                  TextSpan(
                    text: 'GitHub',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // Add your GitHub URL here
                        // launchUrl(Uri.parse('https://github.com/...'));
                      },
                  ),
                  const TextSpan(
                    text:
                        '. S\'esperen suggeriments, propostes, revisions, '
                        'contribucions i també col·laboradors.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Call to action - Fixed this section
            /*  Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                ),
                child: const Text('Comencem!!', style: TextStyle(fontSize: 18)),
              ),
            ), */
          ],
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 5.0),
            child: Icon(Icons.circle, size: 8, color: Colors.blue),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16, height: 1.6),
            ),
          ),
        ],
      ),
    );
  }
}
