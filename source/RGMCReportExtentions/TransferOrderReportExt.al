reportextension 50105 "Transfer Order Ext" extends "Transfer Order"
{
    dataset
    {
        add("Transfer line")
        {
            column(CurrentRetailPrice; CurrentRetailPrice)
            {
                Caption = 'Current Retail Price';
            }
        }

        modify("Transfer line")
        {
            trigger OnAfterAfterGetRecord()
            var
                PriceLine: Record "Price List Line";
            begin
                CurrentRetailPrice := 0;

                if "Item No." <> '' then begin
                    PriceLine.Reset();
                    PriceLine.SetFilter("Assign-to No.", '<>%1', 'IC');
                    PriceLine.SetRange("Product No.", "Item No.");
                    PriceLine.SetCurrentKey("Product No.", "Starting Date");
                    PriceLine.SetAscending("Starting Date", false);

                    if PriceLine.FindFirst() then
                        CurrentRetailPrice := PriceLine."LSC Unit Price Including VAT";
                end;
            end;
        }
    }

    var
        CurrentRetailPrice: Decimal;
}