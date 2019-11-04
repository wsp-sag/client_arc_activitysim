import os

import numpy as np
import openmatrix as omx
import pandas as pd


manifest = pd.read_csv(os.path.join('..', 'Scripts', 'skim_manifest.csv'))

skims = omx.open_file(os.path.join('..', 'data', 'skims.omx'), 'w')

cwd = r'C:\Users\uscd675041\OneDrive - WSP O365\Georgia\Atlanta\ARC_ActivitySim\Data\Skims'

manifest = zip(manifest['File'], manifest['Token'], manifest['TimePeriod'], manifest['Matrix'])


for file, token, period, matrix_name in manifest:
    matrix = omx.open_file(os.path.join(cwd, file), 'r')
    print("Reading: {}__{}".format(token, period))
    skims['{}__{}'.format(token, period)] = np.array(matrix[matrix_name][:5922, :5922])
    print("Complete")
    matrix.close()

skims.close()
