class ColumnModel {
  String name;
  String dataType;
  String option;

  ColumnModel(this.name, this.dataType, this.option);
}

List<String> returnTableName2(String input) {
  List<String> tableStatements = [];

  List<String> statements = input.split(';');

  for (String statement in statements) {
    if (statement.trim().isNotEmpty) {
      int endIndex = statement.indexOf('(');
      if (endIndex != -1) {
        String tableName = statement.substring(0, endIndex).trim();

        tableName = capitalizedFirstTwoWords(tableName);
        tableStatements.add(tableName);
      }
    }
  }

  return tableStatements;
}

String capitalizedFirstTwoWords(String input) {
  List<String> combinedLine = [];
  List<String> lines = input.split('\n');
  List<String> words = [];
  String tableStatements = '';

  for (var line in lines) {
    // print(line);
    if (line.startsWith('--')) {
      combinedLine.add(line);
      continue;
    } else if (line.trim().isEmpty) {
      combinedLine.add(line);

      continue;
    } else {
      words = line.split(' ');
      for (int i = 0; i < words.length; i++) {
        words[i] = words[i].toUpperCase();
        if (i == 1) break;
      }
      var combinedWords = '';
      combinedWords = words.join(' ');
      combinedLine.add(combinedWords);
    }
  }
  tableStatements = combinedLine.join('\n');

  return tableStatements;
}

// List<ColumnModel> wordModelling(String input) {
//   List<ColumnModel> columns = [];
//   List<String> statements = input.trim().split(';');

//   for (String statement in statements) {
//     if (statement.isNotEmpty) {
//       int startIndex = statement.indexOf('(');

//       int endIndex = statement.lastIndexOf(')');
//       const doubleSpace = '  ';

//       String columnDefinitions = statement.substring(startIndex + 1, endIndex);

//       columnDefinitions += '\n';

//       final lines = columnDefinitions.split('\n');

//       for (var line in lines) {
//         if (line.contains('--')) {
//           do {
//             line = line.replaceAll(doubleSpace, ' ');
//           } while (line.contains(doubleSpace));
//           line = line.trim();

//           var args = line.split(' ');

//           String name = args[0];
//           String dataType = args[1];
//           String option = '';
//           if (args.length > 2) {
//             option =
//                 line.replaceFirst('$name $dataType', '').trim().toLowerCase();
//             int commaIndex = option.indexOf(',');
//             if (commaIndex != -1) {
//               option = option.replaceRange(
//                   0, commaIndex, option.substring(0, commaIndex).toUpperCase());
//             }
//           }
//           columns.add(ColumnModel(name, dataType.toUpperCase(), option));

//           continue;
//         }
//         final length = line.split(',').length;

//         if (length > 0) {
//           var columnsData = line.split(',');

//           for (var columnData in columnsData) {
//             if (columnData.trim().isEmpty) {
//               continue;
//             }

//             do {
//               columnData = columnData.replaceAll(doubleSpace, ' ');
//             } while (columnData.contains(doubleSpace));
//             columnData = columnData.trim();

//             var args = columnData.split(' ');

//             // print(args);
//             // print(columnData);
//             if (columnData.contains('--')) {
//               String name = args[0];
//               String dataType = args[1];
//               String option = '';
//               if (args.length > 2) {
//                 option = columnData
//                     .replaceFirst('$name $dataType', '')
//                     .trim()
//                     .toLowerCase();
//               }
//               columns.add(ColumnModel(name, dataType, option));
//             } else {
//               if (args.length == 1) {
//                 String name = args[0];
//                 columns.add(ColumnModel(name, '', ''));
//                 continue;
//               }
//               String name = args[0];
//               String dataType = args[1];
//               String option = '';
//               if (args.length > 2) {
//                 option = columnData.replaceFirst('$name $dataType', '').trim();
//               }
//               columns.add(ColumnModel(
//                   name, dataType.toUpperCase(), option.toUpperCase()));
//             }
//           }
//         }
//       }
//     }
//   }

//   return columns;
// }

List<ColumnModel> wordModelling(String input) {
  List<ColumnModel> columns = [];
  List<String> statements = input.trim().split(';');

  for (String statement in statements) {
    if (statement.isNotEmpty) {
      int startIndex = statement.indexOf('(');

      int endIndex = statement.lastIndexOf(')');
      const doubleSpace = '  ';

      String columnDefinitions = statement.substring(startIndex + 1, endIndex);
      columnDefinitions += '\n);';

      // print(columnDefinitions);

      final lines = columnDefinitions.split('\n');

      for (var line in lines) {
        if (line.contains('--')) {
          do {
            line = line.replaceAll(doubleSpace, ' ');
          } while (line.contains(doubleSpace));
          line = line.trim();

          var args = line.split(' ');

          String name = args[0];
          String dataType = args[1];
          String option = '';
          if (args.length > 2) {
            option =
                line.replaceFirst('$name $dataType', '').trim().toLowerCase();
            int commaIndex = option.indexOf(',');
            if (commaIndex != -1) {
              option = option.replaceRange(
                  0, commaIndex, option.substring(0, commaIndex).toUpperCase());
            }
          }
          columns.add(ColumnModel(name, dataType.toUpperCase(), option));

          continue;
        }
        final length = line.split(',').length;

        if (length > 0) {
          var columnsData = line.split(',');

          for (var columnData in columnsData) {
            if (columnData.trim().isEmpty) {
              continue;
            }

            do {
              columnData = columnData.replaceAll(doubleSpace, ' ');
            } while (columnData.contains(doubleSpace));
            columnData = columnData.trim();

            var args = columnData.split(' ');

            if (columnData.contains('--')) {
              String name = args[0];
              String dataType = args[1];
              String option = '';
              if (args.length > 2) {
                option = columnData
                    .replaceFirst('$name $dataType', '')
                    .trim()
                    .toLowerCase();
              }
              columns.add(ColumnModel(name, dataType, option));
            } else {
              if (args.length == 1) {
                String name = args[0];
                columns.add(ColumnModel(name, '', ''));
                continue;
              }
              String name = args[0];
              String dataType = args[1];
              String option = '';
              if (args.length > 2) {
                option = columnData.replaceFirst('$name $dataType', '').trim();
              }
              columns.add(ColumnModel(
                  name, dataType.toUpperCase(), option.toUpperCase()));
            }
          }
        }
      }
    }
  }

  return columns;
}
