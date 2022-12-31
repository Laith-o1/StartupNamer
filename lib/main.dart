import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({super.key});

  @override
  State<RandomWords> createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pop();
        controller.reset();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};
  final _biggerFont = const TextStyle(fontSize: 18);

  _pushsaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          final tiles = _saved.map(
            (pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
                trailing: const Icon(
                  Icons.done,
                  color: Colors.green,
                  semanticLabel: 'حذف',
                ),
              );
            },
          );

          final divided = tiles.isNotEmpty
              ? ListTile.divideTiles(
                  context: context,
                  tiles: tiles,
                ).toList()
              : <Widget>[];

          return Scaffold(
            appBar: AppBar(
              title: const Text('Saved Suggestions'),
              centerTitle: true,
              backgroundColor: Colors.red[200],
            ),
            body: ListView(children: divided),
          );
        },
      ), // ...to here.
    );
  }

  @override
  Widget build(BuildContext context) {
    // final wordpair=WordPair.random();
    return Scaffold(
        appBar: AppBar(
          title: const Text('قائمة الكلمات'),
          centerTitle: true,
          backgroundColor: Colors.red[200],
          actions: [
            IconButton(
              onPressed: (() {
                _pushsaved();
              }),
              icon: const Icon(Icons.list),
              tooltip: 'Saved Suggestions',
            ),
          ],
        ),
        body: Center(
          child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemBuilder: ((context, i) {
                if (i.isOdd) return const Divider();

                final index = i ~/ 2;
                if (index >= _suggestions.length) {
                  _suggestions.addAll(generateWordPairs().take(10)); /*4*/
                }

                final alreadySaved = _saved.contains(_suggestions[index]);
                return ListTile(
                  title: Text(
                    _suggestions[index].asPascalCase,
                    style: _biggerFont,
                  ),
                  trailing: Icon(
                      alreadySaved ? Icons.favorite : Icons.favorite_border,
                      color: alreadySaved ? Colors.red : null,
                      semanticLabel:
                          alreadySaved ? 'قم بحذفها من القائمة' : 'حفظ'),
                  onTap: () {
                    setState(() {
                      if (alreadySaved) {
                        _saved.remove(_suggestions[index]);
                      } else {
                        _saved.add(_suggestions[index]);
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) => Dialog(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Lottie.network(
                                          "https://assets8.lottiefiles.com/packages/lf20_lk80fpsm.json",
                                          controller: controller,
                                          repeat: false,
                                          onLoaded: (composition) {
                                        controller
                                          ..duration = composition.duration
                                          ..forward();
                                      }),
                                      const Text(
                                        'Success',
                                        style: TextStyle(fontSize: 24),
                                      ),
                                      const SizedBox(
                                        height: 16,
                                      )
                                    ],
                                  ),
                                ));
                      }
                    });
                  },
                );
              })),
          // child:Text(wordpair.asPascalCase),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final wordpair = WordPair.random();
    return Scaffold(
        body: Center(
      child: Text(wordpair.asPascalCase),
    ));
  }
}
