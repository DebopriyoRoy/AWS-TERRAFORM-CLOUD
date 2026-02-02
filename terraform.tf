terraform {
  required_providers {
    http = {
      source  = "hashicorp/http"
      version = "3.5.0"
    }
    
    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.82.1, <6.0.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "4.1.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.5.3"
    }

  }
}

## when running the REMOTE BACKEND we need to ACTIVATE/UN-COMMENT this part

/*terraform {
 backend "remote" {
    hostname = "app.terraform.io"
    organization = "Personal-Terraform-cloud"

    workspaces {
      name = "my-aws-app"
    }
  }
}*/

provider "http" {
  # Configuration options
}

provider "random" {
  # Configuration options
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Environment = terraform.workspace
    }
  }
}
provider "tls" {
  # Configuration options
}
provider "local" {
  # Configuration options

}
