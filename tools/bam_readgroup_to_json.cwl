#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/bam_readgroup_to_json:7cb045ba57c027e283fbf42ea566f39b5f4846b1381e69b9e36e32bb978f0c9a
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    coresMin: 1
    coresMax: 1
    ramMin: 1000
    ramMax: 1000
    tmpdirMin: 1
    tmpdirMax: 1
    outdirMin: 1
    outdirMax: 1

class: CommandLineTool

inputs:
  - id: INPUT
    type: File
    format: "edam:format_2572"
    inputBinding:
      prefix: --bam_path

  - id: MODE
    type: string
    default: strict
    inputBinding:
      prefix: --mode

outputs:
  - id: OUTPUT
    format: "edam:format_3464"
    type:
      type: array
      items: File
    outputBinding:
      glob: "*.json"
      outputEval: |
        ${ return self.sort(function(a,b) { return a.location > b.location ? 1 : (a.location < b.location ? -1 : 0) }) }

  - id: log
    type: File
    outputBinding:
      glob: "output.log"

baseCommand: [/usr/local/bin/bam_readgroup_to_json]

$namespaces:
  edam: "http://edamontology.org/"
