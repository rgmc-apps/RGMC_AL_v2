using Microsoft.Inventory.Item;

page 50205 "LSC Retail Item API"
{
    PageType = API;
    APIPublisher = 'rgmc';
    APIGroup = 'rgmccustom';
    APIVersion = 'v1.0';
    EntityName = 'item';
    EntitySetName = 'items';
    Caption = 'LSC Retail Item API';

    SourceTable = Item;
    ODataKeyFields = SystemId;

    DelayedInsert = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

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
                Editable = false;
            }

            // --- Description ---
            field(description; Rec.Description)
            {
                Caption = 'description';
                Editable = false;
            }
            field(description2; Rec."Description 2")
            {
                Caption = 'description2';
                Editable = false;
            }

            // --- Classification ---
            field(itemCategoryCode; Rec."Item Category Code")
            {
                Caption = 'itemCategoryCode';
                Editable = false;
            }
            field(familyCode; Rec."LSC Item Family Code")
            {
                Caption = 'familyCode';
                Editable = false;
            }

            // --- Unit of Measure ---
            field(baseUnitOfMeasure; Rec."Base Unit of Measure")
            {
                Caption = 'baseUnitOfMeasure';
                Editable = false;
            }

            // --- Pricing ---
            field(unitPrice; Rec."Unit Price")
            {
                Caption = 'unitPrice';
                Editable = false;
            }
            field(unitCost; Rec."Unit Cost")
            {
                Caption = 'unitCost';
                Editable = false;
            }

            // --- Status ---
            field(blocked; Rec.Blocked)
            {
                Caption = 'blocked';
                Editable = false;
            }

            // --- Audit ---
            field(lastModifiedDateTime; Rec.SystemModifiedAt)
            {
                Caption = 'lastModifiedDateTime';
                Editable = false;
            }
        }
    }
}
