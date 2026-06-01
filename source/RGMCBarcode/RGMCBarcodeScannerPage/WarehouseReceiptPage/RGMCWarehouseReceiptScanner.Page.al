page 50126 "Warehouse Receipt Scanner"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Tasks;
    SourceTable = "Warehouse Receipt Header";
    Caption = 'Warehouse Receipt Scanner';

    layout
    {
        area(Content)
        {
            group(Scanning)
            {
                Caption = 'Barcode Scanning';

                field(BarcodeTxt; BarcodeTxt)
                {
                    ApplicationArea = All;
                    Caption = 'Barcode';
                    QuickEntry = true;

                    trigger OnValidate()
                    var
                        InputBarcode: Code[50];
                    begin
                        if BarcodeTxt = '' then
                            exit;

                        InputBarcode := BarcodeTxt;

                        // CLEAR FIRST
                        Clear(BarcodeTxt);
                        CurrPage.Update(false);

                        // PROCESS SCAN
                        ProcessScan(InputBarcode);

                        // FORCE READY FOR NEXT SCAN
                        BarcodeTxt := '';
                        CurrPage.Update(false);
                    end;
                }

                field(ItemDesc; ItemDesc)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Item Description';
                }

                field(SalesPrice; SalesPrice)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Sales Price';
                }

                field(QtyToReceive; QtyToReceive)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Qty. to Receive';
                }

                field(RemainingQty; RemainingQty)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Remaining Qty';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(CloseScanner)
            {
                ApplicationArea = All;
                Caption = 'Close';

                trigger OnAction()
                begin
                    CurrPage.Close();
                end;
            }
        }
    }

    var
        BarcodeTxt: Code[50];
        ItemDesc: Text[100];
        SalesPrice: Decimal;
        QtyToReceive: Decimal;
        RemainingQty: Decimal;

    local procedure ProcessScan(BarcodeInput: Code[50])
    var
        ReceiptLine: Record "Warehouse Receipt Line";
        ItemRec: Record Item;
        PriceLine: Record "Price List Line";
        Barcode: Code[20];
        QtyToProcess: Decimal;
        ScanQty: Decimal;
        RemainingPerLine: Decimal;
        TotalRemaining: Decimal;
    begin
        ScanQty := 1;

        // RESET DISPLAY
        ItemDesc := '';
        SalesPrice := 0;
        QtyToReceive := 0;
        RemainingQty := 0;

        // VALIDATE ITEM
        ItemRec.Reset();
        ItemRec.SetRange("No.", BarcodeInput);

        if not ItemRec.FindFirst() then
            Error('Invalid barcode: %1', BarcodeInput);

        Barcode := ItemRec."No.";

        // GET SALES PRICE
        PriceLine.Reset();
        PriceLine.SetRange("Product No.", Barcode);
        PriceLine.SetCurrentKey("Product No.", "Starting Date");
        PriceLine.Ascending(false);

        if PriceLine.FindFirst() then
            SalesPrice := PriceLine."Unit Price"
        else
            SalesPrice := 0;

        // GET RECEIPT LINES
        ReceiptLine.Reset();
        ReceiptLine.SetRange("No.", Rec."No.");
        ReceiptLine.SetRange("Item No.", Barcode);

        if not ReceiptLine.FindSet() then
            Error('Item not found in warehouse receipt.');

        // =========================================
        // CHECK IF EXCESS SCAN
        // =========================================
        TotalRemaining := 0;

        repeat
            TotalRemaining += ReceiptLine.Quantity;
        until ReceiptLine.Next() = 0;

        if TotalRemaining <= 0 then
            Error(
                'Item %1 is already fully received. Excess scanning is not allowed.',
                Barcode);

        // RE-READ LINES
        ReceiptLine.Reset();
        ReceiptLine.SetRange("No.", Rec."No.");
        ReceiptLine.SetRange("Item No.", Barcode);

        if ReceiptLine.FindSet() then
            repeat
                if ScanQty <= 0 then
                    break;

                RemainingPerLine := ReceiptLine.Quantity;

                if RemainingPerLine > 0 then begin
                    QtyToProcess := RemainingPerLine;

                    if QtyToProcess > ScanQty then
                        QtyToProcess := ScanQty;

                    // UPDATE WAREHOUSE RECEIPT LINE QTY TO RECEIVE
                    ReceiptLine.Validate(
                        "Qty. to Receive",
                        ReceiptLine."Qty. to Receive" + QtyToProcess);

                    ReceiptLine.Modify(true);

                    ScanQty -= QtyToProcess;

                    // DISPLAY VALUES
                    ItemDesc := ReceiptLine.Description;
                    QtyToReceive := ReceiptLine."Qty. to Receive";
                end;
            until ReceiptLine.Next() = 0;

        // GET REMAINING QTY
        RemainingQty := GetRemainingQty(Barcode);

        // FORCE PAGE REFRESH
        CurrPage.Update(false);
    end;

    local procedure GetRemainingQty(ItemNo: Code[20]): Decimal
    var
        Line: Record "Warehouse Receipt Line";
        Total: Decimal;
    begin
        Total := 0;

        Line.Reset();
        Line.SetRange("No.", Rec."No.");
        Line.SetRange("Item No.", ItemNo);

        if Line.FindSet() then
            repeat
                Total += Line.Quantity - Line."Qty. Received" - Line."Qty. to Receive";
            until Line.Next() = 0;

        exit(Total);
    end;
}
