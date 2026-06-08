page 50210 "RGMC Item Price API"
{
    PageType = API;
    APIPublisher = 'rgmc';
    APIGroup = 'rgmccustom';
    APIVersion = 'v1.0';
    EntityName = 'itemPrice';
    EntitySetName = 'itemPrices';
    Caption = 'RGMC Item Price API';

    SourceTable = "Price List Line";
    ODataKeyFields = SystemId;

    DelayedInsert = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            field(id; Rec.SystemId)
            {
                Caption = 'id';
                Editable = false;
            }
            field(priceListCode; Rec."Price List Code")
            {
                Caption = 'priceListCode';
                Editable = false;
            }
            field(productNo; Rec."Product No.")
            {
                Caption = 'productNo';
                Editable = false;
            }
            field(startingDate; Rec."Starting Date")
            {
                Caption = 'startingDate';
                Editable = false;
            }
            field(endingDate; Rec."Ending Date")
            {
                Caption = 'endingDate';
                Editable = false;
            }
            field(unitPrice; Rec."Unit Price")
            {
                Caption = 'unitPrice';
                Editable = false;
            }
            field(unitPriceIncVAT; Rec."LSC Unit Price Including VAT")
            {
                Caption = 'unitPriceIncVAT';
                Editable = false;
            }
            field(assignToNo; Rec."Assign-to No.")
            {
                Caption = 'assignToNo';
                Editable = false;
            }
            field(currencyCode; Rec."Currency Code")
            {
                Caption = 'currencyCode';
                Editable = false;
            }
            field(unitOfMeasureCode; Rec."Unit of Measure Code")
            {
                Caption = 'unitOfMeasureCode';
                Editable = false;
            }
            field(minimumQuantity; Rec."Minimum Quantity")
            {
                Caption = 'minimumQuantity';
                Editable = false;
            }
        }
    }
}
