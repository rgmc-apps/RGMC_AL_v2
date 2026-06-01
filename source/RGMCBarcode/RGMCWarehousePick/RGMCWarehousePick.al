pageextension 50121 RGMCWarehouseExt extends "Warehouse Pick"
{
    trigger OnAfterGetCurrRecord()
    begin
        Clear(Rec."Barcode No.");
        CurrPage.Update(false);
    end;
}