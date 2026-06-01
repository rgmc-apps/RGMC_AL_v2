reportextension 50101 "RALAccountsPayableVoucher Ext" extends 80134
{
    dataset
    {
        add(PostedInvoice)
        {
            column(PreAssignedDocNo; "Pre-Assigned No.")
            {
            }
        }
    }
}