process PARSE_REPORT {
  """
  Parse TwoSampleMR reports into CSV tables
  """

  label 'process_medium'

  container "jvfe/parse_2mr_report:0.1.0"

  input:
    tuple val(meta), path(report)

  output:
    tuple val(meta), path("*_metrics.csv")      , emit: metrics

  when:
  task.ext.when == null || task.ext.when

  script:
  prefix = task.ext.prefix ?: meta

  """
  process_twosamplemr_reports.py \\
    $report \\
    $prefix
  """
}

