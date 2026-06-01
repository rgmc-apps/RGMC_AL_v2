page 50102 "Warehouse Pick Scanner"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Tasks;
    SourceTable = "Warehouse Activity Header";
    Caption = 'Warehouse Scanner';

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

                field(QtyToShip; QtyToShip)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Qty. To Handle';
                }

                field(QtyHandled; QtyHandled)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Qty. Handled';
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
        QtyToShip: Decimal;
        QtyHandled: Decimal;
        RemainingQty: Decimal;

    local procedure ProcessScan(BarcodeInput: Code[50])
    var
        TakeLine: Record "Warehouse Activity Line";
        PlaceLine: Record "Warehouse Activity Line";
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
        QtyToShip := 0;
        QtyHandled := 0;
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

        // GET TAKE LINES
        TakeLine.Reset();
        TakeLine.SetRange("No.", Rec."No.");
        TakeLine.SetRange("Item No.", Barcode);
        TakeLine.SetRange("Action Type", TakeLine."Action Type"::Take);

        if not TakeLine.FindSet() then
            Error('Item not found in warehouse pick.');

        // =========================================
        // CHECK IF EXCESS SCAN
        // =========================================
        TotalRemaining := 0;

        repeat
            TotalRemaining +=
                TakeLine."Qty. Outstanding" -
                TakeLine."Qty. to Handle";
        until TakeLine.Next() = 0;

        if TotalRemaining <= 0 then
            Error(
                'Item %1 is already fully scanned. Excess scanning is not allowed.',
                Barcode);

        // RE-READ LINES
        TakeLine.Reset();
        TakeLine.SetRange("No.", Rec."No.");
        TakeLine.SetRange("Item No.", Barcode);
        TakeLine.SetRange("Action Type", TakeLine."Action Type"::Take);

        if TakeLine.FindSet() then
            repeat

                if ScanQty <= 0 then
                    break;

                RemainingPerLine :=
                    TakeLine."Qty. Outstanding" -
                    TakeLine."Qty. to Handle";

                if RemainingPerLine > 0 then begin

                    QtyToProcess := RemainingPerLine;

                    if QtyToProcess > ScanQty then
                        QtyToProcess := ScanQty;

                    // =========================================
                    // UPDATE TAKE LINE
                    // =========================================
                    TakeLine.Validate(
                        "Qty. to Handle",
                        TakeLine."Qty. to Handle" + QtyToProcess);

                    TakeLine.Modify(true);

                    // =========================================
                    // UPDATE MATCHING PLACE LINE
                    // =========================================
                    PlaceLine.Reset();
                    PlaceLine.SetRange("No.", TakeLine."No.");
                    PlaceLine.SetRange("Item No.", TakeLine."Item No.");
                    PlaceLine.SetRange(
                        "Action Type",
                        PlaceLine."Action Type"::Place);

                    PlaceLine.SetFilter(
                        "Line No.",
                        '>%1',
                        TakeLine."Line No.");

                    if PlaceLine.FindFirst() then begin

                        PlaceLine.Validate(
                            "Qty. to Handle",
                            PlaceLine."Qty. to Handle" + QtyToProcess);

                        PlaceLine.Modify(true);
                    end;

                    ScanQty -= QtyToProcess;

                    // DISPLAY VALUES
                    ItemDesc := TakeLine.Description;
                    QtyToShip := TakeLine."Qty. to Handle";
                    QtyHandled := TakeLine."Qty. Handled";
                end;

            until TakeLine.Next() = 0;

        // REFRESH FLOWFIELDS
        Rec.CalcFields(
            "Calculated Quantity",
            "Calculated Qty Handle",
            "Calculated Qty Handled");

        // GET REMAINING QTY
        RemainingQty := GetRemainingQty(Barcode);

        // FORCE PAGE REFRESH
        CurrPage.Update(false);
    end;

    local procedure GetRemainingQty(ItemNo: Code[20]): Decimal
    var
        Line: Record "Warehouse Activity Line";
        Total: Decimal;
    begin
        Total := 0;

        Line.Reset();
        Line.SetRange("No.", Rec."No.");
        Line.SetRange("Item No.", ItemNo);
        Line.SetRange("Action Type", Line."Action Type"::Take);

        if Line.FindSet() then
            repeat
                Total +=
                    Line."Qty. Outstanding" -
                    Line."Qty. to Handle";
            until Line.Next() = 0;

        exit(Total);
    end;
}