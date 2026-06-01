tableextension 50104 "RGMC Registered Whse Pick Ext" extends "Registered Whse. Activity Hdr."
{
    fields
    {
        field(50100; "Device Id / Owner"; Text[100])
        {
            Caption = 'Device Id / Owner';
        }
        field(50101; "No. of Boxes"; Integer)
        {
            Caption = 'No. of Box(es)';
        }
    }
}