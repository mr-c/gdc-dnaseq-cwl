#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
 - class: InlineJavascriptRequirement
 - class: StepInputExpressionRequirement

inputs:
  - id: aws_config
    type: File
  - id: aws_shared_credentials
    type: File
  - id: bam_signpost_id
    type: string
  - id: endpoint_json
    type: File
  - id: load_bucket
    type: string
  - id: load_s3cfg_section
    type: string
  - id: signpost_base_url
    type: string
  - id: uuid
    type: string

outputs:
  []

steps:
  # EXTRACT
  - id: extract_bam_signpost
    run: ../../tools/get_signpost_json.cwl
    in:
      - id: signpost_id
        source: bam_signpost_id
      - id: base_url
        source: signpost_base_url
    out:
      - id: output

  - id: extract_bam
    run: ../../tools/aws_s3_get_signpost.cwl
    in:
      - id: aws_config
        source: aws_config
      - id: aws_shared_credentials
        source: aws_shared_credentials
      - id: signpost_json
        source: extract_bam_signpost/output
      - id: endpoint_json
        source: endpoint_json
    out:
      - id: output

  # TRANFORM
  - id: transform
    run: ../../tools/md5sum.cwl
    in:
      - id: INPUT
        source: extract_bam/output
    out:
      - id: OUTPUT

  # LOAD
  - id: load_md5sum
    run: ../../tools/aws_s3_put.cwl
    in:
      - id: aws_config
        source: aws_config
      - id: aws_shared_credentials
        source: aws_shared_credentials
      - id: endpoint_json
        source: endpoint_json
      - id: input
        source: transform/OUTPUT
      - id: s3cfg_section
        source: load_s3cfg_section
      - id: s3uri
        source: load_bucket
        valueFrom: $(self + "/" + inputs.uuid + "/")
      - id: uuid
        source: uuid
        valueFrom: null
    out:
      - id: output
