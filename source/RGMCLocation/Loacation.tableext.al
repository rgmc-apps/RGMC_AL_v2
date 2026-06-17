tableextension 50106 "RGMCLocationExt" extends Location
{
    fields
    {
        field(50100; "Store Code"; Code[20])
        {
            Caption = 'Store Code';
            DataClassification = CustomerContent;
        }
        field(50101; RAC_VendorCode; Code[20])
        {
            Caption = 'Vendor Code';
            DataClassification = CustomerContent;
            ObsoleteState = Removed;
            ObsoleteReason = 'Field is now owned by RGMC Customization package.';
            ObsoleteTag = '1.2.0.2';
        }
    }
}
