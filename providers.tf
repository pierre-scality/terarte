terraform {
        required_version = "= 1.2.2"

        required_providers {
                aws = {
                        source  = "hashicorp/aws"
                        version = "~> 4.18.0"
                }

                null = {
                        source  = "hashicorp/null"
                        version = "~> 2.1.2"
                }

                dns = {
                        source  = "hashicorp/dns"
                        version  = "~> 2.2.0"
                }
        }
}

provider aws {
	region  = var.region
	# profile = "default"
	# shared_credentials_files = [pathexpand("~/.aws/credentials")]
}
