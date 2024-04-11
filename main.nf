/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    CONFIG FILES
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

// exposures
reads = Channel.fromPath("$projectDir/test_data/NPM1_P06748_OID20961_v1_Neurology.tar")
// banco de dados -> arquivo de texto com os filenames
reference = Channel.fromPath("$projectDir/test_data/test_refs/*")
reference.map { it -> it.getBaseName() }.unique().collectFile(name: "gsmr.input.txt", newLine:true).collect().set { ref_file }
reference.collect().set { collected_ref }
// sumstats outcome
outcome = "$projectDir/test_data/SDEP_rsID.txt"
// inner join no script do r
sumstats = file("$projectDir/test_data/MTAG_depression_sumstats_hg38_chr21.txt")


/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT NF-CORE MODULES/SUBWORKFLOWS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

include { UNTAR } from "./modules/nf-core/untar/main.nf"
include { MERGE } from "./modules/local/merge_file/merge_file.nf"
include { R_LIFT } from "./modules/local/r_lift/rscript_format.nf"
include { GCTA_GSMR } from "./modules/local/gcta_gsmr/gsmr.nf"


/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    RUN MAIN WORKFLOW
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/


workflow {

    UNTAR (
        reads
    )

    MERGE (
        UNTAR.out.untar
    )

    R_LIFT (
        MERGE.out.merged,
        sumstats
    )

    GCTA_GSMR (
        R_LIFT.out.lifted,
        collected_ref,
        outcome,
        ref_file
    )
}
