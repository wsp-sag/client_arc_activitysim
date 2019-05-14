# ActivitySim
# See full license in LICENSE.txt.

from __future__ import print_function

# import sys
# if not sys.warnoptions:  # noqa: E402
#     import warnings
#     warnings.filterwarnings('error', category=Warning)
#     warnings.filterwarnings('ignore', category=PendingDeprecationWarning, module='future')
#     warnings.filterwarnings('ignore', category=FutureWarning, module='pandas')

import logging

# activitysim.abm imported for its side-effects (dependency injection)
from activitysim import abm

from activitysim.core import tracing
from activitysim.core import config
from activitysim.core.config import setting
from activitysim.core import pipeline
