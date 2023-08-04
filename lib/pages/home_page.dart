import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _index = 0;
  int _correctAnswers = 0;
  bool _result = false;
  int _selectedIndex = -1;

  Map <int, int> macthing = {
    0: 0,
    1: 1,
    2: 2,
  }; 

  List <List> icons = [
    [const Icon(Icons.sports_soccer), const Icon(Icons.sports_tennis), const Icon(Icons.sports_basketball)],
    [
      Container(width: 20, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red,),),
      Container(width: 20, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.blue,),),
      Container(width: 20, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.yellow,),)
    ],

    [
      const Image(image: AssetImage('assets/icons/apple.png'),),
      const Image(image: AssetImage('assets/icons/banana.png'),), 
      const Image(image: AssetImage('assets/icons/mango.png'),)
    ]
  ];

  List<Map<String, dynamic>> questionsWithAnswers = [{
    'question': 'What is my favorite sport?',
    'answers': [
      'Football',
      'Tennis',
      'Basketball'
    ],
  },
  {
    'question': 'What is my favorite color?',
    'answers': [
      'Red',
      'Blue',
      'Yellow'
    ],
  },
  {
    'question': 'What is my favorite fruit?',
    'answers': [
      'Apple',
      'Banana',
      'Mango',
    ],
  }];

  void _reset(){
    setState(() {
      _correctAnswers = 0;
      _result = !_result;
      _index = 0;
      _selectedIndex = -1;
    });
  }

  void _incrementIndex() {
    setState(() {
      if(_index < questionsWithAnswers.length - 1){
        _index++;
      }
      else{
        _result = !_result;
      }
      if(_result && _selectedIndex == -1){
        _index++;
        _result = !_result;
      }
      if(_selectedIndex == -1){
        _index--;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height / 20,
              left: MediaQuery.of(context).size.width / 20,
              right: MediaQuery.of(context).size.width / 20
            ),
            behavior: SnackBarBehavior.floating,
            content: const Text('Please select an answer!'),
          )
        );
      }
      _selectedIndex = -1;
    });
  }

  void _select(int index){
    setState(() {
      _selectedIndex = index;
      if(macthing[_index] == _selectedIndex){
        _correctAnswers++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: const Icon(Icons.arrow_back_ios),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(!_result) ...[
              const SizedBox(
                height: 25,
              ),
              Text(
                questionsWithAnswers[_index]['question'],
                style: const TextStyle(
                  fontSize: 25,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              const Text(
                'Answer the question and gets points:',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text(
                    'Q. ${_index + 1}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    ' of ${questionsWithAnswers.length}',
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  ...List.generate(questionsWithAnswers.length, (i) => Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 1.0),
                      width: MediaQuery.of(context).size.width/questionsWithAnswers.length,
                      child: _index > i ? const LinearProgressIndicator(value: 1, minHeight: 3) : 
                        const LinearProgressIndicator(value: 0, minHeight: 2,),
                    ),
                  )
                  ),
                ],
              ),
              const SizedBox(height: 20,),
              ...List.generate(questionsWithAnswers[_index]['answers'].length, (i) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: InkWell(
                  onTap: () => _select(i),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    decoration: BoxDecoration(
                      color: i == _selectedIndex ? const Color.fromARGB(255, 167, 118, 236) : Colors.white,
                      border: Border.all(color: const Color.fromARGB(255, 167, 118, 236).withOpacity(0.5)),
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        children: [
                          icons[_index][i],
                          const SizedBox(width: 10,),
                          Text(
                            questionsWithAnswers[_index]['answers'][i],
                            style: TextStyle(
                              fontSize: 15,
                              color: i == _selectedIndex ? Colors.white : Colors.black
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 50, left: 20, right: 20),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: FloatingActionButton(
                    onPressed: () => _incrementIndex(),
                    child: const Text('Next'),
                  ),
                ),
              )
            ],
            if(_result) ...[
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 200),
                  child: Column(
                    children: [
                      Image(
                        image: const AssetImage('assets/icons/happy.png'),
                        width: MediaQuery.of(context).size.width / 5,
                      ),
                      const SizedBox(height: 40,),
                      Text(
                        'Your score is $_correctAnswers/${questionsWithAnswers.length}',
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 50,),
                      FloatingActionButton(
                        onPressed: () => _reset(),
                        child: const Icon(Icons.replay),
                      ),
                    ]
                  ),
                ),
              )],
          ]
        ),
      )
    );
  }
}
