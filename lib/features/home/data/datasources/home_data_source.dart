import 'package:damilva/features/home/data/models/home_remote_entity.dart';

abstract class HomeDataSourceContract {
  Future<HomeRemoteEntity> getHome();
}
