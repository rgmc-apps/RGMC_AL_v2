pageextension 50125 RGMCWhsePicksBtn extends "Warehouse Pick"
{
    actions
    {
        addafter("&Print")
        {
            action(ScanShipping)
            {
                ApplicationArea = All;
                Caption = 'Barcode Scan';
                Image = BarCode;

                trigger OnAction()
                var
                    TransferHeader: Record "Warehouse Activity Header";
                begin
                    TransferHeader.SetRange("No.", Rec."No.");
                    PAGE.RunModal(PAGE::"Warehouse Pick Scanner", TransferHeader);
                end;
            }
        }
    }
}