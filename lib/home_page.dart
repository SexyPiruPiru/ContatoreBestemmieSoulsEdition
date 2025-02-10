import 'package:flutter/material.dart';
import 'game_page/demons_souls_page.dart';
import 'game_page/dark_souls_page.dart';
import 'game_page/dark_souls_2_page.dart';
import 'game_page/dark_souls_3_page.dart';
import 'game_page/bloodborne_page.dart';
import 'game_page/sekiro_page.dart';
import 'game_page/elden_ring_page.dart';
import 'settings_page.dart';

class HomePage extends StatelessWidget {
  final VoidCallback toggleTheme;

  const HomePage({super.key, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final buttonBackgroundColor = isDarkTheme ? Colors.grey.shade900 : Colors.white;
    final buttonTextColor = isDarkTheme ? Colors.white : Colors.black;
    final backgroundColor = isDarkTheme ? const Color.fromARGB(255, 20, 20, 20) : Colors.grey.shade200;
    final backgroundImage = isDarkTheme
        ? 'assets/images/Dark_wallpaper.png'
        : 'assets/images/White_wallpaper1.png';

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Contatore di bestemmie'),
        ),
        backgroundColor: backgroundColor, // Colore di sfondo dell'AppBar
      ),
      body: Stack(
        children: [
          Container(
            color: backgroundColor,
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Image.asset(
              backgroundImage,
              height: 280,
              fit: BoxFit.cover,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 5), // Spazio di 5 pixel dal margine superiore
              const Center(
                child: Text(
                  'YOU DIED',
                  style: TextStyle(
                    fontFamily: 'OptimusPrinceps',
                    fontSize: 48,
                    color: Color(0xFFB22222), // Rosso scuro
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _buildButton(context, "Demon's Souls", DemonsSoulsPage(isDarkTheme: isDarkTheme), buttonBackgroundColor, buttonTextColor),
                  _buildButton(context, 'Dark Souls', DarkSoulsPage(isDarkTheme: isDarkTheme), buttonBackgroundColor, buttonTextColor),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _buildButton(context, 'Dark Souls 2', DarkSouls2Page(isDarkTheme: isDarkTheme), buttonBackgroundColor, buttonTextColor),
                  _buildButton(context, 'Dark Souls 3', DarkSouls3Page(isDarkTheme: isDarkTheme), buttonBackgroundColor, buttonTextColor),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _buildButton(context, 'Bloodborne', BloodbornePage(isDarkTheme: isDarkTheme), buttonBackgroundColor, buttonTextColor),
                  _buildButton(context, 'Sekiro', SekiroPage(isDarkTheme: isDarkTheme), buttonBackgroundColor, buttonTextColor),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _buildButton(context, 'Elden Ring', EldenRingPage(isDarkTheme: isDarkTheme), buttonBackgroundColor, buttonTextColor),
                  const SizedBox(width: 150), // Spazio per allineare il bottone
                ],
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SettingsPage(
                isDarkTheme: isDarkTheme,
                onThemeChanged: (isDark) => toggleTheme(),
              ),
            ),
          );
        },
        backgroundColor: buttonBackgroundColor, // Colore sfondo
        child: Icon(Icons.settings, color: buttonTextColor), // colore icona
      ),
    );
  }

  Widget _buildButton(BuildContext context, String title, Widget page, Color backgroundColor, Color textColor) {
    return SizedBox(
      width: 150,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor, // Colore di sfondo
          foregroundColor: textColor, // Colore del testo
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0), // Bordi quadrati
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        child: Text(title),
      ),
    );
  }
}