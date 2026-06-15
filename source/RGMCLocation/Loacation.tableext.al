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
        }
    }
}
