#!/usr/bin/env python3

import os
from datetime import datetime

now = datetime.now()

commit = "{}/{}/{}-{}:{}:{}".format(now.year, now.month, now.day, now.hour, now.minute, now.second)

os.system('git add .')
os.system('git commit -m {}'.format(commit))
os.system('git push')
