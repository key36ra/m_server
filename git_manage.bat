rem Management

git add .
git commit -m %DATE:~-10,4%-%DATE:~-5,2%-%DATE:~-2%-%TIME:~0,2%:%TIME:~3,2%:%TIME:~6,2%
git push
