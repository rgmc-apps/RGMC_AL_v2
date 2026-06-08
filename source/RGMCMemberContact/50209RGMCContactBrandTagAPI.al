page 50209 "RGMC Contact Brand Tag API"
{
    PageType = API;
    APIPublisher = 'rgmc';
    APIGroup = 'rgmccustom';
    APIVersion = 'v1.0';
    EntityName = 'contactBrandTag';
    EntitySetName = 'contactBrandTags';
    Caption = 'RGMC Contact Brand Tag API';

    SourceTable = "RGMC Contact Brand Tag";
    ODataKeyFields = SystemId;

    DelayedInsert = true;
    InsertAllowed = true;
    ModifyAllowed = false;
    DeleteAllowed = true;

    layout
    {
        area(Content)
        {
            field(id; Rec.SystemId)
            {
                Caption = 'id';
                Editable = false;
            }
            field(contactNo; Rec."Contact No.")
            {
                Caption = 'contactNo';
            }
            field(brandCode; Rec."Brand Code")
            {
                Caption = 'brandCode';
            }
            field(description; BrandDescription)
            {
                Caption = 'description';
                Editable = false;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        ItemFamily: Record "LSC Item Family";
    begin
        BrandDescription := '';
        if ItemFamily.Get(Rec."Brand Code") then
            BrandDescription := ItemFamily.Description;
    end;

    var
        BrandDescription: Text[100];
}
