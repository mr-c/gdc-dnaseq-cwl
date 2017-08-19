#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/git-client:239651f2f67d001a2faf7e1f9e1836f5b618c21af388ecafefd21afa17f61778
  - class: InlineJavascriptRequirement
  # - class: EnvVarRequirement
  #   envDef:
  #     - envName: "http_proxy"
  #       envValue: "http://cloud-proxy:3128"
  #     - envName: "https_proxy"
  #       envValue: "http://cloud-proxy:3128"

inputs:
  - id: repo
    type: string
    inputBinding:
      position: 0

outputs:
  - id: output
    type: Directory
    outputBinding:
      glob: |
        ${
          function endsWith(str, suffix) {
            return str.indexOf(suffix, str.length - suffix.length) !== -1;
          }

          function local_basename(path) {
            var basename = path.split(/[\\/]/).pop();
            return basename
          }

          function get_slice_number(file_name) {
            if (endsWith(file_name, '.git')) {
              return -4
            }
            else {
              return 0
            }
          }

          var repo_basename = local_basename(inputs.repo);
          var slice_number = get_slice_number(repo_basename);
          var repo_prefix = repo_basename.slice(0, slice_number);

          return repo_prefix
        }

baseCommand: [git, clone]