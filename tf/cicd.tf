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


##### Artifact Repo

resource "google_artifact_registry_repository" "central-repo" {
  provider      = google-beta
  project       = google_project.binauth-demo-cicd.project_id
  location      = var.region
  repository_id = "central-repo"

  description = "Demo Repository"
  format      = "DOCKER"
}

##### Bin Auth Attestor




## Create the KMS Keyring
resource "google_kms_key_ring" "keyring" {
  project  = google_project.binauth-demo-cicd.project_id
  name     = "${var.prefix}-attestor-key-ring"
  location = "global"
}

## Create the attestation key
resource "google_kms_crypto_key" "attestor-crypto-key" {
  name     = "${var.prefix}-attestor-key-1"
  key_ring = google_kms_key_ring.keyring.id
  purpose  = "ASYMMETRIC_SIGN"

  version_template {
    algorithm = "RSA_SIGN_PKCS1_4096_SHA512"
  }

  lifecycle {
    prevent_destroy = true
  }
}

data "google_kms_crypto_key_version" "attestor-key-version" {
  crypto_key = google_kms_crypto_key.attestor-crypto-key.id
}

resource "google_binary_authorization_attestor" "attestor" {
  project = google_project.binauth-demo-cicd.project_id
  name    = "demo-attestor"
  attestation_authority_note {
    note_reference = google_container_analysis_note.note.name
    public_keys {
      id = data.google_kms_crypto_key_version.attestor-key-version.id
      pkix_public_key {
        public_key_pem      = data.google_kms_crypto_key_version.attestor-key-version.public_key[0].pem
        signature_algorithm = data.google_kms_crypto_key_version.attestor-key-version.public_key[0].algorithm
      }
    }
  }
}


#### Vulnerability Analysis Note
resource "google_container_analysis_note" "note" {
  project = google_project.binauth-demo-cicd.project_id
  name    = "test-attestor-note"
  attestation_authority {
    hint {
      human_readable_name = "Attestor Note"
    }
  }
}
