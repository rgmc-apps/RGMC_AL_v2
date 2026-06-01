tableextension 50100 RGMCContactTableExt extends "LSC Member Contact"
{
    fields
    {
        field(50100; "Occupation"; Text[100]) { }
        field(50101; "Company"; Text[100]) { }
        field(50102; "Remarks"; Text[250]) { }
        field(50103; "Entry Amount"; Decimal) { }
        field(50104; "Registration No."; Text[30])
        {
            Caption = 'Registration No.';
            DataClassification = CustomerContent;
        }
    }
}