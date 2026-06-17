tableextension 50108 "RGMC Warehouse Receipt Ext" extends "Warehouse Receipt Header"
{
    fields
    {
        field(50100; "Device Id / Owner"; Text[100])
        {
            Caption = 'Device Id / Owner';
            DataClassification = SystemMetadata;
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