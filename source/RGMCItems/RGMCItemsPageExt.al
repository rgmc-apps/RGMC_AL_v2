pageextension 50101 ItemListExt extends "Item List"
{
    layout
    {
        addbefore("Vendor No.")
        {
            field("Latest Retail Price"; LatestRetailPrice)
            {
                ApplicationArea = All;
                Caption = 'Current Retail Price';
                Editable = false;
            }
        }
    }

    var
        LatestRetailPrice: Decimal;

    trigger OnAfterGetRecord()
    var
        PriceLine: Record "Price List Line";
    begin
        LatestRetailPrice := 0;

        PriceLine.Reset();
        PriceLine.SetFilter("Assign-to No.", '<>%1', 'IC');
        PriceLine.SetRange("Product No.", Rec."No.");
        PriceLine.SetCurrentKey("Product No.", "Starting Date");
        PriceLine.SetAscending("Starting Date", false);

        if PriceLine.FindFirst() then
            LatestRetailPrice := PriceLine."LSC Unit Price Including VAT";
    end;
}