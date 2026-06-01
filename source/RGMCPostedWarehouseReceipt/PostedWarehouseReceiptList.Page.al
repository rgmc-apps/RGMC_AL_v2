pageextension 50131 "Warehouse Receipt Header Ext" extends "Posted Whse. Receipt List"
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
            field("External Document No."; ExtDocNo)
            {
                ApplicationArea = Warehouse;
                Caption = 'External Document No.';
                Editable = false;
            }
        }
    }

    var
        PostedWhseRcptLine: Record "Posted Whse. Receipt Line";
        TransRcptHeader: Record "Transfer Receipt Header";
        SourceNo: Code[20];
        TransferFromName: Text[100];
        ExtDocNo: Code[35];

    trigger OnAfterGetRecord()
    begin
        SourceNo := '';
        TransferFromName := '';
        ExtDocNo := '';

        PostedWhseRcptLine.SetRange("No.", Rec."No.");
        if PostedWhseRcptLine.FindFirst() then begin
            SourceNo := PostedWhseRcptLine."Source No.";
            TransRcptHeader.SetRange("Transfer Order No.", SourceNo);
            if TransRcptHeader.FindFirst() then begin
                TransferFromName := TransRcptHeader."Transfer-from Name";
                ExtDocNo := TransRcptHeader."External Document No.";
            end;
        end;
    end;
}