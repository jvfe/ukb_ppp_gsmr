process TWOSAMPLEMR {
  """
  Run TwoSampleMR on sumstats data
  """

  label 'process_medium'

  container "jvfe/twosamplemr:0.5.11"

  input:
    tuple val(meta), path(exposure), val(meta2), path(outcome)
    path(reference)

  output:
    tuple val(prefix_full), path("*csv")        , emit: harmonised
    tuple val(prefix_full), path("*md")         , emit: report
    tuple val(prefix_full), path("figure")      , emit: figures

  when:
  task.ext.when == null || task.ext.when

  script:
  prefix = task.ext.prefix ?: meta.id
  prefix2 = task.ext.prefix2 ?: meta2.id
  prefix_full = "${prefix}_${prefix2}"


  """
  run_twosamplemr.R \\
    $prefix \\
    $prefix2 \\
    $exposure \\
    $outcome \\
    $reference
  """
}

