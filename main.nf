nextflow.enable.dsl = 2
/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    INPUTS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/


// nextflow run . \
// --exposures exposures.csv \
// --outcomes outcomes.csv \
// --reference eur_papapa/ \
// --ref_sumstats pgd_papa.csv \

include { fromSamplesheet; validateParameters } from 'plugin/nf-validation'

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT MODULES/SUBWORKFLOWS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

include { R_MERGE } from "./modules/local/r_merge/rscript_format.nf"
include { GCTA_GSMR } from "./modules/local/gcta_gsmr/gsmr.nf"


/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    RUN MAIN WORKFLOW
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/


workflow {

    // exposures, outcomes
    outcomes = Channel.fromSamplesheet("outcomes")
    exposures = Channel.fromSamplesheet("exposures")
    // banco de dados -> arquivo de texto com os filenames
    reference = Channel.fromPath("${params.reference}/*")
    reference
        .map { it -> it.getBaseName() }
        .unique()
        .collectFile(name: "gsmr.input.txt", newLine:true)
        .collect()
        .set { ref_file }
    reference.collect().set { collected_ref }
    // inner join no script do r
    ref_sumstats = file(params.ref_sumstats)
    ref_file.dump(tag: 'data')
    collected_ref.dump(tag: 'data')

    R_MERGE (
        exposures,
        ref_sumstats
    )

    R_MERGE.out.merged.dump(tag: 'data')

    R_MERGE.out.merged.combine(outcomes).set{ combinations }

    GCTA_GSMR (
        combinations,
        collected_ref,
        ref_file
    )
}
