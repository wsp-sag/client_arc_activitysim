###
#
# A sample of tests to ensure the accessibilities
# table is being computed correctly.
#

import pandas as pd


def test_compute_accessibilty(output_accessibility, output_accessibility_validation):
    pd.testing.assert_frame_equal(output_accessibility, output_accessibility_validation)
