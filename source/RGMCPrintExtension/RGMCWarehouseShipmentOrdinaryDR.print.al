report 50100 "Warehouse Shipment"
{
    Caption = 'Warehouse Shipment';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = Warehouse;
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/WarehouseShipment.rdlc';

    dataset
    {
        dataitem(WhseShipmentHeader; "Warehouse Shipment Header")
        {
            // Define columns here
            column(No_; "No.") { }
            column(LocationCode; "Location Code") { }
            column(Posting_Date; "Posting Date") { }
            column(External_Document_No_; "External Document No.") { }
            column(DeliveredTo; DeliveredTo) { }
            column(TIN; TIN) { }
            column(BusinessStyle; BusinessStyle) { }
            column(StoreCode; StoreCode) { }
            column(Address; Address) { }
            column(VendorCode; VendorCode) { }

            dataitem("Warehouse Shipment Line"; "Warehouse Shipment Line")
            {
                DataItemLinkReference = WhseShipmentHeader;
                DataItemLink = "No." = field("No.");

                column(Qty_to_Ship; "Qty. to Ship") { }
                column(Description; Description) { }
                column(Unit_of_Measure_Code; "Unit of Measure Code") { }
                column(Source_No_; "Source No.") { }
                column(UnitPrice; "UnitPrice") { }
                column(Amount; Amount) { }

                trigger OnAfterGetRecord()
                var
                    Customer: Record Customer;
                    Location: Record Location;
                    DestinationNo: Code[20];
                    Item: Record Item;
                    whseShipmentLine: Record "Price List Line";

                begin
                    DestinationNo := "Destination No.";
                    Customer.SetRange("Location Code", "Destination No.");
                    if Customer.FindFirst() then begin
                        TIN := Customer."VAT Registration No.";
                        BusinessStyle := Customer.RAL_BusinessStyle;
                        StoreCode := Customer.RAC_StoreCode;
                    end;

                    Location.SetFilter("code", "Destination No.");
                    if Location.FindSet() then begin
                        DeliveredTo := Location.Name;
                        VendorCode := Location.RAC_VendorCode;
                        Address := Location.Address + ' ' + Location."Address 2";
                    end;

                    UnitPrice := 0;
                    Amount := 0;

                    whseShipmentLine.SetRange("Product No.", "Item No.");
                    whseShipmentLine.SetFilter("Starting Date", '..%1', WhseShipmentHeader."Posting Date");
                    whseShipmentLine.SetCurrentKey("Product No.", "Starting Date");
                    whseShipmentLine.Ascending(false);
                    if whseShipmentLine.FindFirst() then
                        UnitPrice := whseShipmentLine."LSC Unit Price Including VAT"
                    else
                        UnitPrice := 0;
                    Amount := UnitPrice * "Qty. to Ship";
                end;
            }

            trigger OnAfterGetRecord()
            var
                Customer: Record Customer;
                Location: Record Location;
            begin

                Customer.SetFilter("Location Code", "Location Code");
                if Customer.FindSet() then begin
                    DeliveredTo := Customer.Name;
                    TIN := Customer."VAT Registration No.";
                    BusinessStyle := Customer.RAL_BusinessStyle;
                    StoreCode := Customer.RAC_StoreCode;

                end;

                Location.SetFilter("Code", "Location Code");
                if Location.FindSet() then begin
                    VendorCode := Location.RAC_VendorCode;
                    Address := Location.Address + ' ' + Location."Address 2";
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
                    // Add custom fields here if needed
                }
            }
        }

        actions
        {
            // Print, Preview & Close, Send To, Cancel
            // are added AUTOMATICALLY by Business Central
        }
    }

    labels
    {
        // Labels for the report layout
    }

    var
        DeliveredTo: Text[100];
        TIN: Code[20];
        Address: Code[100];
        VendorCode: Code[20];
        BusinessStyle: Code[20];
        StoreCode: Code[20];
        UnitPrice: Decimal;
        Amount: Decimal;
}