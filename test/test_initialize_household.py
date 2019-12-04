import pandas as pd
import pytest


def test_household_table_match(output_households_initialize_households, input_households):
    common_columns = list(set(output_households_initialize_households.columns) &
                          set(input_households.columns))
    pd.testing.assert_frame_equal(input_households[common_columns],
                                  output_households_initialize_households[common_columns],
                                  check_exact=True)


def test_person_table_match(output_persons_initialize_households, input_persons):
    common_columns = list(set(output_persons_initialize_households.columns) &
                          set(input_persons.columns))
    pd.testing.assert_frame_equal(input_persons[common_columns],
                                  output_persons_initialize_households[common_columns],
                                  check_exact=True)


def test_new_household_columns_exist(output_households_initialize_households, annotate_households):
    columns = set(annotate_households[annotate_households['Target'].str[0] != '_']['Target'])
    assert columns.issubset(output_households_initialize_households.columns)


def test_new_person_tables_exist(output_persons_initialize_households, annotate_persons, annotate_persons_after_hh):
    columns = set(pd.concat([
        annotate_persons[annotate_persons['Target'].str[0] != '_']['Target'],
        annotate_persons_after_hh[annotate_persons_after_hh['Target'].str[0] != '_']['Target']]
    ).drop_duplicates())

    assert columns.issubset(output_persons_initialize_households.columns)
