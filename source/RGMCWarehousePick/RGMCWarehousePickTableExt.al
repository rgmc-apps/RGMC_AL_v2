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
        // Stored (not a FlowField) so it can be sorted on the list page; filled by codeunit 50126.
        field(50102; "RGMC Destination Name"; Text[100])
        {
            Caption = 'Destination Name';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
}