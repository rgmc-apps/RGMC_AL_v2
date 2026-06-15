tableextension 50107 "RGMCCustomerExt" extends Customer
{
    fields
    {
        field(50100; "Dept Code"; Integer)
        {
            Caption = 'Dept Code';
            DataClassification = CustomerContent;
        }
        field(50101; "Sub Dept Code"; Integer)
        {
            Caption = 'Sub-Dept Code';
            DataClassification = CustomerContent;
        }
        field(50102; "Class Code"; Integer)
        {
            Caption = 'Class Code';
            DataClassification = CustomerContent;
        }
        field(50103; RAC_StoreCode; Code[20])
        {
            Caption = 'Store Code';
            DataClassification = CustomerContent;
        }
    }
}