import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EldenRingPage extends StatefulWidget {
  final bool isDarkTheme;

  const EldenRingPage({super.key, required this.isDarkTheme});

  @override
  EldenRingPageState createState() => EldenRingPageState();
}

class EldenRingPageState extends State<EldenRingPage> {
  List<int> counters = [];
  List<String> runTitles = [];

  @override
  void initState() {
    super.initState();
    loadCounters();
  }

  void loadCounters() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      int numRuns = (prefs.getInt('EldenRing_numRuns') ?? 1);
      runTitles = List.generate(numRuns, (index) => prefs.getString('EldenRing_RunTitle${index + 1}') ?? 'Run ${index + 1}');
      counters = List.generate(numRuns, (index) => (prefs.getInt('EldenRing_Run${index + 1}') ?? 0));
    });
  }

  void incrementCounter(int index) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      counters[index]++;
    });
    prefs.setInt('EldenRing_Run${index + 1}', counters[index]);
  }

  void decrementCounter(int index) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (counters[index] > 0) {
        counters[index]--;
      }
    });
    prefs.setInt('EldenRing_Run${index + 1}', counters[index]);
  }

  void removeRun(int index) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      runTitles.removeAt(index);
      counters.removeAt(index);
    });
    prefs.setInt('EldenRing_numRuns', runTitles.length);
    for (int i = 0; i < runTitles.length; i++) {
      prefs.setInt('EldenRing_Run${i + 1}', counters[i]);
      prefs.setString('EldenRing_RunTitle${i + 1}', runTitles[i]);
    }
  }

  void renameRun(int index, String newName) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      runTitles[index] = newName;
    });
    prefs.setString('EldenRing_RunTitle${index + 1}', newName);
  }

  void addRun() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      runTitles.add('Run ${runTitles.length + 1}');
      counters.add(0);
    });
    prefs.setInt('EldenRing_numRuns', runTitles.length);
    prefs.setInt('EldenRing_Run${runTitles.length}', 0);
    prefs.setString('EldenRing_RunTitle${runTitles.length}', 'Run ${runTitles.length}');
  }

  void showOptionsDialog(int index) {
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
                  showRenameDialog(index);
                },
              ),
              ListTile(
                title: const Text('Elimina'),
                onTap: () {
                  Navigator.of(context).pop();
                  showDeleteConfirmationDialog(index);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void showRenameDialog(int index) {
    TextEditingController controller = TextEditingController(text: runTitles[index]);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Rinomina'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Nuovo nome'),
            maxLength: 21, // Imposta il limite massimo di caratteri
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
                renameRun(index, controller.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showDeleteConfirmationDialog(int index) {
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
                removeRun(index);
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
                padding: const EdgeInsets.symmetric(horizontal: 80.0, vertical: 4.0), // Bordo sui lati destro e sinistro + lati superiore e inferiore
                child: Image.asset(
                  'assets/images/Elden_Ring_logo.png',
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
                itemCount: runTitles.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Row(
                      children: <Widget>[
                        GestureDetector(
                          onLongPress: () => showOptionsDialog(index),
                          child: Expanded(
                            child: Text(
                              runTitles[index],
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: 50, // Imposta una larghezza fissa per il numero
                          child: Text(
                            '${counters[index]}',
                            style: const TextStyle(fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(width: 20), // Spazio fisso
                        Row(
                          children: <Widget>[
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => incrementCounter(index),
                            ),
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () => decrementCounter(index),
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
                onPressed: addRun,
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
