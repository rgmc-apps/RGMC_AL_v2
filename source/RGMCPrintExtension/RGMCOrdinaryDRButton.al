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
            action(warehouseShipmentSMDR)
            {
                ApplicationArea = All;
                Caption = 'Print SMDR';
                Image = Print;

                trigger OnAction()
                var
                    WhseShptHeader: Record "Warehouse Shipment Header";
                begin
                    WhseShptHeader.SetRange("No.", Rec."No.");
                    REPORT.RunModal(Report::"Whse Shipment SMDR", true, false, WhseShptHeader);
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

            action(warehouseShipmentSMDRTemplate)
            {
                ApplicationArea = All;
                Caption = 'Download SMDR Template';
                Image = Excel;

                trigger OnAction()
                var
                    SMDRReport: Report "SM DR Template";
                    TempBlob: Codeunit "Temp Blob";
                    OutStream: OutStream;
                    InStream: InStream;
                    Location: Record Location;
                    Customer: Record Customer;
                    DestinationNo: Code[20];
                    WhseShptHeader: Record "Warehouse Shipment Header";
                    WhseShipmentLine: Record "Warehouse Shipment Line";
                    ReportFileName: Text;
                    VendorCode: Code[20];
                    StoreCode: Code[20];
                    DRNo: Code[20];
                    UploadDate: Text;
                begin
                    WhseShptHeader.SetRange("No.", Rec."No.");

                    WhseShipmentLine.SetRange("No.", Rec."No.");
                    if WhseShipmentLine.FindFirst() then
                        DestinationNo := WhseShipmentLine."Destination No.";

                    if DestinationNo = '' then
                        if WhseShptHeader.FindFirst() then
                            DestinationNo := WhseShptHeader."Location Code";

                    if Location.Get(DestinationNo) then begin
                        StoreCode := Location."Store Code";
                        VendorCode := Location."RAC_VendorCode";
                    end;

                    if WhseShptHeader.FindFirst() then begin
                        DRNo := WhseShptHeader."External Document No.";
                        UploadDate := Format(Today, 0, '<Year4><Month,2><Day,2>');
                    end;

                    ReportFileName := StrSubstNo('CSGRCW_%1_%2_%3_%4.xlsx',
                                                    VendorCode, StoreCode, DRNo, UploadDate);

                    TempBlob.CreateOutStream(OutStream);
                    WhseShptHeader.SetRange("No.", Rec."No.");
                    Report.SaveAs(Report::"SM DR Template", '', ReportFormat::Excel, OutStream, WhseShptHeader);
                    TempBlob.CreateInStream(InStream);

                    DownloadFromStream(InStream, 'Export', '', 'Excel Files (*.xlsx)|*.xlsx', ReportFileName);
                end;
            }
        }
    }
}