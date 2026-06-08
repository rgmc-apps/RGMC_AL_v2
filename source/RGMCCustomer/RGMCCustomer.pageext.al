pageextension 50113 "RGMC Customer Ext" extends "Customer Card"
{
    layout
    {
        addlast(General)
        {
            field("Dept Code"; Rec."Dept Code")
            {
                ApplicationArea = All;
            }

            field("Sub-Dept Code"; Rec."Sub Dept Code")
            {
                ApplicationArea = All;
            }

            field("Class Code"; Rec."Class Code")
            {
                ApplicationArea = All;
            }
        }
    }
}