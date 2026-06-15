pageextension 50110 "WhseShipmentHeaderExtPage" extends "Warehouse Shipment"
{
    layout
    {
        addlast(Content)
        {
            group("Grand Total")
            {
                Caption = 'Grand Total';

                field(TotalQuantity; TotalQuantity)
                {
                    ApplicationArea = All;
                    Caption = 'Total Quantity';
                    Editable = false;
                }

                field(TotalQtyToShip; TotalQtyToShip)
                {
                    ApplicationArea = All;
                    Caption = 'Total Qty to Ship';
                    Editable = false;
                }

                field(TotalQtyShipped; TotalQtyShipped)
                {
                    ApplicationArea = All;
                    Caption = 'Total Qty Shipped';
                    Editable = false;
                }
            }
        }

        addlast(General)
        {
            field("Destination Name"; DestinationName)
            {
                ApplicationArea = All;
                Caption = 'Destination Name';
                Editable = false;
            }

            field("No. of Boxes"; Rec."No. of Boxes")
            {
                ApplicationArea = All;
                Caption = 'No. of Box(es)';
                Editable = false;
            }
        }
    }

    var
        WhseShipmentLine: Record "Warehouse Shipment Line";
        Location: Record Location;
        DestinationName: Text[100];
        DestinationNo: Code[20];

        TotalQuantity: Decimal;
        TotalQtyToShip: Decimal;
        TotalQtyShipped: Decimal;

    trigger OnAfterGetRecord()
    begin
        DestinationName := '';
        DestinationNo := '';

        // Existing Destination logic
        WhseShipmentLine.Reset();
        WhseShipmentLine.SetRange("No.", Rec."No.");
        if WhseShipmentLine.FindLast() then
            DestinationNo := WhseShipmentLine."Destination No.";

        if DestinationNo <> '' then
            if Location.Get(DestinationNo) then
                DestinationName := Location.Name;

        // Calculate totals
        TotalQuantity := 0;
        TotalQtyToShip := 0;
        TotalQtyShipped := 0;

        WhseShipmentLine.Reset();
        WhseShipmentLine.SetRange("No.", Rec."No.");

        if WhseShipmentLine.FindSet() then
            repeat
                TotalQuantity += WhseShipmentLine.Quantity;
                TotalQtyToShip += WhseShipmentLine."Qty. to Ship";
                TotalQtyShipped += WhseShipmentLine."Qty. Shipped";
            until WhseShipmentLine.Next() = 0;
    end;
}