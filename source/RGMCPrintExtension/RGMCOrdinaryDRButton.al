pageextension 50123 MyWhseShipmentExt extends "Warehouse Shipment"
{
    actions
    {
        addafter("&Print")
        {
            action(warehouseShipmentDR)
            {
                ApplicationArea = All;
                Caption = 'Print Ordinary DR';
                Image = Print;

                trigger OnAction()
                var
                    WhseShptHeader: Record "Warehouse Shipment Header";
                begin
                    WhseShptHeader.SetRange("No.", Rec."No.");
                    REPORT.RunModal(Report::"Warehouse Shipment", true, false, WhseShptHeader);
                end;
            }
            action(warehouseShipmentLMDR)
            {
                ApplicationArea = All;
                Caption = 'Print LMDR';
                Image = Print;

                trigger OnAction()
                var
                    WhseShptHeader: Record "Warehouse Shipment Header";
                begin
                    WhseShptHeader.SetRange("No.", Rec."No.");
                    REPORT.RunModal(Report::"Print LMDR", true, false, WhseShptHeader);
                end;
            }
        }
    }
}