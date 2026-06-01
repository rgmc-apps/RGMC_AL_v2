pageextension 50108 "RALPostedPurchInvExt" extends "Posted Purchase Invoices"
{
    layout
    {
        addbefore("Vendor Invoice No.")
        {
            field("Pre-Assigned No."; Rec."Pre-Assigned No.")
            {
                ApplicationArea = All;
            }
        }
    }
}