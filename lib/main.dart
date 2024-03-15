import 'package:flutter/material.dart';
import 'logic.dart';

void main() {
  runApp(const MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
  ));
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController textarea = TextEditingController();
  String formattedOutput = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                color: Colors.black,
                width: 1,
              )),
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              width: 300,
              height: 400,
              child: TextField(
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'spacemono',
                ),
                controller: textarea,
                keyboardType: TextInputType.multiline,
                maxLines: 20,
                decoration: const InputDecoration(
                  hintText: "Enter SQL Code",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            width: 100,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  formattedOutput = '';
                  String outputText = textarea.text;
                  List<ColumnModel> columns = wordModelling(outputText);
                  List<String> tableNames = returnTableName2(outputText);

                  //testing
                  print(tableNames);

                  int maxNameLength = 0;
                  int maxDataTypeLength = 0;

                  //finding maximum length
                  for (ColumnModel columnModel in columns) {
                    if (columnModel.name.length < maxNameLength) {
                      continue;
                    } else if (columnModel.name.length > maxNameLength) {
                      maxNameLength = columnModel.name.length;
                    }

                    if (columnModel.dataType.length < maxDataTypeLength) {
                      continue;
                    } else if (columnModel.dataType.length >
                        maxDataTypeLength) {
                      maxDataTypeLength = columnModel.dataType.length;
                    }
                  }

                  formattedOutput += '${tableNames[0]} (\n';
                  int i = 0;
                  while (tableNames.length > i) {
                    for (ColumnModel column in columns) {
                      if (column.name.length < maxNameLength) {
                        column.name +=
                            ' '.padRight(maxNameLength - column.name.length);
                      }
                      if (column.dataType.length < maxDataTypeLength) {
                        column.dataType += ' '.padRight(
                            maxDataTypeLength - column.dataType.length);
                      }
                      if (column.option.isEmpty) {
                        if (column.dataType == columns.last.dataType) {
                          formattedOutput +=
                              '   ${column.name} ${column.dataType.toUpperCase()}\n);\n\n';
                          if (i + 1 >= tableNames.length) {
                            break;
                          }
                          formattedOutput += '${tableNames[++i]} (\n';
                        } else {
                          formattedOutput +=
                              '   ${column.name} ${column.dataType.toUpperCase()},\n';
                        }
                      } else if (column.option == columns.last.option) {
                        formattedOutput +=
                            '   ${column.name} ${column.dataType.toUpperCase()} ${column.option.toUpperCase()}\n';
                      } else {
                        formattedOutput +=
                            '   ${column.name} ${column.dataType.toUpperCase()} ${column.option.toUpperCase()},\n';
                      }
                    }
                    i++;
                  }
                });
              },
              child: const Text("Submit"),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(10),
              width: 300,
              height: 400,
              decoration: BoxDecoration(
                  border: Border.all(
                color: Colors.black,
                width: 1,
              )),
              child: SelectableText(
                formattedOutput,
                style: const TextStyle(fontFamily: 'spacemono'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
