pageextension 50111 RGMCWarehouseShipmentsPage extends "Warehouse Shipment List"
{
    layout
    {
        addafter("No.")
        {
            field("Source No."; SourceNo)
            {
                ApplicationArea = All;
                Caption = 'Source No.';
                Editable = false;
            }
            field("Destination No."; DestinationNo)
            {
                ApplicationArea = All;
                Caption = 'Destination No.';
                Editable = false;
            }
            field("Destination Name"; DestinationName)
            {
                ApplicationArea = All;
                Caption = 'Destination Name';
                Editable = false;
            }
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }

    var
        WhseShipmentLine: Record "Warehouse Shipment Line";
        Location: Record Location;
        DestinationNo: Code[20];
        DestinationName: Text[100];
        SourceNo: Code[20];

    trigger OnAfterGetRecord()
    begin
        DestinationNo := '';
        DestinationName := '';
        SourceNo := '';

        WhseShipmentLine.Reset();
        WhseShipmentLine.SetCurrentKey("No.", "Line No.");
        WhseShipmentLine.SetRange("No.", Rec."No.");
        if WhseShipmentLine.FindLast() then begin
            DestinationNo := WhseShipmentLine."Destination No.";
            SourceNo := WhseShipmentLine."Source No.";
        end;

        if DestinationNo <> '' then begin
            if Location.Get(DestinationNo) then
                DestinationName := Location.Name
            else
                DestinationName := '';
        end;
    end;
}