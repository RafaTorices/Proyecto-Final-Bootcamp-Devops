terraform {
  backend "gcs" {
    bucket      = "botdemo-yndvq-tfstate"
    prefix      = "terraform/state"
    credentials = "credentials_triangleapp_dev.json"
  }
}
