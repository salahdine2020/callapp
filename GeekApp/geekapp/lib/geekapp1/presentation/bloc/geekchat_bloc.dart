import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'geekchat_event.dart';
part 'geekchat_state.dart';
class GeekchatBloc extends Bloc<GeekchatEvent, GeekchatState> {
  GeekchatBloc() : super(GeekchatInitial());
  @override
  Stream<GeekchatState> mapEventToState(
    GeekchatEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
