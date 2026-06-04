page 50206 "LSC Retail Item Family API"
{
    PageType = API;
    APIPublisher = 'rgmc';
    APIGroup = 'rgmccustom';
    APIVersion = 'v1.0';
    EntityName = 'itemFamily';
    EntitySetName = 'itemFamilies';
    Caption = 'LSC Retail Item Family API';

    SourceTable = "LSC Item Family";
    ODataKeyFields = SystemId;

    DelayedInsert = true;
    InsertAllowed = false;
    ModifyAllowed = false;
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
            field(code; Rec.Code)
            {
                Caption = 'code';
                Editable = false;
            }
            field(description; Rec.Description)
            {
                Caption = 'description';
                Editable = false;
            }
            field(lastModifiedDateTime; Rec.SystemModifiedAt)
            {
                Caption = 'lastModifiedDateTime';
                Editable = false;
            }
        }
    }
}
