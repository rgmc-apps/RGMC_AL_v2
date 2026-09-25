tableextension 50101 "WhseShipmentHeaderExt" extends "Warehouse Shipment Header"
{
    fields
    {
        field(50100; "No. of Boxes"; Integer)
        {
            Caption = 'No. of Box(es)';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if "No. of Boxes" < 0 then
                    Error('Number of boxes must be zero or greater.');
            end;
        }
        // Stored (not FlowFields) so they can be sorted on the list page; filled by codeunit 50124.
        field(50101; "RGMC Source No."; Code[20])
        {
            Caption = 'Source No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50102; "RGMC Destination No."; Code[20])
        {
            Caption = 'Destination No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50103; "RGMC Destination Name"; Text[100])
        {
            Caption = 'Destination Name';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
}
