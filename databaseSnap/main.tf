resource "aws_db_snapshot" "test" {
  db_instance_identifier = data.aws_ssm_parameter.db_id_parameter.value
  db_snapshot_identifier = "flashsnapshotv2"
}