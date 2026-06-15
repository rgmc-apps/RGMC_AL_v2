pageextension 50132 "Posted Whse Receipt Ext" extends "Posted Whse. Receipt"
{
    layout
    {
        addLast(General)
        {
            field("Device Id / Owner"; Rec."Device Id / Owner")
            {
                ApplicationArea = All;
                Caption = 'Device Id / Owner';
                Editable = false;
            }
        }


        addlast(Content)
        {
            group("Grand Total")
            {
                Caption = 'Grand Total';

                field("Total"; GrandTotalQuantity)
                {
                    ApplicationArea = All;
                    Caption = 'Total';
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                    ToolTip = 'Specifies the total quantity on the posted warehouse receipt lines.';
                }
            }
        }
    }

    var
        PostedWhseRcptLine: Record "Posted Whse. Receipt Line";
        GrandTotalQuantity: Decimal;

    trigger OnAfterGetRecord()
    begin
        CalcGrandTotalQuantity();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        CalcGrandTotalQuantity();
    end;

    local procedure CalcGrandTotalQuantity()
    begin
        GrandTotalQuantity := 0;

        PostedWhseRcptLine.Reset();
        PostedWhseRcptLine.SetRange("No.", Rec."No.");
        if PostedWhseRcptLine.FindSet() then
            repeat
                GrandTotalQuantity += PostedWhseRcptLine.Quantity;
            until PostedWhseRcptLine.Next() = 0;
    end;
}
