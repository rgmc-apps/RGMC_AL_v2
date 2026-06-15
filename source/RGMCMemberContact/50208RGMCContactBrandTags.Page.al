page 50208 "RGMC Contact Brand Tags"
{
    PageType = ListPart;
    Caption = 'Brand Tags';
    SourceTable = "RGMC Contact Brand Tag";
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(BrandTags)
            {
                field("Brand Code"; Rec."Brand Code")
                {
                    ApplicationArea = All;
                    Caption = 'Brand Code';

                    trigger OnValidate()
                    var
                        ItemFamily: Record "LSC Item Family";
                    begin
                        BrandDescription := '';
                        if ItemFamily.Get(Rec."Brand Code") then
                            BrandDescription := ItemFamily.Description;
                    end;
                }
                field(Description; BrandDescription)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    Editable = false;
                }
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
