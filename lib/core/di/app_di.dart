import 'package:damilva/data/di/data_di.dart';
import 'package:damilva/domain/di/domain_di.dart';
import 'package:damilva/presentation/di/presentation_di.dart';

Future<void> init() async {
  await dataInitDi();
  await domainInitDi();
  await presentationInitDi();
}
