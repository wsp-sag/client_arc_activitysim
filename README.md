[![Build Status](https://travis-ci.org/wsp-sag/client_arc_activitysim.svg?branch=master)](https://travis-ci.org/wsp-sag/client_arc_activitysim)
# ARC ActivitySim Implementation
[Atlanta Regional Commission (ARC)](https://atlantaregional.org/) prototype of the [ActivitySim Framework](http://activitysim.org/)


## Installation
1. Create an ActivitySim-oriented virtual python environment. Recommend using a [Anaconda Conda](https://www.anaconda.com/) virtual env with the environment.yml included in this repository.
```
>>conda env create -f environment.yml
```
2. Switch the Virtual Env
```
conda activate arc_activitysim
```
3. Run the simulation
```python
python simulation.py
```

## Data
Data will need to be downloaded from an external location.

1. Once data is downloaded to an accessible location, update the paths in scripts\build_h5.py
2. Run scripts\build_h5 to create the necessary inputs for ARC ActivitySim.