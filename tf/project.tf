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

resource "random_integer" "salt" {
  min = 100000
  max = 999999
}

resource "google_folder" "binauth-demo" {
  display_name = "binauthz-demo"
  parent       = var.parent_folder_id
}


##########################
# Cluster project
##########################
resource "google_project" "binauth-demo-cluster" {
  name                = "binauth-demo-cluster"
  project_id          = "binauth-demo-cluster-${random_integer.salt.result}"
  folder_id           = "folders/${google_folder.binauth-demo.folder_id}"
  billing_account     = var.billing_account
  auto_create_network = false
}

resource "google_project_service" "cluster-project-apis" {
  project = google_project.binauth-demo-cluster.project_id
  count   = length(var.cluster_services)
  service = element(var.cluster_services, count.index)

  disable_dependent_services = true
  disable_on_destroy         = true
}

##########################
# CI/CD Project
##########################
resource "google_project" "binauth-demo-cicd" {
  name                = "binauth-demo-cicd"
  project_id          = "binauth-demo-cicd-${random_integer.salt.result}"
  folder_id           = "folders/${google_folder.binauth-demo.folder_id}"
  billing_account     = var.billing_account
  auto_create_network = false
}

resource "google_project_service" "cicd-project-apis" {
  project = google_project.binauth-demo-cicd.project_id
  count   = length(var.cicd_services)
  service = element(var.cicd_services, count.index)

  disable_dependent_services = true
  disable_on_destroy         = true
}
