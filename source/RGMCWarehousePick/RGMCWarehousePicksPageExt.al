pageextension 50130 "RGMC Warehouse Picks Ext" extends "Warehouse Picks"
{
    layout
    {
        addafter("Destination No.")
        {
            field("Destination Name"; DestinationName)
            {
                ApplicationArea = All;
                Caption = 'Destination Name';
                Editable = false;
            }
        }
    }

    var
        DestinationNo: Code[10];
        DestinationName: Text[100];

    trigger OnAfterGetRecord()
    var
        WhseActLine: Record "Warehouse Activity Line";
        Location: Record Location;
    begin
        // Get Destination No. and Source No. from Warehouse Activity Line
        WhseActLine.SetRange("No.", Rec."No.");
        WhseActLine.SetRange("Line No.", 10000); // Adjust if needed, or use FindFirst to get first record
        if WhseActLine.FindFirst() then begin
            DestinationNo := WhseActLine."Destination No.";
            Rec."Source No." := WhseActLine."Source No.";
        end else begin
            DestinationNo := '';
            Rec."Source No." := '';
        end;

        // Get Destination Name from Location using Destination No. as Location Code
        if DestinationNo <> '' then begin
            if Location.Get(DestinationNo) then
                DestinationName := Location.Name
            else
                DestinationName := '';
        end else
            DestinationName := '';
    end;
}
