reportextension 50103 "Transfer Receipt Ext" extends "Transfer Receipt"
{
    dataset
    {
        add("Transfer Receipt Header")
        {
            column(TransferOrderNo; "Transfer Order No.")
            {
            }
        }

        add("Transfer Receipt Line")
        {
            column(SRP; GetSRP())
            {
            }
        }
    }

    procedure GetSRP(): Decimal
    var
        PriceListLine: Record "Price List Line";
    begin
        PriceListLine.Reset();
        PriceListLine.SetRange("Product No.", "Transfer Receipt Line"."Item No.");
        PriceListLine.SetFilter("Starting Date", '..%1', "Transfer Receipt Header"."Posting Date");
        PriceListLine.SetCurrentKey("Product No.", "Starting Date");
        PriceListLine.Ascending(false);
        if PriceListLine.FindLast() then
            exit(PriceListLine."LSC Unit Price Including VAT");
        exit(0);
    end;
}