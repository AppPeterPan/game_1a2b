import 'package:flutter_bloc/flutter_bloc.dart';

part 'page_state.dart';

class PageCubit extends Cubit<PageState> {
  PageCubit() : super(PageState(pageIdx: 0));

  void toPage(int value) => emit(PageState(pageIdx: value));
}
