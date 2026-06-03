using Microsoft.CRM.Contact;

page 50204 "LSC Retail Contact Picture API"
{
    PageType = API;
    APIPublisher = 'rgmc';
    APIGroup = 'rgmccustom';
    APIVersion = 'v1.0';
    EntityName = 'contactPicture';
    EntitySetName = 'contactPictures';
    Caption = 'LSC Retail Contact Picture API';

    SourceTable = Contact;
    ODataKeyFields = SystemId;

    DelayedInsert = true;
    InsertAllowed = false;
    ModifyAllowed = true;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            field(id; Rec.SystemId)
            {
                Caption = 'id';
                Editable = false;
            }
            field(contactNo; Rec."No.")
            {
                Caption = 'contactNo';
                Editable = false;
            }
            field(picture; Rec.Image)
            {
                Caption = 'picture';
            }
        }
    }
}
