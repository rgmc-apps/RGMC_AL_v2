reportextension 50100 "RALPurchaseInvoice Ext" extends 80135
{
    dataset
    {
        add("Purchase Header")
        {
            column(DueDate_PurchInvHeader; "Purchase Header"."Due Date") { }
        }
    }
}