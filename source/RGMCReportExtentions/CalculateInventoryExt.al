reportextension 50104 "Calc Inventory Ext" extends "Calculate Inventory"
{
    dataset
    {
        modify("Item Ledger Entry")
        {
            trigger OnBeforePreDataItem()
            begin
                SetFilter("Posting Date", '..%1', PostingDate);
            end;
        }

        modify("Warehouse Entry")
        {
            trigger OnBeforePreDataItem()
            begin
                SetFilter("Registering Date", '..%1', PostingDate);
            end;
        }
    }
}