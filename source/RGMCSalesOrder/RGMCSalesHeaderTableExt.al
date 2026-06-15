using Microsoft.Sales.Document;

tableextension 50211 "Sales Header Ext" extends "Sales Header"
{
    fields
    {
        field(50100; "Submitted By"; Text[100])
        {
            Caption = 'Submitted By';
            DataClassification = CustomerContent;
        }
    }
}
