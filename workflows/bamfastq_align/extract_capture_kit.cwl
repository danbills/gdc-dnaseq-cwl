#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: SchemaDefRequirement
    types:
      - $import: ../../tools/capture_kit.yml

inputs:
  - id: bioclient_config
    type: File
  - id: capture_kit_set
    type: ../../tools/capture_kit.yml#capture_kit_set

outputs:
  - id: output
    type: ../../tools/capture_kit.yml#capture_kit_set
    outputSource: emit_capture_kit/output

steps:
  - id: extract_capture_kit_bait
    run: ../../tools/bio_client_download.cwl
    in:
      - id: config-file
        source: bioclient_config
      - id: download_handle
        source: capture_kit_set
        valueFrom: $(self.capture_kit_bait_uuid)
    out:
      - id: output

  - id: extract_capture_kit_target
    run: ../../tools/bio_client_download.cwl
    in:
      - id: config-file
        source: bioclient_config
      - id: download_handle
        source: capture_kit_set
        valueFrom: $(self.capture_kit_target_uuid)
    out:
      - id: output

  - id: emit_capture_kit
    run: ../../tools/emit_capture_kit_file.cwl
    in:
      - id: capture_kit_bait_file
        source: extract_capture_kit_bait/output
      - id: capture_kit_target_file
        source: extract_capture_kit_target/output
      - id: capture_kit_set
        source: capture_kit_set
    out:
      - id: output
