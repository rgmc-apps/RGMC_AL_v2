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
    }
}