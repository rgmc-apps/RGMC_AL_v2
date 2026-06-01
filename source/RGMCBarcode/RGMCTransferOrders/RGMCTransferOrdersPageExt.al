pageextension 50120 RGMCTransferOrderExt extends "Transfer Order"
{
    trigger OnAfterGetCurrRecord()
    begin
        Clear(Rec."Barcode No.");
        CurrPage.Update(false);
    end;
}