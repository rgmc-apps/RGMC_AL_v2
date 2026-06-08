report 50105 "SM Pull out Template"
{
    Caption = 'SM Pull out Template';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = Warehouse;
    DefaultLayout = Excel;
    ExcelLayout = './Layouts/SMPulloutTemplate.xlsx';

    dataset
    {
        dataitem(TransferHeader; "Transfer Header")
        {
            RequestFilterFields = "No.";
            column(No_; "No.")
            {

            }

            dataitem(TransferLine; "Transfer Line")
            {
                DataItemLinkReference = TransferHeader;
                DataItemLink = "Document No." = field("No.");

                column(Vendor_Code; VendorCode)
                {
                    Caption = 'Vendor Code';
                }
                column(SCPOA_NO; SCPOANo)
                {
                    Caption = 'SCPOA No.';
                }
                column(Store_Code; StoreCode)
                {
                    Caption = 'Store Code';
                }
                column(Expected_Pull_Out_Date; ExpectedPullOutDate)
                {
                    Caption = 'Expected Pull Out Date';
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
                column(Boxes; Boxes)
                {
                    Caption = 'Boxes';
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

                    SetSCPOANo();
                    SetExpectedPullOutDate();
                    SetStoreCode();
                    SetSMCodeDimensions();


                    SKUKey := GetSKU("Item No.");

                    if SKUKey = '' then begin
                        SKU := "Item No.";
                        Quantity := "Quantity";
                    end else begin
                        SKU := SKUKey;

                        if IsDuplicateSKU(SKUKey, "Document No.", "Line No.") then begin
                            CurrReport.Skip();
                            exit;
                        end;

                        Quantity := GetTotalQtyToShipBySKU(SKUKey, "Document No.");
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
        SCPOANo: Code[35];
        VendorCode: Code[20];
        StoreCode: Code[20];
        ExpectedPullOutDate: Text[20];
        DeptCode: Integer;
        SubDeptCode: Integer;
        ClassCode: Integer;
        Boxes: Integer;
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
        SCPOANo := '';
        VendorCode := '';
        StoreCode := '';
        ExpectedPullOutDate := '';
        DeptCode := 0;
        SubDeptCode := 0;
        ClassCode := 0;
        SKU := '';
        Quantity := 0;
        Boxes := 0;
    end;

    local procedure SetSCPOANo()
    begin
        SCPOANo := TransferHeader."External Document No.";

        if SCPOANo = '' then
            SCPOANo := TransferHeader."No.";
    end;

    local procedure SetExpectedPullOutDate()
    var
        ExpectedDate: Date;
    begin

        if ExpectedDate = 0D then
            ExpectedDate := TransferHeader."Posting Date" + 15;

        if ExpectedDate <> 0D then
            ExpectedPullOutDate := Format(ExpectedDate, 0, '<Month,2><Day,2><Year,2>');

    end;

    local procedure SetStoreCode()
    var
        Location: Record Location;
        Customer: Record Customer;
        DestinationNo: Code[20];
    begin

        if DestinationNo = '' then
            DestinationNo := TransferLine."Transfer-from Code";

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
        DestinationNo := TransferLine."Transfer-from Code";

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
        ShipmentLine: Record "Transfer Line";
    begin
        if CurrentSKU = '' then
            exit(false);

        ShipmentLine.SetRange("Document No.", ShipmentNo);
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
        ShipmentLine: Record "Transfer Line";
        TotalQtyToShip: Decimal;
    begin
        ShipmentLine.SetRange("Document No.", ShipmentNo);

        if ShipmentLine.FindSet() then
            repeat
                if GetSKU(ShipmentLine."Item No.") = CurrentSKU then
                    TotalQtyToShip += ShipmentLine."Qty. to Ship";
            until ShipmentLine.Next() = 0;

        exit(TotalQtyToShip);
    end;
}