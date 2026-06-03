namespace DefaultPublisher.RGMC_AL;

using Microsoft.CRM.Contact;

tableextension 50112 RGMCContactRegNoExt extends Contact
{
    fields
    {
        field(50200; "Registration No."; Text[30])
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

        modify(Name)
        {
            trigger OnAfterValidate()
            begin
                if Rec.Username = '' then
                    Rec.Username := Rec.Name;
            end;
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