using Microsoft.CRM.Contact;

table 50207 "RGMC Contact Brand Tag"
{
    DataClassification = CustomerContent;
    Caption = 'Contact Brand Tag';

    fields
    {
        field(1; "Contact No."; Code[20])
        {
            Caption = 'Contact No.';
            TableRelation = Contact."No.";
        }
        field(2; "Brand Code"; Code[20])
        {
            Caption = 'Brand Code';
            TableRelation = "LSC Item Family".Code;
        }
    }

    keys
    {
        key(PK; "Contact No.", "Brand Code")
        {
            Clustered = true;
        }
    }
}
