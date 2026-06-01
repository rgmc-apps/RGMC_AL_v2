pageextension 50126 "Transfer Shipment Header Ext" extends "Posted Transfer Shipments"
{
    layout
    {
        addafter("No.")
        {
            field("Transfer Order No."; Rec."Transfer Order No.")
            {
                ApplicationArea = All;
            }
            field("Transfer-to Name"; Rec."Transfer-to Name")
            {
                ApplicationArea = All;
            }
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = All;
            }
        }
    }
}