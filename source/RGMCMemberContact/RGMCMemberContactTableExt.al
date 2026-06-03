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
        field(50250; "Username"; Text[100])
        {
            Caption = 'Username';
            DataClassification = CustomerContent;
        }
        field(50251; "Password Hash"; Text[100])
        {
            Caption = 'Password';
            DataClassification = CustomerContent;
            ExtendedDatatype = Masked;
        }
    }

    trigger OnInsert()
    begin
        if Rec.Username = '' then
            Rec.Username := Rec.Name;
        if Rec."Password Hash" = '' then
            Rec."Password Hash" := '$2a$12$EAbkceqhezNLVmx96.3/BO5N1gNcIECWByxEB/anvxEXEIjZtA19i';
    end;
}