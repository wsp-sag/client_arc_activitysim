import os

import pandas as pd
import pytest

def remove_annotation_comments(annotation):
    return annotation[annotation['Description'].str[0] != '#'].copy()


@pytest.fixture(scope='session')
def input_h5_file():
    return os.path.join('data', 'arc_asim.h5')


@pytest.fixture(scope='session')
def output_pipeline():
    return os.path.join('output', 'pipeline.h5')


@pytest.fixture(scope='session')
def config_path():
    return os.path.join('configs')


@pytest.fixture(scope='session')
def validation_data_path():
    return os.path.join('test', 'data', 'validation')


@pytest.fixture(scope='session')
def input_households(input_h5_file):
    return pd.read_hdf(input_h5_file, 'households')


@pytest.fixture(scope='session')
def input_persons(input_h5_file):
    return pd.read_hdf(input_h5_file, 'persons')


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


@pytest.fixture(scope='session')
def output_households_initialize_households(output_pipeline):
    return pd.read_hdf(output_pipeline, 'households/initialize_households')


@pytest.fixture(scope='session')
def output_persons_initialize_households(output_pipeline):
    return pd.read_hdf(output_pipeline, 'persons/initialize_households')


@pytest.fixture(scope='session')
def annotate_households(config_path):
    cfg = pd.read_csv(os.path.join(config_path, 'annotate_households.csv'))
    return remove_annotation_comments(cfg)


@pytest.fixture(scope='session')
def annotate_persons(config_path):
    cfg = pd.read_csv(os.path.join(config_path, 'annotate_persons.csv'))
    return remove_annotation_comments(cfg)


@pytest.fixture(scope='session')
def annotate_persons_after_hh(config_path):
    cfg = pd.read_csv(os.path.join(config_path, 'annotate_persons_after_hh.csv'))
    return remove_annotation_comments(cfg)
