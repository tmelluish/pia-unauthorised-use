-- Create Staging Schema to load raw data
CREATE SCHEMA IF NOT EXISTS pia_raw;
COMMENT ON SCHEMA pia_raw IS 'Staging Schema for PIA trespass data';

-- Create working schema for analysis
CREATE SCHEMA IF NOT EXISTS  pia_ua;
COMMENT ON SCHEMA pia_ua IS 'Working area for analysing PIA unauthorised access data';

-- Create schema for CF thirdparty data
CREATE SCHEMA IF NOT EXISTS  thirdparty;
COMMENT ON SCHEMA thirdparty IS 'Working area for CF third party (e.g. openreach) data';
