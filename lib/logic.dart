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
        tableName = capitalizeFirstTwoWords(tableName);
        tableStatements.add(tableName);
      }
    }
  }

  return tableStatements;
}

String capitalizeFirstTwoWords(String text) {
  List<String> words = text.split(' ');
  for (int i = 0; i < words.length; i++) {
    words[i] = words[i].toUpperCase();
    if (i == 1) break;
  }
  return words.join(' ');
}

List<ColumnModel> wordModelling(String input) {
  List<ColumnModel> columns = [];
  List<String> statements = input.trim().split(';');

  for (String statement in statements) {
    if (statement.isNotEmpty) {
      int startIndex = statement.indexOf('(');

      int endIndex = statement.lastIndexOf(')');
      const doubleSpace = '  ';

      String columnDefinitions = statement.substring(startIndex + 1, endIndex);
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
          columns.add(ColumnModel(name, dataType, option));
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

            // print(args);
            // print(columnData);
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
