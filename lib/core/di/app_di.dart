import 'package:damilva/core/di/data_di.dart';
import 'package:damilva/core/di/domain_di.dart';
import 'package:damilva/core/di/presentation_di.dart';

Future<void> init() async {
  await dataInitDi();
  await domainInitDi();
  await presentationInitDi();
}
