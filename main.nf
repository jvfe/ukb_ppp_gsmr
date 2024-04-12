/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    INPUTS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

// exposures, outcomes
exposures = Channel.fromSamplesheet('exposures')
outcomes = Channel.fromSamplesheet('outcomes')
// banco de dados -> arquivo de texto com os filenames
reference = Channel.fromPath("${params.reference}/*")
reference.map { it -> it.getBaseName() }.unique().collectFile(name: "gsmr.input.txt", newLine:true).collect().set { ref_file }
reference.collect().set { collected_ref }
// inner join no script do r
ref_sumstats = file(params.ref_sumstats)


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

    R_MERGE (
        exposures,
        ref_sumstats
    )

    GCTA_GSMR (
        R_LIFT.out.merged,
        collected_ref,
        outcomes,
        ref_file
    )
}
