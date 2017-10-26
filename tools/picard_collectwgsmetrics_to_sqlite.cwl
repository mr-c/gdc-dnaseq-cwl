#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/picard_metrics_sqlite:bbb809fe71a61233801e376068c734539ee58e080d704c6ddc759e24ec59eaaf
  - class: InlineJavascriptRequirement

class: CommandLineTool

inputs:
  - id: bam
    type: string
    inputBinding:
      prefix: --bam

  - id: fasta
    type: string
    inputBinding:
      prefix: --fasta

  - id: input_state
    type: string
    inputBinding:
      prefix: --input_state

  - id: metric_path
    type: File
    inputBinding:
      prefix: --metric_path

  - id: task_uuid
    type: string
    inputBinding:
      prefix: --task_uuid

outputs:
  - id: log
    type: File
    outputBinding:
      glob: $(inputs.task_uuid+"_picard_CollectWgsMetrics.log")

  - id: sqlite
    type: File
    outputBinding:
      glob: $(inputs.task_uuid + ".db")

baseCommand: [/usr/local/bin/picard_metrics_sqlite, --metric_name, CollectWgsMetrics]
