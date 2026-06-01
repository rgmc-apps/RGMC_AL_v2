pageextension 50127 RGMCWhseReceiptBtn extends "Warehouse Receipt"
{
    actions
    {
        addlast(Processing)
        {
            action(ScanReceipt)
            {
                ApplicationArea = All;
                Caption = 'Barcode Scan';
                Image = BarCode;

                trigger OnAction()
                var
                    ReceiptHeader: Record "Warehouse Receipt Header";
                begin
                    ReceiptHeader.SetRange("No.", Rec."No.");
                    PAGE.RunModal(PAGE::"Warehouse Receipt Scanner", ReceiptHeader);
                end;
            }
        }
    }
}
