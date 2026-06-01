report 50101 "Print LMDR"
{
    Caption = 'Print LMDR';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = Warehouse;
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/PrintLMDR.rdlc';
    dataset
    {
        dataitem(WhseShipmentHeader; "Warehouse Shipment Header")
        {
            column(No_; "No.") { }
            column(LocationCode; LocationCode) { }
            column(Posting_Date; "Posting Date") { }
            column(External_Document_No_; "External Document No.") { }
            column(DeliveredTo; DeliveredTo) { }
            column(CompanyName; CompanyName) { }
            column(CompanyAddress; CompanyAddress) { }
            column(CompanyVAT; CompanyVAT) { }

            dataitem(WhseShipmentLine; "Warehouse Shipment Line")
            {
                DataItemLinkReference = WhseShipmentHeader;
                DataItemLink = "No." = field("No.");

                column(Qty_to_Ship; QtyToShip) { }
                column(Unit_of_Measure_Code; "Unit of Measure Code") { }
                column(SKU; SKU) { }
                column(BarcodeTag; BarcodeTag) { }
                column(BarcodeText; BarcodeText) { }
                column(Description2; Description2) { }
                column(UnitPrice; UnitPrice) { }
                column(Amount; Amount) { }

                trigger OnAfterGetRecord()
                var
                    Location: Record Location;
                    WhseShipmentLinePrice: Record "Price List Line";
                    ItemRef: Record "Item Reference";
                    BarcodeString: Text;
                    BarcodeFontProvider: Interface "Barcode Font Provider";

                begin
                    // Default values
                    SKU := '';
                    BarcodeTag := '';
                    BarcodeFontProvider := Enum::"Barcode Font Provider"::IDAutomation1D;
                    Description2 := '';
                    QtyToShip := 0;
                    UnitPrice := 0;
                    Amount := 0;

                    // Get Item Reference
                    ItemRef.SetRange("Item No.", "Item No.");
                    ItemRef.SetRange("Reference Type", ItemRef."Reference Type"::"Bar Code");
                    ItemRef.SetRange("Reference Type No.", 'LM');

                    if ItemRef.FindFirst() then begin
                        SKU := ItemRef.Description;
                        BarcodeTag := ItemRef."Reference No.";
                        Description2 := ItemRef."Description 2";
                    end;

                    if SKU = '' then
                        QtyToShip := "Qty. to Ship"
                    else begin
                        if IsDuplicateSKU(SKU, "No.", "Line No.") then begin
                            CurrReport.Skip();
                            exit;
                        end;

                        QtyToShip := GetTotalQtyToShipBySKU(SKU, "No.");
                    end;

                    // Encode barcode
                    BarcodeString := "BarcodeTag";
                    // Validate the input
                    BarcodeFontProvider.ValidateInput(BarcodeString, BarcodeSymbology);
                    BarcodeTag := BarcodeFontProvider.EncodeFont(BarcodeString, BarcodeSymbology);

                    // Delivered To
                    Location.SetRange(Code, "Destination No.");

                    if Location.FindFirst() then
                        DeliveredTo := Location.Name;
                    LocationCode := Location.RAC_VendorCode;


                    // Find latest price as of posting date
                    WhseShipmentLinePrice.SetRange("Product No.", "Item No.");
                    WhseShipmentLinePrice.SetFilter(
                        "Starting Date",
                        '..%1',
                        WhseShipmentHeader."Posting Date");

                    WhseShipmentLinePrice.SetCurrentKey(
                        "Product No.",
                        "Starting Date");

                    WhseShipmentLinePrice.Ascending(false);

                    if WhseShipmentLinePrice.FindFirst() then
                        UnitPrice := WhseShipmentLinePrice."LSC Unit Price Including VAT"
                    else
                        UnitPrice := 0;

                    Amount := UnitPrice * QtyToShip;

                end;
            }


            trigger OnAfterGetRecord()
            var
                CompanyInfo: Record "Company Information";
            begin
                CompanyName := '';
                CompanyAddress := '';
                CompanyVAT := '';

                if CompanyInfo.FindFirst() then begin
                    CompanyName := CompanyInfo.Name;

                    CompanyAddress :=
                        CompanyInfo.Address + ' ' +
                        CompanyInfo.City + ' ' +
                        CompanyInfo."Post Code";

                    CompanyVAT := CompanyInfo."VAT Registration No.";
                end;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';
                }
            }
        }
    }

    var
        DeliveredTo: Text[100];
        LocationCode: Code[20];
        CompanyName: Text[100];
        CompanyAddress: Text[250];
        CompanyVAT: Code[20];
        SKU: Text[100];
        BarcodeSymbology: Enum "Barcode Symbology";
        BarcodeTag: Text[100];
        BarcodeText: Text[250];
        Description2: Text[250];
        QtyToShip: Decimal;
        UnitPrice: Decimal;
        Amount: Decimal;

    trigger OnInitReport()
    begin
        BarcodeSymbology := Enum::"Barcode Symbology"::Code39;
    end;

    local procedure GetSKU(ItemNo: Code[20]): Text[100]
    var
        ItemRef: Record "Item Reference";
    begin
        ItemRef.SetRange("Item No.", ItemNo);
        ItemRef.SetRange("Reference Type", ItemRef."Reference Type"::"Bar Code");
        ItemRef.SetRange("Reference Type No.", 'LM');

        if ItemRef.FindFirst() then
            exit(ItemRef.Description);

        exit('');
    end;

    local procedure IsDuplicateSKU(CurrentSKU: Text[100]; ShipmentNo: Code[20]; CurrentLineNo: Integer): Boolean
    var
        ShipmentLine: Record "Warehouse Shipment Line";
    begin
        ShipmentLine.SetRange("No.", ShipmentNo);
        ShipmentLine.SetFilter("Line No.", '<%1', CurrentLineNo);

        if ShipmentLine.FindSet() then
            repeat
                if GetSKU(ShipmentLine."Item No.") = CurrentSKU then
                    exit(true);
            until ShipmentLine.Next() = 0;

        exit(false);
    end;

    local procedure GetTotalQtyToShipBySKU(CurrentSKU: Text[100]; ShipmentNo: Code[20]): Decimal
    var
        ShipmentLine: Record "Warehouse Shipment Line";
        TotalQtyToShip: Decimal;
    begin
        ShipmentLine.SetRange("No.", ShipmentNo);

        if ShipmentLine.FindSet() then
            repeat
                if GetSKU(ShipmentLine."Item No.") = CurrentSKU then
                    TotalQtyToShip += ShipmentLine."Qty. to Ship";
            until ShipmentLine.Next() = 0;

        exit(TotalQtyToShip);
    end;
}
