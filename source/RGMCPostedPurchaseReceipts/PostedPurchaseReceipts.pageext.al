pageextension 50135 "RGMC Posted Purchase Receipts" extends "Posted Purchase Receipts"
{
    layout
    {
        addafter("Buy-from Vendor Name")
        {
            field("Order No."; Rec."Order No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the order number of the purchase receipt.';
            }
        }
    }
}