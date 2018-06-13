#!/usr/bin/env python3

import os
from datetime import datetime

# Commit comment
now = datetime.now()
comment = datetime.now().strftime("%Y/%m/%d-%H:%M:%S")

# Add comment to the update_confirm file
file = open('update_confirm', 'a')
file.write("{}\n".format(comment))
file.close()

# Push
os.system('git add .')
os.system('git commit -m {}'.format(comment))
os.system('git push')
