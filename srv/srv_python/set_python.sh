#!/bin/bash

function install_miniconda(){
	# Upgrade pip
	pip install --upgrade pip
	
	# Download in raspberry pi
	wget https://repo.continuum.io/miniconda/Miniconda3-3.16.0-Linux-armv7l.sh
	
	# Trouble shooting
	#yum install bzip2
	chmod 755 Miniconda3*
	
	# Install
	bash Miniconda3*
	
	# Make a path
	mc_p=$HOME/miniconda3
	echo "export PATH='$mc_p/bin:$mc_p/envs/py3k/bin:$PATH'" >> ~/.bashrc
	# Make default python to python3
	conda create -n py3k python=3
	source activate py3k
	
	# Install package
	conda install numpy
	pip install matplotlib
}

function install_python(){
	# Download
	wget https://www.python.org/ftp/python/3.6.5/Python-3.6.5.tgz
	# Required package
	yum install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel
	# Install
	tar zxvf Python-3.6.5.tgz
	cd Python*
	sudo ./configure --prefix=/usr/local/python
	make
	make install
	# Symbolic link
	ln -s /usr/local/python/bin/python3 /usr/local/bin/python
	ln -s /usr/local/python/bin/pip3.6 /usr/local/bin/pip
	# Make a path
	echo "export PATH='$PATH:/usr/local/python/bin'" >> ~/.bashrc
	# Pip upgrade
	pip install --upgrade pip
	# Confirm version
	python --version
	pip --version
	
	# Ipython
	pip install ipython
	pip install pyreadline
	
	# Wheel for data science module
	pip install wheel
	
	# Numpy
	pip install numpy
	
	# Scipy
	yum -y install lapack-devel
	pip install scipy
	
	# Matplotlib
	yum -y install freetype freetype-devel libpng-devel
	pip install matplotlib
	
	# MariaDB client
	pip install mysql-connector-python pymysql mysqlclient
	
	# Pandas
	pip install pandas
	
	# BeautifulSoup4
	pip install BeautifulSoup4
	
	# Seaborn
	pip install seaborn
	
	# Jupyter
	pip install jupyter
	cp jupyter.service /etc/systemd/system/
	mkdir ~/.jupyter/
	cp jupyter_notebook_config.py ~/.jupyter/
	systemctl start jupyter
	systemctl enable jupyter
}

function util_python(){
	IP=192.168.0.2
	jupyter notebook --ip=$IP --no-browser
	# access -> http://192.168.0.2:8888/?token=jupyter
}
