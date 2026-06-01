pageextension 50128 "Transfer Receipt Header Ext" extends "Posted Transfer Receipts"
{
    layout
    {
        addafter("No.")
        {
            field("Transfer Order No."; Rec."Transfer Order No.")
            {
                ApplicationArea = Location;
                ToolTip = 'Specifies the transfer order number associated with this receipt.';
            }
            field("External Document No."; ExtDocNo)
            {
                ApplicationArea = Location;
                Caption = 'External Document No.';
                ToolTip = 'Specifies the external document number from the original transfer order.';
                Editable = false;
            }
        }
    }

    var
        TransferShipmentHeader: Record "Transfer Shipment Header";
        ExtDocNo: Code[35];

    trigger OnAfterGetRecord()
    begin
        ExtDocNo := '';
        TransferShipmentHeader.SetRange("Transfer Order No.", Rec."Transfer Order No.");
        if TransferShipmentHeader.FindFirst() then
            ExtDocNo := TransferShipmentHeader."External Document No.";
    end;
}