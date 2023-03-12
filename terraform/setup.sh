#!/bin/bash

envsubst < backend.tf.tmpl > backend.tf
envsubst < terraform.tfvars.tmpl > terraform.tfvars

cat backend.tf
cat terraform.tfvars

