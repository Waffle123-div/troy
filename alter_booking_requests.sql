-- Add the LastUpdated column to BookingRequests table if it doesn't exist
ALTER TABLE BookingRequests 
ADD COLUMN IF NOT EXISTS LastUpdated DATETIME NULL DEFAULT NULL,
ADD COLUMN IF NOT EXISTS AdminID INT NULL DEFAULT NULL; 