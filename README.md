[![Build Status](https://travis-ci.org/wsp-sag/client_arc_activitysim.svg?branch=master)](https://travis-ci.org/wsp-sag/client_arc_activitysim)
# ARC ActivitySim Implementation
[Atlanta Regional Commission (ARC)](https://atlantaregional.org/) prototype of the [ActivitySim Framework](http://activitysim.org/)


## Folder and File Setup

1. Clone the repository to a directory (e.g., C:\Projects)
2. Create a folder named 'Data' in the above directory
3. Download the data (e.g., households.csv, persons.csv and ZoneData.csv) and place those in the 'Data' folder
4. Create a folder named 'Skims' under 'Data' and place the skim matrix (e.g., skims_complete) in that folder


## Installation

1. Install [Anaconda 64bit Python 3](https://www.anaconda.com/distribution/)
2. Create an ActivitySim-oriented virtual python environment. Recommend using a virtual env with the environment.yml included in this repository.
```
conda env create -f environment.yml
```
3. Switch the Virtual Env
```
conda activate arc_activitysim
```

## Data Processing (If necessary)

1. Update the data path in build_h5.py (e.g., C:\Projects\Data) located here: C:\Projects\client_arc_activitysim\scripts
2. Navigate into the scripts folder
```
cd scripts
```
3. Run 'build_h5.py' to create the necessary inputs for ARC ActivitySim. 
```
python build_h5.py complete
```
Available options
- micro (25 sample zones)
- small (500 sample zones)
- complete (all zones)

## Simulation

1. Run the simulation

```python
activitysim run
```
