import os
import sys

import openmatrix as omx
import pandas as pd
from shutil import copyfile


def create_input_data_file(data_scale,
                           working_dir=r'C:\Users\uscd675041\OneDrive - WSP O365\Georgia\Atlanta\ARC_ActivitySim\Data'):

    omx_file = os.path.join(working_dir, 'Skims', 'skims_{}.omx'.format(data_scale))
    zone_data_file = os.path.join(working_dir, 'ZoneData.csv')
    households_file = os.path.join(working_dir, 'households.csv')
    persons_file = os.path.join(working_dir, 'persons.csv')
    arc_h5_file = os.path.join('..', 'data', 'arc_asim.h5')
    omx_out_file = os.path.join('..', 'data', 'skims.omx')

    with omx.open_file(omx_file) as m:
        shape = m.shape()
        print('Shape:', shape)
        print('Number of tables:', len(m))
        print('Table names:', m.list_matrices())

    print('Selecting Zone Data Records...')
    # add the first XX rows to the h5 file based on the OMX Shape
    land_data = pd.read_csv(zone_data_file, index_col='TAZ')
    land_chunk = land_data[land_data.index <= shape[0]].copy()
    land_chunk.to_hdf(arc_h5_file, 'land_use_taz', mode='w')

    print('Selecting Household Records...')
    # add the households that are in the same zones as the land data selected
    households = pd.read_csv(households_file, index_col='household_id')
    households_chunk = households[households['maz'].isin(land_chunk.index)].copy()
    print('Households Selected: {:,d}'.format(len(households_chunk)))
    households_chunk.to_hdf(arc_h5_file, 'households', mode='a')

    print('Selecting Person Records...')
    # add the persons that are in those households
    persons = pd.read_csv(persons_file, index_col='person_id')
    persons_chunk = persons.loc[persons['household_id'].isin(households_chunk.index)]
    print('Persons Selected: {:,d}'.format(len(persons_chunk)))
    persons_chunk.to_hdf(arc_h5_file, 'persons', mode='a')

    print('Copying OMX file...')
    copyfile(omx_file, omx_out_file)


if __name__ == '__main__':
    if sys.argv[1] not in (['micro', 'complete', 'small']):
        sys.exit(1)
    data_scale = sys.argv[1]
    # working_dir = sys.argv[2] else if sys.argv[2] ;;
    create_input_data_file(data_scale)
