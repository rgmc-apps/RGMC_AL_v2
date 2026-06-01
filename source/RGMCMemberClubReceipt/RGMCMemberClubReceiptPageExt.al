pageextension 50106 "MemberClubCardExt_ShowName" extends "LSC Member Club Card"
{
    layout
    {
        addlast(General)
        {
            field("Show Member Name on Receipt"; Rec."Show Member Name on Receipt")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies whether the member name should be printed on the receipt.';
            }
        }

    }
}