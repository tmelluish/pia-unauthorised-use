-- Create Staging Schema to load raw data
CREATE SCHEMA IF NOT EXISTS pia_raw;
COMMENT ON SCHEMA pia_raw IS 'Staging Schema for PIA trespass data';

-- Create working schema for analysis
CREATE SCHEMA IF NOT EXISTS  pia_ua;
COMMENT ON SCHEMA pia_raw IS 'Working area for analysing PIA unauthorised access data';
