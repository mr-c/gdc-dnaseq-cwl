#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: ubuntu:xenial-20161010
  - class: InlineJavascriptRequirement

class: CommandLineTool

inputs:
  - id: INPUT
    type: File

outputs:
  []

arguments:
  - valueFrom: $(inputs.INPUT.basename)
    position: 0

baseCommand: [echo]
