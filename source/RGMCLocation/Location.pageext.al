pageextension 50133 "RGMCLocationCardExt" extends "Location Card"
{
    layout
    {
        addlast(General)
        {
            field("Store Code"; Rec."Store Code")
            {
                ApplicationArea = All;
                Caption = 'Store Code';
                ToolTip = 'Specifies the store code for this location.';
            }
        }
    }
}
