pageextension 50130 "RGMC Warehouse Picks Ext" extends "Warehouse Picks"
{
    layout
    {
        addafter("Destination No.")
        {
            field("RGMC Destination Name"; Rec."RGMC Destination Name")
            {
                ApplicationArea = All;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        WhseActLine: Record "Warehouse Activity Line";
    begin
        // Get Source No. from Warehouse Activity Line
        WhseActLine.SetRange("No.", Rec."No.");
        WhseActLine.SetRange("Line No.", 10000); // Adjust if needed, or use FindFirst to get first record
        if WhseActLine.FindFirst() then
            Rec."Source No." := WhseActLine."Source No."
        else
            Rec."Source No." := '';
    end;
}
