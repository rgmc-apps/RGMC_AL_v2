pageextension 50129 "Warehouse Receipt Ext" extends "Warehouse Receipts"
{
    layout
    {
        addafter("No.")
        {
            field("Source No."; SourceNo)
            {
                ApplicationArea = Warehouse;
                Caption = 'Source No.';
                Editable = false;
            }
            field("Transfer-from Name"; TransferFromName)
            {
                ApplicationArea = Warehouse;
                Caption = 'Transfer-from Name';
                Editable = false;
            }
            field("Posting_Date"; Rec."Posting Date")
            {
                ApplicationArea = Warehouse;
                Caption = 'Posting Date';
                Editable = false;
            }
        }

        addafter("Sorting Method")
        {
            field("Transfer Remarks"; TransferRemarks)
            {
                ApplicationArea = Warehouse;
                Caption = 'Remarks';
                Editable = false;
            }
            field("Vendor Shipment No."; Rec."Vendor Shipment No.")
            {
                ApplicationArea = Warehouse;
                Caption = 'Vendor Shipment No.';
                Editable = false;
            }
        }
    }

    var
        WarehouseReceiptLine: Record "Warehouse Receipt Line";
        TransferHeader: Record "Transfer Header";
        SourceNo: Code[20];
        TransferRemarks: Text[250];
        TransferFromName: Text[100];

    trigger OnAfterGetRecord()
    begin
        SourceNo := '';
        TransferRemarks := '';
        TransferFromName := '';

        WarehouseReceiptLine.SetRange("No.", Rec."No.");
        if WarehouseReceiptLine.FindFirst() then begin
            SourceNo := WarehouseReceiptLine."Source No.";

            if TransferHeader.Get(SourceNo) then begin
                TransferRemarks := TransferHeader."Remarks";
                TransferFromName := TransferHeader."Transfer-from Name";
            end;
        end;
    end;
}