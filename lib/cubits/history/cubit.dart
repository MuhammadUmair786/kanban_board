import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization/localization.dart';

import '../../localization/local_keys.dart';
import '../../models/task_model.dart';
import '../../utils/task_utils.dart';

part 'state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit() : super(HistoryLoading()) {
    loadTasks();
  }

  Future<void> loadTasks() async {
    emit(HistoryLoading());
    try {
      List<TaskModel> allTasks = getTasks();
      emit(HistoryLoaded(allTasks));
    } catch (e) {
      emit(HistoryError(somethingWentWrongLK.i18n()));
    }
  }

  void searchAndFilterTasks({String? searchText, String? filterdBoardId}) {
    emit(HistoryLoading());

    try {
      List<TaskModel> allTasks = getTasks();
      List<TaskModel> filteredTasks = filterdBoardId != null
          ? allTasks.where((task) => task.boardId == filterdBoardId).toList()
          : allTasks;
      if (searchText != null && searchText.isNotEmpty) {
        filteredTasks = filteredTasks
            .where(
              (task) =>
                  task.title.toLowerCase().contains(searchText.toLowerCase()) ||
                  task.description
                      .toLowerCase()
                      .contains(searchText.toLowerCase()),
            )
            .toList();
      }
      emit(HistoryLoaded(filteredTasks));
    } catch (e) {
      emit(HistoryError(filterSearchFailureLK.i18n()));
    }
  }
}
