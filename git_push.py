#!/usr/bin/env python3

import os
from datetime import datetime

# Commit comment
now = datetime.now()
commit = "{}/{}/{}-{}:{}:{}".format(now.year, now.month, now.day, now.hour, now.minute, now.second)

# Add comment to the update_confirm file
file = open('update_confirm', 'a')
file.write("{}\n".format(commit))
file.close()

# Push
os.system('git add .')
os.system('git commit -m {}'.format(commit))
os.system('git push')
