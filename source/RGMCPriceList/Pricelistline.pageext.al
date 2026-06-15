pageextension 50136 "RGMC Price List Line" extends "Price List Lines"
{
    layout
    {
        addbefore("Product No.")
        {
            field("Line No."; Rec."Line No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the line number of the price list line.';
            }
        }
    }
}