using Microsoft.Sales.Customer;

page 50200 "LSC Retail Customer API"
{
    PageType = API;
    APIPublisher = 'rgmc';
    APIGroup = 'rgmccustom';
    APIVersion = 'v1.0';
    EntityName = 'retailCustomer';
    EntitySetName = 'retailCustomers';
    Caption = 'LSC Retail Customer API';

    SourceTable = Customer;
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

            // --- Name & Contact ---
            field(name; Rec.Name)
            {
                Caption = 'name';
            }
            field(name2; Rec."Name 2")
            {
                Caption = 'name2';
            }
            field(contact; Rec.Contact)
            {
                Caption = 'contact';
            }
            field(phoneNo; Rec."Phone No.")
            {
                Caption = 'phoneNo';
            }
            field(mobilePhoneNo; Rec."Mobile Phone No.")
            {
                Caption = 'mobilePhoneNo';
            }
            field(email; Rec."E-Mail")
            {
                Caption = 'email';
            }

            // --- Address ---
            field(address; Rec.Address)
            {
                Caption = 'address';
            }
            field(address2; Rec."Address 2")
            {
                Caption = 'address2';
            }
            field(city; Rec.City)
            {
                Caption = 'city';
            }
            field(county; Rec.County)
            {
                Caption = 'county';
            }
            field(postCode; Rec."Post Code")
            {
                Caption = 'postCode';
            }
            field(countryRegionCode; Rec."Country/Region Code")
            {
                Caption = 'countryRegionCode';
            }

            // --- Financial ---
            field(currencyCode; Rec."Currency Code")
            {
                Caption = 'currencyCode';
            }
            field(creditLimitLcy; Rec."Credit Limit (LCY)")
            {
                Caption = 'creditLimitLcy';
            }
            field(balanceLcy; Rec."Balance (LCY)")
            {
                Caption = 'balanceLcy';
                Editable = false;
            }
            field(paymentTermsCode; Rec."Payment Terms Code")
            {
                Caption = 'paymentTermsCode';
            }
            field(paymentMethodCode; Rec."Payment Method Code")
            {
                Caption = 'paymentMethodCode';
            }
            field(vatRegistrationNo; Rec."VAT Registration No.")
            {
                Caption = 'vatRegistrationNo';
            }

            // --- Posting Groups ---
            field(customerPostingGroup; Rec."Customer Posting Group")
            {
                Caption = 'customerPostingGroup';
            }
            field(genBusPostingGroup; Rec."Gen. Bus. Posting Group")
            {
                Caption = 'genBusPostingGroup';
            }

            // --- Retail / Sales ---
            field(salespersonCode; Rec."Salesperson Code")
            {
                Caption = 'salespersonCode';
            }
            field(blocked; Rec.Blocked)
            {
                Caption = 'blocked';
            }

            // --- Audit ---
            field(lastModifiedDateTime; Rec.SystemModifiedAt)
            {
                Caption = 'lastModifiedDateTime';
                Editable = false;
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.TestField(Name);
        Rec.TestField("Customer Posting Group");
        Rec.TestField("Gen. Bus. Posting Group");
        exit(true);
    end;

    trigger OnModifyRecord(): Boolean
    begin
        Rec.TestField(Name);
        exit(true);
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        if Rec."Balance (LCY)" <> 0 then
            Error('Customer %1 cannot be deleted while a balance of %2 is outstanding.', Rec."No.", Rec."Balance (LCY)");
        exit(true);
    end;
}
