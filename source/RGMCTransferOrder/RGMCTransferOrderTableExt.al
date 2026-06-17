tableextension 50102 "Transfer Header Ext" extends "Transfer Header"
{
    fields
    {
        field(50100; Remarks; Text[250])
        {
            Caption = 'Remarks';
            DataClassification = ToBeClassified;
        }
        field(50101; "Barcode No."; Code[50])
        {
            Caption = 'Barcode No.';
            DataClassification = CustomerContent;
            ObsoleteState = Removed;
            ObsoleteReason = 'Field is now owned by RGMC Customization package.';
            ObsoleteTag = '1.2.0.2';
        }
    }
}

