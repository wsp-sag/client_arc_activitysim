###
# Annotate Land Use Test Case
# A sample of tests to ensure the land use
# table is being read correctly.
##
import pandas as pd


def test_land_use_output_format(output_land_use, input_land_use):
    common_columns = list(set(output_land_use.columns) & set(input_land_use.columns))
    pd.testing.assert_frame_equal(input_land_use[common_columns], output_land_use[common_columns])


def test_household_density(output_land_use):
    pd.testing.assert_series_equal(output_land_use['household_density'],
                                   output_land_use['hshld'] / output_land_use['acres'],
                                   check_names=False)


def test_employment_density(output_land_use):
    pd.testing.assert_series_equal(output_land_use['employment_density'],
                                   output_land_use['emp'] / output_land_use['acres'],
                                   check_names=False)


def test_density_index(output_land_use):
    density_index = (output_land_use['household_density'] * output_land_use['employment_density']) /\
                    (output_land_use['household_density'] + output_land_use['employment_density']).clip(lower=1)
    pd.testing.assert_series_equal(output_land_use['density_index'], density_index, check_names=False)
