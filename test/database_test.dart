import 'package:wallbox_logs/back_layer/model_repos/simulation_repo/user_master/simulation_repo.dart';
import 'package:wallbox_logs/mid_layer/db_models/user_master/user_master_data.dart';

void main() async {
  SimulationRepo<UserMasterData> repo = SimulationRepo('TestRepo');
  repo.preload();

  var michael = UserMasterData(
    tagID: "ABCDEFG",
    prename: "Michael",
    surname: "Mueller",
  );

  await repo.create(michael);

  print(repo.getById("ABCDEFG"));

  michael = michael.copyWith(city: "Kassel");
  repo.update(michael);

  print(repo.getById("ABCDEFG"));
}
