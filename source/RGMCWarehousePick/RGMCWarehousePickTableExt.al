tableextension 50103 "RGMC Warehouse Pick Ext" extends "Warehouse Activity Header"
{
    fields
    {
        field(50100; "Device Id / Owner"; Text[100])
        {
            Caption = 'Device Id / Owner';
            DataClassification = SystemMetadata;
        }

        field(50101; "No. of Boxes"; Integer)
        {
            Caption = 'No. of Box(es)';
            DataClassification = SystemMetadata;
        }
        field(50102; "Barcode No."; Code[50])
        {
            Caption = 'Barcode No.';
            DataClassification = CustomerContent;
            ObsoleteState = Removed;
            ObsoleteReason = 'Field is now owned by RGMC Customization package.';
            ObsoleteTag = '1.2.0.2';
        }
        field(50103; "Calculated Quantity"; Decimal)
        {
            Caption = 'Calculated Quantity';
            FieldClass = FlowField;
            CalcFormula = Sum("Warehouse Activity Line"."Qty. Outstanding" where("No." = field("No."), "Action Type" = const(Take)));
            Editable = false;
            ObsoleteState = Removed;
            ObsoleteReason = 'Field is now owned by RGMC Customization package.';
            ObsoleteTag = '1.2.0.2';
        }
        field(50104; "Calculated Qty Handle"; Decimal)
        {
            Caption = 'Calculated Qty Handle';
            FieldClass = FlowField;
            CalcFormula = Sum("Warehouse Activity Line"."Qty. to Handle" where("No." = field("No."), "Action Type" = const(Take)));
            Editable = false;
            ObsoleteState = Removed;
            ObsoleteReason = 'Field is now owned by RGMC Customization package.';
            ObsoleteTag = '1.2.0.2';
        }
        field(50105; "Calculated Qty Handled"; Decimal)
        {
            Caption = 'Calculated Qty Handled';
            FieldClass = FlowField;
            CalcFormula = Sum("Warehouse Activity Line"."Qty. Handled" where("No." = field("No."), "Action Type" = const(Take)));
            Editable = false;
            ObsoleteState = Removed;
            ObsoleteReason = 'Field is now owned by RGMC Customization package.';
            ObsoleteTag = '1.2.0.2';
        }
    }
}