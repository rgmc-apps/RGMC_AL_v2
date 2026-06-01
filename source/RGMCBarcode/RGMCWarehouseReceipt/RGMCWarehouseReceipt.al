pageextension 50122 RGMCWarehouseRcptExt extends "Warehouse Receipt"
{
    trigger OnAfterGetCurrRecord()
    begin
        Clear(Rec."Barcode No.");
        CurrPage.Update(false);
    end;
}