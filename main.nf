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

include { GCTA_GSMR } from "./modules/local/gcta_gsmr/gsmr.nf"
include { TWOSAMPLEMR } from "./modules/local/twosamplemr/main.nf"
include { PARSE_REPORT } from "./modules/local/parse_report//main.nf"


/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    RUN MAIN WORKFLOW
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/


workflow {

    outcomes = Channel.fromSamplesheet("outcomes")
    exposures = Channel.fromSamplesheet("exposures")

    reference = Channel.fromPath("${params.reference}/*")
    reference
        .map { it -> it.getBaseName() }
        .unique()
        .collectFile(name: "gsmr.input.txt", newLine:true)
        .collect()
        .set { ref_file }
    reference.collect().set { collected_ref }

    twosamplemr_reference = file(params.twosmr_ref)

    exposures.combine(outcomes).set{ combinations }

    if (!params.skip_gsmr) {
        GCTA_GSMR (
            combinations,
            collected_ref,
            ref_file
        )
    }

    if (!params.skip_2smr) {
        TWOSAMPLEMR (
            combinations,
            twosamplemr_reference
        )
        PARSE_REPORT (
            TWOSAMPLEMR.out.report
        )
    }
}
