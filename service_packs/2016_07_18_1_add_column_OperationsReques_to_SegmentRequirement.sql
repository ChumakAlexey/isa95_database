Alter table SegmentRequirement
add OperationsRequest int null
go

Alter table SegmentRequirement
WITH CHECK ADD CONSTRAINT FK_SegmentRequirement_OperationsRequest FOREIGN KEY(OperationsRequest)
REFERENCES OperationsRequest (ID)
go