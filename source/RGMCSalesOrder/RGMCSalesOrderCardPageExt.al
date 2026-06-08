using Microsoft.Sales.Document;

pageextension 50212 "Sales Order Card Ext" extends "Sales Order"
{
    layout
    {
        addlast(General)
        {
            field("Submitted By"; Rec."Submitted By")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the name of the user who submitted this order.';
            }
        }
    }
}
