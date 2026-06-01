pageextension 50100 RGMCContactCardExt extends "LSC Member Contact"
{
    layout
    {
        addlast(General)
        {
            field("Occupation"; Rec."Occupation")
            {
                ApplicationArea = All;
            }
            field("Company"; Rec."Company")
            {
                ApplicationArea = All;
            }
            field("Remarks"; Rec."Remarks")
            {
                ApplicationArea = All;
            }
            field("Entry Amount"; Rec."Entry Amount")
            {
                ApplicationArea = All;
            }
        }
    }
}