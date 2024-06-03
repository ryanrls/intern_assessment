class Filter {
  List<dynamic> filterBySearch(String letter, List<dynamic> todoList) {
    if (letter.trim().isEmpty) {
      return todoList;
    } else {
      final lowerCaseLetter = letter.trim().toLowerCase();

      final filteredList = todoList
          .where((element) =>
              element['title'].toLowerCase().contains(lowerCaseLetter))
          .toList();

      return filteredList;
    }
  }

  List<dynamic> filterByStatus(
      String status, List<dynamic> filterList, List<dynamic> todoList) {
    if (status.isEmpty) {
      return filterList;
    }

    final lowerCaseLetter = status.toLowerCase();

    if (status == 'All') {
      Set set1 = filterList.toSet();
      Set set2 = todoList.toSet();

      Set intersection = set1.intersection(set2);
      return intersection.toList();
    }

    final filterByStatus = todoList
        .where((element) =>
            element['status'].toLowerCase().contains(lowerCaseLetter))
        .toList();

    Set set1 = filterList.toSet();
    Set set2 = filterByStatus.toSet();

    Set intersection = set1.intersection(set2);

    return intersection.toList();
  }

  List<dynamic> filterSearchStatus(
      List<dynamic> filterSearch, List<dynamic> filterStatus) {
    Set set1 = filterSearch.toSet();
    Set set2 = filterStatus.toSet();

    Set intersection = set1.intersection(set2);

    return intersection.toList();
  }

  List<dynamic> sortByDate(List<dynamic> filterList) {
    if (filterList.length <= 1) {
      return filterList;
    }

    filterList.sort((a, b) {
      if (a['due_time'] == null && b['due_time'] == null) {
        return 0;
      } else if (a['due_time'] == null) {
        return 1; // a is null, put a after b
      } else if (b['due_time'] == null) {
        return -1; // b is null, put b after a
      } else {
        return a['due_time'].compareTo(
            b['due_time']); // both dates are not null, compare normally
      }
    });

    filterList.sort((a, b) {
      if (a['due'] == null && b['due'] == null) {
        return 0;
      } else if (a['due'] == null) {
        return 1; // a is null, put a after b
      } else if (b['due'] == null) {
        return -1; // b is null, put b after a
      } else {
        return a['due']
            .compareTo(b['due']); // both dates are not null, compare normally
      }
    });
    return filterList;
  }
}
