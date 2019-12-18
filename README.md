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

## Data Processing

1. Update the data path in build_h5.py (e.g., C:\Projects\Data) located here: C:\Projects\client_arc_activitysim\scripts   
2. Run 'build_h5.py' to create the necessary inputs for ARC ActivitySim

```python
python scripts\build_h5.py complete
```
3. Move the output files (e.g.,arc_asim.h5 and skims.omx) from 'Data' folder to 'data' located here: C:\Projects\client_arc_activitysim\data

## Simulation

1. Run the simulation

```python
python simulation.py
```

## Model Components Converted from CT-RAMP to ActivitySim Format

- Accessibilities
- Usual Work, School Location
- Auto Ownership
- Free Parking Eligibility
- Coordinated Daily Activity Pattern (CDAP)
- Mandatory Tour Frequency
- Mandatory Tour Scheduling/Time-of-Day Choice
- Joint Tour Frequency
- Joint Tour Composition
- Joint Tour Participation
- Joint Tour Destination
- Joint Tour Scheduling (about to finish)
- Tour Mode Choice


## Notes Specific to ARC ActivitySim Implementation

- In the tour scheduling/time-of-day choice models, the ARC CTRAMP uses 30-minute time windows, but the MTC ActivitySim implementation uses 1-hour time windows. To incorporate 30-minute time windows in the ARC implementation, the codes were modified and appropriate changes were made in the model expression files.

- Some of the tour purposes and person-level attributes (e.g., PNUM, adult) were hard-coded in the MTC ActivitySim implementation. Since the code modification requires a decent amount of work, instead of modifying the code, some additional variables and columns were created/added to the data and model expression files in order to match with the hard-coded tour purposes and person-level attributes.

