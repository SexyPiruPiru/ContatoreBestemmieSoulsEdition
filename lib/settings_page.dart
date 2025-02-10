import 'package:flutter/material.dart';
import 'dart:async';

class SettingsPage extends StatefulWidget {
  final bool isDarkTheme;
  final ValueChanged<bool> onThemeChanged;

  const SettingsPage({super.key, required this.isDarkTheme, required this.onThemeChanged});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late bool _isDarkTheme;

  @override
  void initState() {
    super.initState();
    _isDarkTheme = widget.isDarkTheme;
  }

  void _toggleTheme(bool isDark) {
    setState(() {
      _isDarkTheme = isDark;
    });
    widget.onThemeChanged(isDark);
  }

  @override
  Widget build(BuildContext context) {
    final buttonBackgroundColor = _isDarkTheme ? Colors.grey.shade900 : Colors.white;
    final buttonTextColor = _isDarkTheme ? Colors.white : Colors.black;
    final backgroundColor = _isDarkTheme ? const Color.fromARGB(255, 20, 20, 20) : Colors.grey.shade200;

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Impostazioni'),
        ),
        backgroundColor: backgroundColor, // Colore di sfondo dell'AppBar
      ),
      body: Container(
        color: backgroundColor, // Colore di sfondo del corpo
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10.0), // Spazio dal bordo sinistro
              child: Row(
                children: <Widget>[
                  const Text(
                    'Tema',
                    style: TextStyle(
                      fontSize: 18, // Grandezza del font
                      fontWeight: FontWeight.bold, // Grassetto
                    ),
                  ),
                  const SizedBox(width: 20), // Spazio tra la scritta e il selettore
                  Switch(
                    value: _isDarkTheme,
                    onChanged: (isDark) {
                      _toggleTheme(isDark);
                      setState(() {
                        _isDarkTheme = isDark;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 10.0), // Spazio dal bordo sinistro di 10 pixel
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        Timer(const Duration(seconds: 4), () {
                          Navigator.of(context).pop();
                        });
                        return AlertDialog(
                          content: Image.asset('assets/images/Benedizione_divina.jpg'),
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonBackgroundColor, // Colore di sfondo
                    foregroundColor: buttonTextColor, // Colore del testo
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0), // Bordi quadrati
                    ),
                  ),
                  child: Text(
                    'Benedizione Divina - ti porterà fortuna',
                    style: TextStyle(color: buttonTextColor),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}