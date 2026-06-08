using Microsoft.Sales.Document;

pageextension 50213 "Sales Order List Ext" extends "Sales Order List"
{
    layout
    {
        addlast(Control1)
        {
            field("Submitted By"; Rec."Submitted By")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the name of the user who submitted this order.';
            }
        }
    }
}
