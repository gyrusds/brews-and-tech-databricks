data "databricks_spark_version" "latest" {}
data "databricks_node_type" "smallest" {
  local_disk = true
}

resource "databricks_notebook" "this" {
  path           = "/hello_world"
  language       = "PYTHON"
  content_base64 = filebase64("${path.module}/../notebooks/hello_world.py")
}

resource "databricks_job" "this" {
  name = "Terraform Hello World Job"

  task {
    task_key = "task1"

    notebook_task {
      notebook_path = databricks_notebook.this.path
    }

    new_cluster {
      num_workers   = 1
      spark_version = data.databricks_spark_version.latest.id
      node_type_id  = data.databricks_node_type.smallest.id
    }
  }
}
