reportextension 50106 "Whse. Receipt Ext" extends "Whse. - Receipt"
{
    dataset
    {
        add("Warehouse Receipt Header")
        {
            column(PostingDate_WhseRcptHeader; Format(GetPriceDate(), 0, 4))
            {
            }
            column(SourceNos_WhseRcptHeader; GetSourceNos())
            {
            }
        }

        add("Warehouse Receipt Line")
        {
            column(UnitPrice_WhseRcptLine; GetItemUnitPrice())
            {
            }
            column(SRP_WhseRcptLine; GetSRP())
            {
            }
        }
    }

    rendering
    {
        layout(RGMCWarehouseReceipt)
        {
            Type = RDLC;
            LayoutFile = './Layouts/WarehouseReceipt.rdlc';
            Caption = 'RGMC Warehouse Receipt (with SRP)';
        }
    }

    // SRP = Unit Price of the latest active sales price line as of the posting date, excluding price list IC001 and IC prices
    procedure GetSRP(): Decimal
    var
        PriceListLine: Record "Price List Line";
        PriceDate: Date;
    begin
        if "Warehouse Receipt Line"."Item No." = '' then
            exit(0);

        PriceDate := GetPriceDate();

        PriceListLine.Reset();
        PriceListLine.SetRange("Product No.", "Warehouse Receipt Line"."Item No.");
        PriceListLine.SetRange("Price Type", PriceListLine."Price Type"::Sale);
        PriceListLine.SetRange(Status, PriceListLine.Status::Active);
        PriceListLine.SetFilter("Price List Code", '<>%1', 'IC001');
        PriceListLine.SetFilter("Assign-to No.", '<>%1', 'IC');
        PriceListLine.SetFilter("Starting Date", '..%1', PriceDate);
        PriceListLine.SetFilter("Ending Date", '%1|%2..', 0D, PriceDate);
        PriceListLine.SetCurrentKey("Product No.", "Starting Date");
        PriceListLine.SetAscending("Starting Date", false);
        if PriceListLine.FindFirst() then
            exit(PriceListLine."Unit Price");
        exit(0);
    end;

    procedure GetItemUnitPrice(): Decimal
    var
        Item: Record Item;
    begin
        Item.SetLoadFields("Unit Price");
        if Item.Get("Warehouse Receipt Line"."Item No.") then
            exit(Item."Unit Price");
        exit(0);
    end;

    procedure GetPriceDate(): Date
    begin
        if "Warehouse Receipt Header"."Posting Date" <> 0D then
            exit("Warehouse Receipt Header"."Posting Date");
        exit(WorkDate());
    end;

    procedure GetSourceNos(): Text
    var
        WhseRcptLine: Record "Warehouse Receipt Line";
        SourceNos: Text;
    begin
        WhseRcptLine.SetRange("No.", "Warehouse Receipt Header"."No.");
        WhseRcptLine.SetLoadFields("Source No.");
        if WhseRcptLine.FindSet() then
            repeat
                if (WhseRcptLine."Source No." <> '') and
                   (StrPos(', ' + SourceNos + ', ', ', ' + WhseRcptLine."Source No." + ', ') = 0)
                then
                    if SourceNos = '' then
                        SourceNos := WhseRcptLine."Source No."
                    else
                        SourceNos += ', ' + WhseRcptLine."Source No.";
            until WhseRcptLine.Next() = 0;
        exit(SourceNos);
    end;
}
