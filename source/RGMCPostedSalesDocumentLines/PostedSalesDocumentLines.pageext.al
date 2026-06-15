pageextension 50134 "RGMC Posted Sales Shpt Lines" extends "Get Post.Doc - S.ShptLn Sbfrm"
{
    layout
    {
        modify("Shipment Date")
        {
            Visible = false;
        }

        addbefore("Shipment Date")
        {
            field("Posting Date"; Rec."Posting Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the posting date of the shipment.';
            }
        }
    }
}