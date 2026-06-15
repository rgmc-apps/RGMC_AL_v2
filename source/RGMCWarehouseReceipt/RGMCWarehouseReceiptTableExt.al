tableextension 50108 "RGMC Warehouse Receipt Ext" extends "Warehouse Receipt Header"
{
    fields
    {
        field(50100; "Barcode No."; Code[50])
        {
            Caption = 'Barcode No.';
            DataClassification = CustomerContent;
        }
    }
}
