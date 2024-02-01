terraform {
  backend "s3" {
    bucket = "bucket-eks-terraform-state"
    key    = "triangle-project-state/terraform.tfstate"
    region = "eu-central-1"
  }
}