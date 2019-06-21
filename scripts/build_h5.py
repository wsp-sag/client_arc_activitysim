import os
import pandas as pd

arc_h5_file = os.path.join('..', 'data', 'arc_asim.h5')

# add the first 25 rows to the h5 file
land_data = pd.read_csv(r'/Users/chryssac/git/client_arc_activitysim/data/ZoneData.csv')
land_chunk = land_data[0:25]
print(land_chunk)
land_chunk.to_hdf(arc_h5_file, 'land_use_taz', mode='w')

# add the households that are in the same zones as the land data selected
households = pd.read_csv(r'/Users/chryssac/git/client_arc_activitysim/data/households.csv')
households_chunk = households[households['maz'].between(0, 24)]
print(households_chunk)

households_chunk.to_hdf(arc_h5_file, 'households', mode='a')

hhids = households_chunk['HHID']

# add the persons that are in those households
persons = pd.read_csv(r'/Users/chryssac/git/client_arc_activitysim/data/persons.csv')

persons_chunk = persons[persons['HHID'].between(hhids.min(), hhids.max())]
print(persons_chunk)
persons_chunk.to_hdf(arc_h5_file, 'persons', mode='a')
