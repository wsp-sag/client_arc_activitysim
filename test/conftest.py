import os

import pandas as pd
import pytest


@pytest.fixture(scope='session')
def input_h5_file():
    return os.path.join('data', 'arc_asim.h5')


@pytest.fixture(scope='session')
def output_pipeline():
    return os.path.join('output', 'pipeline.h5')


@pytest.fixture(scope='session')
def validation_data_path():
    return os.path.join('test', 'data', 'validation')


@pytest.fixture(scope='session')
def input_land_use(input_h5_file):
    return pd.read_hdf(input_h5_file, 'land_use_taz')


@pytest.fixture(scope='session')
def output_land_use(output_pipeline):
    return pd.read_hdf(output_pipeline, 'land_use/initialize_landuse')


@pytest.fixture(scope='session')
def output_accessibility(output_pipeline):
    return pd.read_hdf(output_pipeline, 'accessibility/compute_accessibility')


@pytest.fixture(scope='session')
def output_accessibility_validation(validation_data_path):
    return pd.read_csv(os.path.join(validation_data_path, 'accessibility.csv'), index_col='TAZ')