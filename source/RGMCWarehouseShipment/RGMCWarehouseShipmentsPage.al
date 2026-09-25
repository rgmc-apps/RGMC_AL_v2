pageextension 50111 RGMCWarehouseShipmentsPage extends "Warehouse Shipment List"
{
    layout
    {
        addafter("No.")
        {
            field("RGMC Source No."; Rec."RGMC Source No.")
            {
                ApplicationArea = All;
            }
            field("RGMC Destination No."; Rec."RGMC Destination No.")
            {
                ApplicationArea = All;
            }
            field("RGMC Destination Name"; Rec."RGMC Destination Name")
            {
                ApplicationArea = All;
            }
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
}
