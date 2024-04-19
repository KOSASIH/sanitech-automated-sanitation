provider "aws" {
  region = "us-east-1"
}

resource "aws_glue_catalog_database" "sanitech_database" {
  name = "sanitech_database"
}

resource "aws_glue_job" "sanitech_data_processing" {
  name            = "sanitech_data_processing"
  description     = "Process and transform data for SaniTech"
  role_arn        = aws_iam_role.sanitech_glue.arn
  glue_version    = "2.0"
  max_retries     = 2
  timeout         = 60
  worker_type     = "G.1X"
  number_of_workers = 2

  command {
    script_location = "s3://sanitech-bucket/scripts/data_processing.py"
    python_version  = "3"
  }

  default_arguments = {
    "--database" = aws_glue_catalog_database.sanitech_database.name
    "--job-bookmark-option" = "job-bookmark-enable"
  }

  connections = [aws_glue_connection.sanitech_connection.name]
}

resource "aws_glue_connection" "sanitech_connection" {
  name = "sanitech_connection"
  connection_properties = {
    "JDBC_CONNECTION_URL" = "jdbc:postgresql://sanitech-db.cluster-1234567890.us-east-1.rds.amazonaws.com:5432/sanitech_db"
    "PARENT_URL" = "https://your-jdbc-driver-url.com"
    "USERNAME" = "sanitech_user"
    "PASSWORD" = "sanitech_password"
  }
  connection_type = "JDBC"
  database_name = "sanitech_db"
  extra_jars_path = "s3://sanitech-bucket/jars/postgresql-42.2.23.jar"
}

resource "aws_iam_role" "sanitech_glue" {
  name = "sanitech_glue"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "glue.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "sanitech_glue_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
  role       = aws_iam_role.sanitech_glue.name
}
