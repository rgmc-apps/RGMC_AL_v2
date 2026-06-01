pageextension 50109 TransferOrderSubformExt extends "Transfer Order Subform"
{
    layout
    {
        addbefore(Quantity)
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

        if Rec."Item No." <> '' then begin
            PriceLine.Reset();
            PriceLine.SetRange("Product No.", Rec."Item No.");
            PriceLine.SetCurrentKey("Product No.", "Starting Date");
            PriceLine.SetAscending("Starting Date", false);

            if PriceLine.FindFirst() then
                LatestRetailPrice := PriceLine."LSC Unit Price Including VAT";
        end;
    end;
}
