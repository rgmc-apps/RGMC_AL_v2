pageextension 50107 SalesInvoiceExt extends "Sales Order Subform"
{
    layout
    {
        addafter("Total VAT Amount")
        {
            field("Total Quantity"; TotalQuantity)
            {
                ApplicationArea = All;
                Caption = 'Total Quantity';
                Editable = false;
            }
        }
    }

    var
        TotalQuantity: Integer;

    trigger OnAfterGetRecord()
    begin
        CalcTotalQuantity;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        CalcTotalQuantity;
    end;

    local procedure CalcTotalQuantity()
    var
        SalesLine: Record "Sales Line";
    begin
        TotalQuantity := 0;
        SalesLine.SetRange("Document Type", Rec."Document Type");
        SalesLine.SetRange("Document No.", Rec."Document No.");
        if SalesLine.FindSet() then
            repeat
                TotalQuantity += SalesLine.Quantity;
            until SalesLine.Next() = 0;
    end;
}
