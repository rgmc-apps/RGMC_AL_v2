using Microsoft.CRM.Contact;

pageextension 50112 "RGMC Contact Card Ext" extends "Contact Card"
{
    layout
    {
        addlast(General)
        {
            field("Username"; Rec.Username)
            {
                ApplicationArea = All;
                Caption = 'Username';
            }
            field("Password Hash"; Rec."Password Hash")
            {
                ApplicationArea = All;
                Caption = 'Password';
                ExtendedDatatype = Masked;
            }
        }
    }
}
