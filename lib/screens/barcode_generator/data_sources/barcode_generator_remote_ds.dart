import '../../../core/abstracts/response_abs.dart';
import '../../../core/platform/network_manager.dart';
import '../../../core/util/parser.dart';
import '../interfaces/barcode_generator_data_source_interface.dart';
import 'barcode_generator_local_ds.dart';

class BarcodeGeneratorDataSource implements BarcodeGeneratorDataSourceInterface {
  final BarcodeGeneratorDataSource localDataSource = BarcodeGeneratorDataSource();
  final NetworkManager networkManager = NetworkManager();

  BarcodeGeneratorDataSource();

}
