PROJECT TBD

This project analyses where CityFibre may be using OpenReach's PIA estate without authorisation.

The model is based on the following datasets:
1. OpenReach 

All datasets are in the public domain.

The datasets are available on the Cityfibre-Analytics AWS host - Solutions Operations can restore this host
if the data is required.

The database is cityfibre-rds.czgqoamykume.eu-west-2.rds.amazonaws.com, the associated linux server has address 10.23.0.226


The model is built by executing the linux shell scripts in the bin folder in the following order:

	1. run init.sh to create the data model and some helper functions
	2. run load.sh with raw to load data files in to raw tables (no geometries, just string/integer representations)
	3. run load.sh with public to get 