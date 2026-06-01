pageextension 50102 "RGMC Transfer Order Ext" extends "Transfer Order"
{
    layout
    {
        modify("Transfer-from Name")
        {
            Caption = 'Transfer-from Name';
        }

        modify("Transfer-to Name")
        {
            Caption = 'Transfer-to Name';
        }

        addlast(General)
        {
            field(Remarks; Rec.Remarks)
            {
                ApplicationArea = All;
            }
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = All;
            }
        }
    }
}