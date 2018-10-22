provider "random" {
  version = "~> 1.0"
}

terraform {
  backend "s3" {
    key = "test_toolbox/<%=state_file_name%>.tfstate"
  }
}

resource "random_pet" "some_name" {
  length = 4
}
