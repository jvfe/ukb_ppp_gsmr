process R_MERGE {
  """
  Merge exposure and reference sumstats first
  """

  label 'process_medium'
  tag "format_sumstats"

  container "juliaapolonio/mungesumstats:v1"

  input:
    tuple val(meta), path(exposure)
    path(ref_sumstats)

  output:
    tuple val(meta), path("*_merged.txt"), emit: merged

  when:
  task.ext.when == null || task.ext.when

  script:
  prefix = task.ext.prefix ?: "${meta.id}"

  """
  format_sumstats.R \\
    $prefix \\
    $exposure \\
    $ref_sumstats
  """
}

