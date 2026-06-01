pageextension 50104 "RGMC Warehouse Pick Ext" extends "Warehouse Pick"
{
    layout
    {
        addlast(General)
        {
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = All;

                trigger OnValidate()
                var
                    WhseActLine: Record "Warehouse Activity Line";
                    WhseShptHdr: Record "Warehouse Shipment Header";
                begin
                    // Find related Warehouse Activity Line for this pick
                    WhseActLine.SetRange("No.", Rec."No.");
                    if WhseActLine.FindFirst() then begin
                        // Get the related Warehouse Shipment Header using Whse. Document No.
                        if WhseShptHdr.Get(WhseActLine."Whse. Document No.") then begin
                            WhseShptHdr."External Document No." := Rec."External Document No.";
                            WhseShptHdr.Modify(true);
                        end;
                    end;
                end;
            }

            field("No. of Boxes"; Rec."No. of Boxes")
            {
                ApplicationArea = All;

                trigger OnValidate()
                var
                    WhseActLine: Record "Warehouse Activity Line";
                    WhseShptHdr: Record "Warehouse Shipment Header";
                begin
                    // Find related Warehouse Activity Line for this pick
                    WhseActLine.SetRange("No.", Rec."No.");
                    if WhseActLine.FindFirst() then begin
                        // Get the related Warehouse Shipment Header using Whse. Document No.
                        if WhseShptHdr.Get(WhseActLine."Whse. Document No.") then begin
                            WhseShptHdr."No. of Boxes" := Rec."No. of Boxes";
                            WhseShptHdr.Modify(true);
                        end;
                    end;
                end;
            }
        }
    }
}
