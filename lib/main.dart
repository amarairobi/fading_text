import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;
  Color _textColor = Colors.blueGrey;

  void changeTheme(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  void changeTextColor(Color color) {
    setState(() {
      _textColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
      ),
      themeMode: _themeMode,
      debugShowCheckedModeBanner: false,
      home: FirstScreen(
        themeMode: _themeMode,
        changeTheme: changeTheme,
        textColor: _textColor,
        changeTextColor: changeTextColor,
      ),
    );
  }
}

class FirstScreen extends StatefulWidget {
  final ThemeMode themeMode;
  final Function(ThemeMode) changeTheme;
  final Color textColor;
  final Function(Color) changeTextColor;

  const FirstScreen({
    Key? key,
    required this.themeMode,
    required this.changeTheme,
    required this.textColor,
    required this.changeTextColor,
  }) : super(key: key);

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pick a color'),
          content: SingleChildScrollView(
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                Colors.red.shade900,
                Colors.pinkAccent,
                Colors.purple,
                Colors.deepPurple,
                Colors.indigo,
                Colors.brown,
                Colors.blue.shade100,
                Colors.cyan.shade300,
                Colors.teal,
                Colors.green,
                Colors.lightGreen,
                Colors.lime,
                Colors.yellow,
                Colors.amber,
                Colors.orange.shade800,
                Colors.deepOrangeAccent.shade400,
                Colors.black,
                Colors.white,
              ].map((color) {
                return GestureDetector(
                  onTap: () {
                    widget.changeTextColor(color);
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey,
                        width: 2,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fading Text Animation'),
        actions: [
          IconButton(
            icon: Icon(Icons.palette),
            onPressed: _showColorPicker,
            tooltip: 'Change the text color!',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
          
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [
                FadingTextAnimation(
                  themeMode: widget.themeMode,
                  changeTheme: widget.changeTheme,
                  textColor: widget.textColor,
                  duration: 3,
                  animationType: '',
                ),
                FadingTextAnimation(
                  themeMode: widget.themeMode,
                  changeTheme: widget.changeTheme,
                  textColor: widget.textColor,
                  duration: 1,
                  animationType: '',
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildPageIndicator(0),
                SizedBox(width: 8),
                _buildPageIndicator(1),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildPageIndicator(int index) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentPage == index
            ? Theme.of(context).primaryColor
            : Colors.grey,
      ),
    );
  }
}
class FadingTextAnimation extends StatefulWidget {
  final ThemeMode themeMode;
  final Function(ThemeMode) changeTheme;
  final Color textColor;
  final int duration;
  final String animationType;

  const FadingTextAnimation({
    Key? key,
    required this.themeMode,
    required this.changeTheme,
    required this.textColor,
    required this.duration,
    required this.animationType,
  }) : super(key: key);

  @override
  _FadingTextAnimationState createState() => _FadingTextAnimationState();
}
class _FadingTextAnimationState extends State<FadingTextAnimation> {
  bool _isVisible = true;

  void toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.animationType,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Duration: ${widget.duration} second${widget.duration > 1 ? 's' : ''}',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 40),
          AnimatedOpacity(
            opacity: _isVisible ? 1.0 : 0.0,
            duration: Duration(seconds: widget.duration),
            child: Text(
              'I am using dart to fade text!',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: widget.textColor,
              ),
            ),
            curve: Curves.easeInOut,
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: toggleVisibility,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.play_arrow),
                const SizedBox(width: 9),
                Text('Toggle Animation!'),
              ],
            ),
          ),
          const SizedBox(height: 60),
          Text(
            'Light/Dark Mode',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.themeMode == ThemeMode.dark
                    ? Icons.nightlight_round
                    : Icons.wb_sunny,
                size: 30,
              ),
              const SizedBox(width: 10),
              Switch(
                value: widget.themeMode == ThemeMode.dark,
                onChanged: (value) {
                  widget.changeTheme(
                    value ? ThemeMode.dark : ThemeMode.light,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}