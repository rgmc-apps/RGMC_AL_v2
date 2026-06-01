pageextension 50103 "RGMC Transfer Orders List Ext" extends "Transfer Orders"
{
    layout
    {
        addbefore("No.")
        {
            field("Posting Date"; Rec."Posting Date")
            {
                ApplicationArea = All;
            }
        }
        addafter("Status")
        {
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = All;
            }
        }

        modify("Assigned User ID")
        {
            Visible = true;
        }

        addafter("Transfer-from Code")
        {
            field("Transfer-from Name"; Rec."Transfer-from Name")
            {
                ApplicationArea = All;
            }
        }

        addafter("Transfer-to Code")
        {
            field("Transfer-to Name"; Rec."Transfer-to Name")
            {
                ApplicationArea = All;
            }
        }

        addafter("Assigned User ID")
        {
            field("Remarks"; Rec."Remarks")
            {
                ApplicationArea = All;
            }
        }
    }
}
