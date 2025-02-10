import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DarkSoulsPage extends StatefulWidget {
  final bool isDarkTheme;

  const DarkSoulsPage({super.key, required this.isDarkTheme});

  @override
  _DarkSoulsPageState createState() => _DarkSoulsPageState();
}

class _DarkSoulsPageState extends State<DarkSoulsPage> {
  List<int> _counters = [];
  List<String> _runTitles = [];

  @override
  void initState() {
    super.initState();
    _loadCounters();
  }

  void _loadCounters() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      int numRuns = (prefs.getInt('DarkSouls_numRuns') ?? 1);
      _runTitles = List.generate(numRuns, (index) => prefs.getString('DarkSouls_RunTitle${index + 1}') ?? 'Run ${index + 1}');
      _counters = List.generate(numRuns, (index) => (prefs.getInt('DarkSouls_Run${index + 1}') ?? 0));
    });
  }

  void _incrementCounter(int index) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counters[index]++;
    });
    prefs.setInt('DarkSouls_Run${index + 1}', _counters[index]);
  }

  void _decrementCounter(int index) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (_counters[index] > 0) {
        _counters[index]--;
      }
    });
    prefs.setInt('DarkSouls_Run${index + 1}', _counters[index]);
  }

  void _removeRun(int index) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _runTitles.removeAt(index);
      _counters.removeAt(index);
    });
    prefs.setInt('DarkSouls_numRuns', _runTitles.length);
    for (int i = 0; i < _runTitles.length; i++) {
      prefs.setInt('DarkSouls_Run${i + 1}', _counters[i]);
      prefs.setString('DarkSouls_RunTitle${i + 1}', _runTitles[i]);
    }
  }

  void _renameRun(int index, String newName) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _runTitles[index] = newName;
    });
    prefs.setString('DarkSouls_RunTitle${index + 1}', newName);
  }

  void _addRun() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _runTitles.add('Run ${_runTitles.length + 1}');
      _counters.add(0);
    });
    prefs.setInt('DarkSouls_numRuns', _runTitles.length);
    prefs.setInt('DarkSouls_Run${_runTitles.length}', 0);
    prefs.setString('DarkSouls_RunTitle${_runTitles.length}', 'Run ${_runTitles.length}');
  }

  void _showOptionsDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Opzioni'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: const Text('Rinomina'),
                onTap: () {
                  Navigator.of(context).pop();
                  _showRenameDialog(index);
                },
              ),
              ListTile(
                title: const Text('Elimina'),
                onTap: () {
                  Navigator.of(context).pop();
                  _showDeleteConfirmationDialog(index);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showRenameDialog(int index) {
    TextEditingController _controller = TextEditingController(text: _runTitles[index]);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Rinomina'),
          content: TextField(
            controller: _controller,
            decoration: const InputDecoration(hintText: 'Nuovo nome'),
            maxLength: 21, // Imposta il limite massimo di caratteri a 21
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Annulla'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Salva'),
              onPressed: () {
                _renameRun(index, _controller.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Conferma eliminazione'),
          content: const Text('Sei sicuro di voler eliminare questa riga?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Annulla'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Elimina'),
              onPressed: () {
                _removeRun(index);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.isDarkTheme ? const Color.fromARGB(255, 20, 20, 20) : Colors.grey.shade200;
    final buttonBackgroundColor = widget.isDarkTheme ? Colors.grey.shade900 : Colors.white;
    final buttonTextColor = widget.isDarkTheme ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(''), //Testo AppBar
        ),
        backgroundColor: backgroundColor, // Colore di sfondo dell'AppBar
      ),
      body: Container(
        color: backgroundColor,
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 80.0, vertical: 4.0), // Bordo di 10 pixel sui lati destro e sinistro, 4 pixel sui lati superiore e inferiore
                child: Image.asset(
                  'assets/images/Dark_Souls_logo.png',
                  fit: BoxFit.contain, // Adatta l'immagine mantenendo le proporzioni
                ),
              ),
            ),
            const SizedBox(height: 4),
            const Center(
              child: Text(
                'Bestemmie tirate',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: ListView.builder(
                itemCount: _runTitles.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Row(
                      children: <Widget>[
                        GestureDetector(
                          onLongPress: () => _showOptionsDialog(index),
                          child: Expanded(
                            child: Text(
                              _runTitles[index],
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: 50, // Imposta una larghezza fissa per il numero
                          child: Text(
                            '${_counters[index]}',
                            style: const TextStyle(fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(width: 20), // Spazio fisso di 20 pixel
                        Row(
                          children: <Widget>[
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => _incrementCounter(index),
                            ),
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () => _decrementCounter(index),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: _addRun,
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonBackgroundColor, // Colore di sfondo
                  foregroundColor: buttonTextColor, // Colore del testo
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0), // Bordi quadrati
                  ),
                ),
                child: Text(
                  'Aggiungi riga',
                  style: TextStyle(color: buttonTextColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}