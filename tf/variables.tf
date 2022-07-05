# Copyright 2019 Google LLC
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#    http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

variable "billing_account" {

}

variable "prefix" {
  type        = string
  description = "Prefix for resources deployed into the project"
  default     = "test"
}

variable "region" {
  type        = string
  description = "Region to deploy resources to (default europe-west2"
  default     = "europe-west1"
}

variable "parent_folder_id" {
  type        = string
  description = "The parent folder to place the demo resources"
}

variable "cluster_services" {
  default = [
    "container.googleapis.com",
    "binaryauthorization.googleapis.com"
  ]
}

variable "cicd_services" {
  default = [
    "cloudbuild.googleapis.com",
    "artifactregistry.googleapis.com",
    "binaryauthorization.googleapis.com",
    "cloudkms.googleapis.com",
    "containerscanning.googleapis.com",
    "ondemandscanning.googleapis.com",
  ]
}

variable "jfrog_services" {
  default = [
    "cloudbuild.googleapis.com",
    "container.googleapis.com",
  ]
}
