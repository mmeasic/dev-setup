#!/usr/bin/env bash

# ~/pydata.sh

# Removed user's cached credentials
# This script might be run with .dots, which uses elevated privileges
sudo -K

echo "------------------------------"
echo "Setting up pip."

# Install pip
easy_install pip

###############################################################################
# Virtual Enviroments                                                         #
###############################################################################

echo "------------------------------"
echo "Setting up virtual environments."

# Install virtual environments globally
# It fails to install virtualenv if PIP_REQUIRE_VIRTUALENV was true
export PIP_REQUIRE_VIRTUALENV=false
pip install virtualenv
pip install virtualenvwrapper

echo "------------------------------"
echo "Source virtualenvwrapper from ~/.extra"

EXTRA_PATH=~/.extra
echo $EXTRA_PATH
echo "" >> $EXTRA_PATH
echo "" >> $EXTRA_PATH
echo "# Source virtualenvwrapper, added by pydata.sh" >> $EXTRA_PATH
echo "export WORKON_HOME=~/.virtualenvs" >> $EXTRA_PATH
echo "" >> $EXTRA_PATH

# Setup the Python dev path
DEV_PATH=~/Code/python
mkdir -p DEV_PATH
echo $DEV_PATH
echo "" >> $EXTRA_PATH
echo "" >> $EXTRA_PATH
echo "# Project home path for virtualenvwrapper, added by pydata.sh" >> $EXTRA_PATH
echo "export PROJECT_HOME=~/Code/python" >> $EXTRA_PATH
echo "source /usr/local/bin/virtualenvwrapper.sh" >> $EXTRA_PATH
echo "" >> $EXTRA_PATH
source $EXTRA_PATH

###############################################################################
# Python 3 Virtual Enviroment                                                 #
###############################################################################

echo "------------------------------"
echo "Setting up py3-data virtual environment."

# Create a Python3 data environment
mkvirtualenv --python=/usr/local/bin/python3 py3-data
workon py3-data

# Install Python data modules
pip install numpy
pip install scipy
pip install matplotlib
pip install pandas
pip install sympy
pip install nose
pip install unittest2
pip install seaborn
pip install scikit-learn
pip install "ipython[all]"
pip install bokeh
pip install Flask
pip install sqlalchemy
pip install cookiecutter
pip install jupyter_contrib_nbextensions

# Setting up the cookiecutter DS template
COOKIE_GITHUB=https://github.com/mmeasic/cookiecutter-data-science
echo "" >> $EXTRA_PATH
echo "" >> $EXTRA_PATH
echo "# Cookiecutter template location" >> $EXTRA_PATH
echo "export COOKIE_GITHUB=$COOKIE_GITHUB" >> $EXTRA_PATH
echo "" >> $EXTRA_PATH
source $EXTRA_PATH

###############################################################################
# Install IPython Profile
###############################################################################

echo "------------------------------"
echo "Installing IPython Notebook Default Profile"

# Add the IPython profile
mkdir -p ~/.ipython
cp -r init/profile_default/ ~/.ipython/profile_default

###############################################################################
# Global Jupyter NBExtensions in ~/.jupyter/nbconfig, valid for all envs
###############################################################################

# Add the notebook extension style files
jupyter contrib nbextension install

# Add the tab to the web UI
pip install jupyter_nbextensions_configurator
jupyter nbextensions_configurator enable

# Enable default extensions
# AutoPEP8
jupyter nbextension enable code_prettify/autopep8
# TOC
jupyter nbextension enable toc2/main
# Variable inspector
jupyter nbextension enable varInspector/main
# Code folding
jupyter nbextension enable codefolding/main
# ExecuteTime
jupyter nbextension enable execute_time/ExecuteTime
# GistIt
jupyter nbextension enable gist_it/main

# Setup the default Jupyter notebook template
NB_DIR1=$(pip show jupyter_contrib_nbextensions | grep Location | cut -d ' ' -f 2)
NB_DIR2=$(sed "s/-/_/g" <<< $(pip show jupyter_contrib_nbextensions | grep Name | cut -d ' ' -f 2))
NB_DIR3=$(echo "nbextensions")
NB_NEW=$(echo "setup")
NB_PATH=$NB_DIR1/$NB_DIR2/$NB_DIR3/$NB_NEW

mkdir -p $NB_PATH
cd $NB_PATH

wget https://raw.githubusercontent.com/mmeasic/jupyter-template/master/main.js
wget https://raw.githubusercontent.com/mmeasic/jupyter-template/master/setup.yaml
wget https://raw.githubusercontent.com/mmeasic/jupyter-template/master/README.md

# Add the new extension
jupyter contrib nbextension install

# Template
jupyter nbextension enable setup/main

echo "------------------------------"
echo "Script completed."
echo "Usage: workon py3-data for Python3"