reportextension 50102 RAL_SummaryListOfSales_Ext extends RAL_SummaryListOfSales
{
    dataset
    {
        add(WHTVATTransEntry)
        {
            column(Name2; Name2Txt)
            {
                Caption = 'Name 2';
            }
        }

        modify(WHTVATTransEntry)
        {
            trigger OnAfterAfterGetRecord()
            var
                Cust: Record Customer;
            begin
                Clear(Name2Txt);

                if RAL_VendorCustomerNo <> '' then
                    if Cust.Get(RAL_VendorCustomerNo) then begin
                        Name2Txt := Cust."Name 2";
                        exit;
                    end;

                if RAL_VendorCustomerName <> '' then begin
                    Cust.Reset();
                    Cust.SetRange(Name, RAL_VendorCustomerName);
                    if Cust.FindFirst() then
                        Name2Txt := Cust."Name 2";
                end;
            end;
        }
    }

    var
        Name2Txt: Text[100];
}
