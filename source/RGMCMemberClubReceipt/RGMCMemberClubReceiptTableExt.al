tableextension 50105 LSCMemberClubExt extends "LSC Member Club"
{
    fields
    {
        field(50100; "ShowMemberOnReceipt"; Option)
        {
            Caption = 'Show Member on Receipt';
            OptionMembers = None,MemberName,MemberID;
            DataClassification = CustomerContent;
        }

        field(50101; "Show Member Name on Receipt"; Boolean)
        {
            Caption = 'Show Member Name on Receipt';
            DataClassification = CustomerContent;
        }
    }
}