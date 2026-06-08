pageextension 50124 RGMCTrasferOrderBtn extends "Transfer Order"
{
    actions
    {
        addafter("&Print")
        {
            action(ScanShipping)
            {
                ApplicationArea = All;
                Caption = 'Scan Shipping';
                Image = BarCode;

                trigger OnAction()
                var
                    TransferHeader: Record "Transfer Header";
                begin
                    TransferHeader.SetRange("No.", Rec."No.");
                    PAGE.RunModal(PAGE::"Transfer Order Scanner", TransferHeader);
                end;
            }

            action(ScanReceiving)
            {
                ApplicationArea = All;
                Caption = 'Scan Receiving';
                Image = BarCode;

                trigger OnAction()
                var
                    TransferHeader: Record "Transfer Header";
                begin
                    TransferHeader.SetRange("No.", Rec."No.");
                    PAGE.RunModal(PAGE::"Transfer Order Receive Scanner", TransferHeader);
                end;
            }
            action(PrintPullout)
            {
                ApplicationArea = All;
                Caption = 'Print LM Pull-out';
                Image = Print;

                trigger OnAction()
                var
                    TransferHeader: Record "Transfer Header";
                begin
                    TransferHeader.SetRange("No.", Rec."No.");
                    REPORT.RunModal(Report::"Print LMPullOut", true, false, TransferHeader);
                end;
            }

            action(TransferOrderSMPulloutTemplate)
            {
                ApplicationArea = All;
                Caption = 'Download SM Pullout Template';
                Image = Excel;

                trigger OnAction()
                var
                    SMDRReport: Report "SM Pull out Template";
                    TempBlob: Codeunit "Temp Blob";
                    OutStream: OutStream;
                    InStream: InStream;
                    Location: Record Location;
                    Customer: Record Customer;
                    DestinationNo: Code[20];
                    TransferHeader: Record "Transfer Header";
                    TransferLine: Record "Transfer Line";
                    ReportFileName: Text;
                    VendorCode: Code[20];
                    StoreCode: Code[20];
                    SCPOANo: Code[20];
                    UploadDate: Text;
                begin

                    TransferHeader.SetRange("No.", Rec."No.");

                    TransferLine.SetRange("Document No.", Rec."No.");
                    if TransferLine.FindFirst() then
                        DestinationNo := TransferLine."Transfer-from Code";

                    // if DestinationNo = '' then
                    //     if TransferHeader.FindFirst() then
                    //         DestinationNo := TransferHeader."Location Code";

                    // if Location.Get(DestinationNo) then begin
                    //     StoreCode := Location."Store Code";
                    //     VendorCode := Location."RAC_VendorCode";
                    // end;

                    if Location.Get(DestinationNo) then begin
                        StoreCode := Location."Store Code";
                        VendorCode := Location."RAC_VendorCode";
                    end;

                    if TransferHeader.FindFirst() then begin
                        SCPOANo := TransferHeader."External Document No.";
                        UploadDate := Format(Today, 0, '<Month,2><Day,2><Year4>');
                    end;

                    ReportFileName := StrSubstNo('CSGPLW_%1_%2_%3_%4.xlsx',
                                                    VendorCode, StoreCode, SCPOANo, UploadDate);

                    TempBlob.CreateOutStream(OutStream);
                    TransferHeader.SetRange("No.", Rec."No.");
                    Report.SaveAs(Report::"SM Pull out Template", '', ReportFormat::Excel, OutStream, TransferHeader);
                    TempBlob.CreateInStream(InStream);

                    DownloadFromStream(InStream, 'Export', '', 'Excel Files (*.xlsx)|*.xlsx', ReportFileName);
                end;
            }

        }
    }
}