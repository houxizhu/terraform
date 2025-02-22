#!/bin/bash

# aws credentials here
export AWS_ACCESS_KEY_ID="5HITNAKIAZRYROKPKIKE"
export AWS_SECRET_ACCESS_KEY="fA9H3zqpqLT8g9aRaZjNdLTU8nsR7UkD"

terraform init

if [[ $? -eq 0 ]]; then
  cat .terraform.lock.hcl
fi

