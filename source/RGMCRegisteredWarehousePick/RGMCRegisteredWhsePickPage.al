pageextension 50105 "RGMC Registered Whse Pick Ext" extends "Registered Pick"
{
    layout
    {
        addlast(General)
        {
            field("Device Id/Owner"; Rec."Device Id / Owner")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("No. of Boxes"; Rec."No. of Boxes")
            {
                ApplicationArea = All;
                Editable = false;
                Visible = false;
            }

        }
    }
}