import 'package:bloc/bloc.dart';

import 'states.dart';

class NewTasksCubit extends Cubit<TaskStates> {
  NewTasksCubit() : super(TaskInitialState());
}
