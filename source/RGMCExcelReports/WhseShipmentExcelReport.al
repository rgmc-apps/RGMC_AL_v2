report 50104 "SM DR Template"
{
    Caption = 'SM DR Template';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = Warehouse;
    DefaultLayout = Excel;
    ExcelLayout = './Layouts/SMDRTemplate.xlsx';

    dataset
    {
        dataitem(WhseShipmentHeader; "Warehouse Shipment Header")
        {
            RequestFilterFields = "No.";
            column(No_; "No.")
            {

            }

            dataitem(WhseShipmentLine; "Warehouse Shipment Line")
            {
                DataItemLinkReference = WhseShipmentHeader;
                DataItemLink = "No." = field("No.");

                column(DR_No_; DRNo)
                {
                    Caption = 'DR No.';
                }
                column(Store_Code; StoreCode)
                {
                    Caption = 'Store Code';
                }
                column(Vendor_Code; VendorCode)
                {
                    Caption = 'Vendor Code';
                }
                column(Expected_Delivery; ExpectedDelivery)
                {
                    Caption = 'Expected Delivery';
                }
                column(Dept_Code; DeptCode)
                {
                    Caption = 'Dept. Code';
                }
                column(Sub_Dept_Code; SubDeptCode)
                {
                    Caption = 'Sub-Dept Co';
                }
                column(Class_Code; ClassCode)
                {
                    Caption = 'Class Code';
                }
                column(SKU; SKU)
                {
                    Caption = 'SKU';
                }
                column(Quantity; Quantity)
                {
                    Caption = 'Quantity';
                }

                trigger OnPreDataItem()
                begin
                    SetFilter("Quantity", '<>%1', 0);
                end;

                trigger OnAfterGetRecord()
                var
                    SKUKey: Text[100];
                begin
                    ClearLineValues();

                    SetDRNo();
                    SetExpectedDelivery();
                    SetStoreCode();
                    SetSMCodeDimensions();

                    // if not FileNameSet then begin
                    //     BuildExcelFileName();
                    //     FileNameSet := true;
                    // end;

                    SKUKey := GetSKU("Item No.");

                    if SKUKey = '' then begin
                        SKU := "Item No.";
                        Quantity := "Quantity";
                    end else begin
                        SKU := SKUKey;

                        if IsDuplicateSKU(SKUKey, "No.", "Line No.") then begin
                            CurrReport.Skip();
                            exit;
                        end;

                        Quantity := GetTotalQtyToShipBySKU(SKUKey, "No.");
                    end;

                    if Quantity = 0 then
                        CurrReport.Skip();
                end;
            }
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

                    // field(ItemReferenceTypeNo; ItemReferenceTypeNo)
                    // {
                    //     ApplicationArea = All;
                    //     Caption = 'Item Reference Type No.';
                    //     ToolTip = 'Specifies the item reference type number used to find the SM SKU.';
                    // }
                }
            }
        }
    }

    var
        DRNo: Code[35];
        VendorCode: Code[20];
        StoreCode: Code[20];
        ExpectedDelivery: Text[20];
        DeptCode: Integer;
        SubDeptCode: Integer;
        ClassCode: Integer;
        SKU: Text[100];
        Quantity: Decimal;
        ItemReferenceTypeNo: Code[20];
        ExcelFileName: Text;
        FileNameSet: Boolean;

    trigger OnInitReport()
    begin
        ItemReferenceTypeNo := 'SM';
    end;

    local procedure ClearLineValues()
    begin
        DRNo := '';
        VendorCode := '';
        StoreCode := '';
        ExpectedDelivery := '';
        DeptCode := 0;
        SubDeptCode := 0;
        ClassCode := 0;
        SKU := '';
        Quantity := 0;
    end;

    local procedure SetDRNo()
    begin
        DRNo := WhseShipmentHeader."External Document No.";

        if DRNo = '' then
            DRNo := WhseShipmentHeader."No.";
    end;

    local procedure SetExpectedDelivery()
    var
        ExpectedDate: Date;
    begin
        ExpectedDate := WhseShipmentHeader."Shipment Date";

        if ExpectedDate = 0D then
            ExpectedDate := WhseShipmentHeader."Posting Date";

        if ExpectedDate <> 0D then
            ExpectedDelivery := Format(ExpectedDate, 0, '<Month,2><Day,2><Year,2>');
    end;

    // local procedure BuildExcelFileName()
    // var
    //     UploadDateText: Text;
    // begin

    //     UploadDateText := Format(Today, 0, '<Month,2><Day,2><Year4>');
    //     ExcelFileName := 'CSGRCW' + '_' +
    //                      VendorCode + '_' +
    //                      StoreCode + '_' +
    //                      DRNo + '_' +
    //                      UploadDateText;

    //     CurrReport.Caption := ExcelFileName;
    // end;

    local procedure SetStoreCode()
    var
        Location: Record Location;
        Customer: Record Customer;
        DestinationNo: Code[20];
    begin
        DestinationNo := WhseShipmentLine."Destination No.";

        if DestinationNo = '' then
            DestinationNo := WhseShipmentHeader."Location Code";

        if Location.Get(DestinationNo) then begin
            StoreCode := Location."Store Code";
            VendorCode := Location."RAC_VendorCode";

        end;
    end;

    local procedure SetSMCodeDimensions()
    var
        Location: Record Location;
        Customer: Record Customer;
        DestinationNo: Code[20];
    begin
        DestinationNo := WhseShipmentLine."Destination No.";

        Customer.Reset();
        Customer.SetRange("Location Code", DestinationNo);
        if Customer.FindFirst() then begin
            DeptCode := Customer."Dept Code";
            SubDeptCode := Customer."Sub Dept Code";
            ClassCode := Customer."Class Code";
        end;
    end;



    local procedure GetSKU(ItemNo: Code[20]): Text[100]
    var
        ItemRef: Record "Item Reference";
    begin
        ItemRef.SetRange("Item No.", ItemNo);
        ItemRef.SetRange("Reference Type", ItemRef."Reference Type"::"Bar Code");
        ItemRef.SetRange("Reference Type No.", 'SM-DS');

        if ItemRef.FindFirst() then begin
            if ItemRef.Description <> '' then
                exit(ItemRef.Description);

            exit(ItemRef."Reference No.");
        end;

        exit('');
    end;

    local procedure IsDuplicateSKU(CurrentSKU: Text[100]; ShipmentNo: Code[20]; CurrentLineNo: Integer): Boolean
    var
        ShipmentLine: Record "Warehouse Shipment Line";
    begin
        if CurrentSKU = '' then
            exit(false);

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