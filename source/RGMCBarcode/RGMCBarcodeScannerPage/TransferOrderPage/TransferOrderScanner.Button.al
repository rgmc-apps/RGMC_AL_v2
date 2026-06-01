pageextension 50124 RGMCTrasferOrderBtn extends "Transfer Order"
{
    actions
    {
        addafter("&Print")
        {
            action(ScanShipping)
            {
                ApplicationArea = All;
                Caption = 'Scan Shipping';
                Image = BarCode;

                trigger OnAction()
                var
                    TransferHeader: Record "Transfer Header";
                begin
                    TransferHeader.SetRange("No.", Rec."No.");
                    PAGE.RunModal(PAGE::"Transfer Order Scanner", TransferHeader);
                end;
            }

            action(ScanReceiving)
            {
                ApplicationArea = All;
                Caption = 'Scan Receiving';
                Image = BarCode;

                trigger OnAction()
                var
                    TransferHeader: Record "Transfer Header";
                begin
                    TransferHeader.SetRange("No.", Rec."No.");
                    PAGE.RunModal(PAGE::"Transfer Order Receive Scanner", TransferHeader);
                end;
            }
            action(PrintPullout)
            {
                ApplicationArea = All;
                Caption = 'Print LM Pull-out';
                Image = Print;

                trigger OnAction()
                var
                    TransferHeader: Record "Transfer Header";
                begin
                    TransferHeader.SetRange("No.", Rec."No.");
                    REPORT.RunModal(Report::"Print LMPullOut", true, false, TransferHeader);
                end;
            }

        }
    }
}