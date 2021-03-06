#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

inputs:
  - id: ini_section
    type: string
  - id: input_signpost_id
    type: string
  - id: postgres_creds_path
    type: File
  - id: repo
    type: string
  - id: repo_hash
    type: string
  - id: s3_url
    type: ["null", string]
  - id: status
    type: string
  - id: table_name
    type: string
  - id: uuid
    type: string

outputs:
  - id: token
    type: File
    outputSource: sqlite_to_postgres/log

steps:
  - id: queue_status
    run: ../../tools/queue_status.cwl
    in:
      - id: input_signpost_id
        source: input_signpost_id
      - id: repo
        source: repo
      - id: repo_hash
        source: repo_hash
      - id: s3_url
        source: s3_url
      - id: status
        source: status
      - id: table_name
        source: table_name
      - id: uuid
        source: uuid
    out:
      - id: log
      - id: sqlite

  - id: sqlite_to_postgres
    run: ../../tools/sqlite_to_postgres_hirate.cwl
    in:
      - id: ini_section
        source: ini_section
      - id: postgres_creds_path
        source: postgres_creds_path
      - id: source_sqlite_path
        source: queue_status/sqlite
      - id: uuid
        source: uuid
    out:
      - id: log
