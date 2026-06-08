using Microsoft.Sales.Document;

pageextension 50215 "Sales Return Orders List Ext" extends "Sales Return Orders"
{
    // Control1 on the LSC "Sales Return Orders" page sources Sales Line, not Sales Header.
    // "Submitted By" is a Sales Header field — it is shown on the card via RGMCSalesReturnOrderCardPageExt.
}
