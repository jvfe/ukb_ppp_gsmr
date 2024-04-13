process GCTA_GSMR {
    label 'GCTA_GSMR'
    container "quay.io/biocontainers/gcta:1.94.1--h9ee0642_0"

    input: 
    tuple val(meta), path(exposure)
    tuple val(meta2), path(outcome)
    path(reference)
    path(reffile)

    output:
    path "${prefix}_${prefix2}.log", emit: gsmr_log
    path "${prefix}_${prefix2}.gsmr", emit: gsmr_res, optional: true
    path "${prefix}_${prefix2}.eff_plot.gz", emit: gsmr_effplt, optional: true

    script:
    prefix = task.ext.prefix ?: meta.id
    prefix2 = task.ext.prefix2 ?: meta2.id
    """
    if [[ $exposure == *.gz ]]; then
        gunzip "$exposure"
    fi

    echo  "$prefix $exposure" > ${prefix}.txt
    echo "$prefix2 $outcome" > ${prefix2}.txt

    gcta  \
    --mbfile $reffile  \
    --gsmr-file ${prefix}.txt ${prefix2}.txt \
    --gsmr-direction 0   \
    --gsmr-snp-min 1   \
    --diff-freq 0.5   \
    --gwas-thresh 5e-8   \
    --clump-r2 0.05   \
    --heidi-thresh 0.01   \
    --effect-plot   \
    --out "${prefix}_${prefix2}"
    """
}
