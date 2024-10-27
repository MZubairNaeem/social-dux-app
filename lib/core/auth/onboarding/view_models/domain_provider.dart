import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scp/main.dart';
import 'package:scp/model/domain_model.dart';

final domainProvider = FutureProvider<List<DomainModel>>(
  (ref) async {
    List<DomainModel> domainModel = [];
    try {
      await supabase.from('domains').select('*').then(
        (value) {
          for (var item in value) {
            domainModel.add(DomainModel.fromJson(item));
          }
        },
      );
      return domainModel;
    } catch (e) {
      return domainModel;
    }
  },
);
