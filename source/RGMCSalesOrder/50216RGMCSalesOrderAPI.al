using Microsoft.Sales.Document;

page 50216 "RGMC Sales Order API"
{
    PageType = API;
    APIPublisher = 'rgmc';
    APIGroup = 'rgmccustom';
    APIVersion = 'v1.0';
    EntityName = 'salesOrder';
    EntitySetName = 'salesOrders';
    Caption = 'RGMC Sales Order API';

    SourceTable = "Sales Header";
    SourceTableView = where("Document Type" = const("Order"));
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
            field(requestedDeliveryDate; Rec."Requested Delivery Date")
            {
                Caption = 'requestedDeliveryDate';
            }

            // --- Posting ---
            field(locationCode; Rec."Location Code")
            {
                Caption = 'locationCode';
            }
            field(salespersonCode; Rec."Salesperson Code")
            {
                Caption = 'salespersonCode';
            }
            field(shortcutDimension1Code; Rec."Shortcut Dimension 1 Code")
            {
                Caption = 'shortcutDimension1Code';
            }
            field(shortcutDimension2Code; Rec."Shortcut Dimension 2 Code")
            {
                Caption = 'shortcutDimension2Code';
            }

            // --- Custom Fields ---
            field(submittedBy; Rec."Submitted By")
            {
                Caption = 'submittedBy';
            }

            // --- Audit ---
            field(lastModifiedDateTime; Rec.SystemModifiedAt)
            {
                Caption = 'lastModifiedDateTime';
                Editable = false;
            }

            // --- Lines (embedded sub-resource) ---
            part(salesOrderLines; "RGMC Sales Order Lines API")
            {
                Caption = 'Lines';
                EntityName = 'salesOrderLine';
                EntitySetName = 'salesOrderLines';
                SubPageLink = "Document Type" = const("Order"),
                              "Document No." = field("No.");
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Document Type" := Rec."Document Type"::Order;
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
            Error('Sales Order %1 is Released. Reopen it before making changes.', Rec."No.");
        exit(true);
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        if Rec.Status = Rec.Status::Released then
            Error('Sales Order %1 cannot be deleted while in Released status.', Rec."No.");
        exit(true);
    end;
}
