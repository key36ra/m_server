#!/bin/bash

# This code get some data from API of e-stat.

# Census meta data.
curl -s 'http://api.e-stat.go.jp/rest/2.1/app/json/getStatsList?appId=58a0517593bc0a97d3d9cbbda0021a85d5ebbd5c&statsCode=00200521' > census.json
# Population data.
curl -s 'http://api.e-stat.go.jp/rest/2.1/app/getSimpleStatsData?appId=58a0517593bc0a97d3d9cbbda0021a85d5ebbd5c&statsDataId=0003142014' > census_h27_population.csv