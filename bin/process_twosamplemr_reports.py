#!/usr/bin/env python

import sys
import argparse
import pandas as pd
from scipy.stats import false_discovery_control as fdc
from io import StringIO

def parse_args(args=None):
    Description = "Parse TwoSampleMR reports and write metrics table to a CSV file."
    Epilog = "Example usage: python parse_twosamplemr_reports.py <REPORT> <PREFIX>"

    parser = argparse.ArgumentParser(description=Description, epilog=Epilog)
    parser.add_argument("REPORT", help="TwoSampleMR Markdown Report")
    parser.add_argument("PREFIX", help="Name of the report")
    return parser.parse_args(args)


def parse_twosamplemr_reports(report, prefix):

    with open(report) as rep_file:
        metrics_table = rep_file.readlines()[15:21]

    table = (
        pd.read_csv(
            StringIO("".join(metrics_table)),
            sep="|",
            header=0,
            index_col=1,
            skipinitialspace=True,
        )
        .dropna(axis=1, how="all")
        .iloc[1:]
    )

    table["padj"] = fdc(table["pval"].astype(float), method="bh")

    table.to_csv(f"{prefix}_metrics.csv")


def main(args=None):
    args = parse_args(args)
    parse_twosamplemr_reports(args.REPORT, args.PREFIX)


if __name__ == "__main__":
    sys.exit(main())
