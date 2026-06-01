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
    }
}
