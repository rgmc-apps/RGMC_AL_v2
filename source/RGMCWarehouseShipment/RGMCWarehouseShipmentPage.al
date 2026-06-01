pageextension 50110 "WhseShipmentHeaderExtPage" extends "Warehouse Shipment"
{
    layout
    {
        addlast(General)
        {
            field("No. of Boxes"; Rec."No. of Boxes")
            {
                ApplicationArea = All;
                Caption = 'No. of Box(es)';
                Editable = false;
            }
        }
    }
}