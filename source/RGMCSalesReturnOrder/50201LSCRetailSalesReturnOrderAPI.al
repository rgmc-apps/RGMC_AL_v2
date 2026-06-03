using Microsoft.Sales.Document;

page 50201 "LSC Retail SRO API"
{
    PageType = API;
    APIPublisher = 'rgmc';
    APIGroup = 'rgmccustom';
    APIVersion = 'v1.0';
    EntityName = 'salesReturnOrder';
    EntitySetName = 'salesReturnOrders';
    Caption = 'LSC Retail Sales Return Order API';

    SourceTable = "Sales Header";
    SourceTableView = where("Document Type" = const("Return Order"));
    ODataKeyFields = SystemId;

    DelayedInsert = true;
    InsertAllowed = true;
    ModifyAllowed = true;
    DeleteAllowed = true;

    layout
    {
        area(Content)
        {
            // --- Identity ---
            field(id; Rec.SystemId)
            {
                Caption = 'id';
                Editable = false;
            }
            field(number; Rec."No.")
            {
                Caption = 'number';
            }
            field(status; Rec.Status)
            {
                Caption = 'status';
                Editable = false;
            }
            field(externalDocumentNo; Rec."External Document No.")
            {
                Caption = 'externalDocumentNo';
            }

            // --- Sell-to Customer ---
            field(sellToCustomerNo; Rec."Sell-to Customer No.")
            {
                Caption = 'sellToCustomerNo';
            }
            field(sellToCustomerName; Rec."Sell-to Customer Name")
            {
                Caption = 'sellToCustomerName';
                Editable = false;
            }
            field(sellToContactNo; Rec."Sell-to Contact No.")
            {
                Caption = 'sellToContactNo';
            }
            field(sellToContact; Rec."Sell-to Contact")
            {
                Caption = 'sellToContact';
                Editable = false;
            }
            field(sellToAddress; Rec."Sell-to Address")
            {
                Caption = 'sellToAddress';
            }
            field(sellToAddress2; Rec."Sell-to Address 2")
            {
                Caption = 'sellToAddress2';
            }
            field(sellToPostCode; Rec."Sell-to Post Code")
            {
                Caption = 'sellToPostCode';
            }
            field(sellToCity; Rec."Sell-to City")
            {
                Caption = 'sellToCity';
            }

            // --- Bill-to ---
            field(billToCustomerNo; Rec."Bill-to Customer No.")
            {
                Caption = 'billToCustomerNo';
            }
            field(billToName; Rec."Bill-to Name")
            {
                Caption = 'billToName';
                Editable = false;
            }
            field(billToContactNo; Rec."Bill-to Contact No.")
            {
                Caption = 'billToContactNo';
            }
            field(billToContact; Rec."Bill-to Contact")
            {
                Caption = 'billToContact';
                Editable = false;
            }
            field(billToAddress; Rec."Bill-to Address")
            {
                Caption = 'billToAddress';
            }
            field(billToAddress2; Rec."Bill-to Address 2")
            {
                Caption = 'billToAddress2';
            }
            field(billToPostCode; Rec."Bill-to Post Code")
            {
                Caption = 'billToPostCode';
            }
            field(billToCity; Rec."Bill-to City")
            {
                Caption = 'billToCity';
            }
            field(billToCountryRegionCode; Rec."Bill-to Country/Region Code")
            {
                Caption = 'billToCountryRegionCode';
            }

            // --- Ship-to ---
            field(shipToCode; Rec."Ship-to Code")
            {
                Caption = 'shipToCode';
            }
            field(shipToName; Rec."Ship-to Name")
            {
                Caption = 'shipToName';
            }
            field(shipToAddress; Rec."Ship-to Address")
            {
                Caption = 'shipToAddress';
            }
            field(shipToAddress2; Rec."Ship-to Address 2")
            {
                Caption = 'shipToAddress2';
            }
            field(shipToPostCode; Rec."Ship-to Post Code")
            {
                Caption = 'shipToPostCode';
            }
            field(shipToCity; Rec."Ship-to City")
            {
                Caption = 'shipToCity';
            }
            field(shipToCountryRegionCode; Rec."Ship-to Country/Region Code")
            {
                Caption = 'shipToCountryRegionCode';
            }
            field(shipToContact; Rec."Ship-to Contact")
            {
                Caption = 'shipToContact';
            }

            // --- Dates ---
            field(postingDate; Rec."Posting Date")
            {
                Caption = 'postingDate';
            }
            field(orderDate; Rec."Order Date")
            {
                Caption = 'orderDate';
            }
            field(documentDate; Rec."Document Date")
            {
                Caption = 'documentDate';
            }
            field(shipmentDate; Rec."Shipment Date")
            {
                Caption = 'shipmentDate';
            }

            // --- Financials / Posting ---
            field(pricesIncludingVat; Rec."Prices Including VAT")
            {
                Caption = 'pricesIncludingVat';
            }
            field(vatBusPostingGroup; Rec."VAT Bus. Posting Group")
            {
                Caption = 'vatBusPostingGroup';
            }
            field(locationCode; Rec."Location Code")
            {
                Caption = 'locationCode';
            }
            field(salespersonCode; Rec."Salesperson Code")
            {
                Caption = 'salespersonCode';
            }
            field(campaignNo; Rec."Campaign No.")
            {
                Caption = 'campaignNo';
            }
            field(responsibilityCenter; Rec."Responsibility Center")
            {
                Caption = 'responsibilityCenter';
            }
            field(shortcutDimension1Code; Rec."Shortcut Dimension 1 Code")
            {
                Caption = 'shortcutDimension1Code';
            }
            field(shortcutDimension2Code; Rec."Shortcut Dimension 2 Code")
            {
                Caption = 'shortcutDimension2Code';
            }

            // --- Audit ---
            field(lastModifiedDateTime; Rec.SystemModifiedAt)
            {
                Caption = 'lastModifiedDateTime';
                Editable = false;
            }

            // --- Lines (embedded sub-resource) ---
            part(salesReturnOrderLines; "LSC Retail SRO Lines API")
            {
                Caption = 'Lines';
                EntityName = 'salesReturnOrderLine';
                EntitySetName = 'salesReturnOrderLines';
                SubPageLink = "Document Type" = const("Return Order"),
                              "Document No." = field("No.");
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Document Type" := Rec."Document Type"::"Return Order";
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.TestField("Sell-to Customer No.");
        Rec.TestField("Posting Date");
        exit(true);
    end;

    trigger OnModifyRecord(): Boolean
    begin
        if Rec.Status = Rec.Status::Released then
            Error('Return Order %1 is Released. Reopen it before making changes.', Rec."No.");
        exit(true);
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        if Rec.Status = Rec.Status::Released then
            Error('Return Order %1 cannot be deleted while in Released status.', Rec."No.");
        exit(true);
    end;
}
