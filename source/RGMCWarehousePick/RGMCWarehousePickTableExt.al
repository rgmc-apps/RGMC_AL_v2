tableextension 50103 "RGMC Warehouse Pick Ext" extends "Warehouse Activity Header"
{
    fields
    {
        field(50100; "Device Id / Owner"; Text[100])
        {
            Caption = 'Device Id / Owner';
            DataClassification = SystemMetadata;
        }

        field(50101; "No. of Boxes"; Integer)
        {
            Caption = 'No. of Box(es)';
            DataClassification = SystemMetadata;
        }
    }
}