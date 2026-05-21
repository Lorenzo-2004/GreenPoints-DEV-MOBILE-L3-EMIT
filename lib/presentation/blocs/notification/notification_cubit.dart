import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/services/notification_service.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationService _service = NotificationService();

  NotificationCubit() : super(NotificationInitial());

  void loadNotifications() {
    emit(NotificationLoading());
    _service.getNotifications().listen((notifications) {
      emit(NotificationLoaded(notifications));
    }, onError: (error) {
      emit(NotificationError(error.toString()));
    });
  }

  Future<void> markAsRead(String id) async {
    await _service.markAsRead(id);
  }

  Future<void> markAllAsRead() async {
    await _service.markAllAsRead();
  }

  Future<int> getUnreadCount() async {
    return await _service.getUnreadCount();
  }
}