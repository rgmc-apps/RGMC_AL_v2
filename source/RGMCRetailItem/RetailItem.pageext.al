pageextension 50137 "RGMC Retail Item" extends "LSC Retail Item"
{
    layout
    {
        addafter("Season Code")
        {
            field("Line Up Season"; Rec."Line Up Season")
            {
                ApplicationArea = All;
            }
        }
    }
}