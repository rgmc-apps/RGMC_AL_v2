using Microsoft.Sales.Document;

pageextension 50214 "Sales Return Order Card Ext" extends "Sales Return Order"
{
    layout
    {
        addlast(General)
        {
            field("Submitted By"; Rec."Submitted By")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the name of the user who submitted this return order.';
            }
        }
    }
}
