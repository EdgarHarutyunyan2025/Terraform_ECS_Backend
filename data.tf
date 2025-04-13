terraform {
  backend "s3" {
    bucket = "task-project-01"
    key    = "back/terraform.tfstate"
    region = "eu-central-1"
  }
}

data "terraform_remote_state" "front" {
  backend = "s3"

  config = {
    bucket = "task-project-01"
    key    = "front/terraform.tfstate"
    region = "eu-central-1"
  }
}
