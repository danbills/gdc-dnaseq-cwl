#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/fastqc:a285d4ab748fa11e6029ad1019ea645ed2b1657e5d49c850a322fdf4b402c1b9
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    coresMin: $(inputs.threads)
    coresMax: $(inputs.threads)
    ramMin: 5000
    ramMax: 5000
    tmpdirMin: 50
    tmpdirMax: 50
    outdirMin: 5
    outdirMax: 5

class: CommandLineTool

inputs:
  - id: adapters
    type: ["null", File]
    inputBinding:
      prefix: --adapters

  - id: casava
    type: boolean
    default: false
    inputBinding:
      prefix: --casava

  - id: contaminants
    type: ["null", File]
    inputBinding:
      prefix: --contaminants

  - id: dir
    type: string
    default: .
    inputBinding:
      prefix: --dir

  - id: extract
    type: boolean
    default: false
    inputBinding:
      prefix: --extract

  - id: format
    type: string
    default: fastq
    inputBinding:
      prefix: --format

  - id: INPUT
    type: File
    format: "edam:format_2182"
    inputBinding:
      position: 99

  - id: kmers
    type: ["null", File]
    inputBinding:
      prefix: --kmers

  - id: limits
    type: ["null", File]
    inputBinding:
      prefix: --limits

  - id: nano
    type: boolean
    default: false
    inputBinding:
      prefix: --nano

  - id: noextract
    type: boolean
    default: true
    inputBinding:
      prefix: --noextract

  - id: nofilter
    type: boolean
    default: false
    inputBinding:
      prefix: --nofilter

  - id: nogroup
    type: boolean
    default: false
    inputBinding:
      prefix: --nogroup

  - id: outdir
    type: string
    default: .
    inputBinding:
      prefix: --outdir

  - id: quiet
    type: boolean
    default: false
    inputBinding:
      prefix: --quiet

  - id: threads
    type: long
    default: 1
    inputBinding:
      prefix: --threads

outputs:
  - id: OUTPUT
    type: File
    outputBinding:
      glob: |
        ${
          function endsWith(str, suffix) {
            return str.indexOf(suffix, str.length - suffix.length) !== -1;
          }

          var filename = inputs.INPUT.nameroot;

          if ( endsWith(filename, '.fq') ) {
            var nameroot = filename.slice(0,-3);
          }
          else if ( endsWith(nameroot, '.fastq') ) {
            var nameroot = filename.slice(0,-6);
          }
          else {
            var nameroot = filename;
          }

          var output = nameroot +"_fastqc.zip";
          return output
        }
          
baseCommand: [/usr/local/FastQC/fastqc]
