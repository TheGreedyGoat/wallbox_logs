import 'package:wallbox_logs/back_layer/model_repos/simulation_repo/user_master/simulation_repo.dart';
import 'package:wallbox_logs/mid_layer/services/user_master/user_master_data.dart';

void main() async {
  SimulationRepo<UserMasterData> repo = SimulationRepo('TestRepo');
  repo.preload();
  await repo.clear();
  String id = 'ABCDEFG';
  String id2 = 'djksandjasnd';
  var michael = UserMasterData(
    tagID: id,
    prename: 'Michael',
    surname: 'M',
  );

  await repo.create(michael);

  // print(await repo.getAll());

  michael = michael.copyWith(city: 'Kassel');
  repo.update(michael);
  var pauli = UserMasterData(
    tagID: id2,
    prename: 'Pauli',
    surname: 'Paule',
  );

  repo.create(pauli);

  // print(await repo.getAll());
  repo.delete(id, () => true);
  // print(await repo.getAll());
}
