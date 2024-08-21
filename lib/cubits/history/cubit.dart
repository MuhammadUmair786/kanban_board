import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/task_model.dart';
import '../../utils/task_utils.dart';

part 'state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit() : super(HistoryInitial()) {
    loadTasks();
  }

  Future<void> loadTasks() async {
    emit(HistoryLoading());
    try {
      List<TaskModel> allTasks = getTasks();
      emit(HistoryLoaded(allTasks));
    } catch (e) {
      emit(HistoryError('Failed to load tasks from local storage'));
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
      emit(HistoryError('Failed to filter and search tasks'));
    }
  }
}
