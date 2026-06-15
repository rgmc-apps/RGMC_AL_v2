codeunit 50121 "RGMCRegisterReceiptAuth"
{
    // Authenticate before posting warehouse receipt
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Receipt", 'OnBeforeRun', '', false, false)]
    local procedure AuthenticateBeforePostReceipt(var WarehouseReceiptLine: Record "Warehouse Receipt Line"; var SuppressCommit: Boolean; PreviewMode: Boolean)
    var
        LoginPage: Page "Register Pick Login";
        WarehouseReceiptHeader: Record "Warehouse Receipt Header";
        EnteredUserID: Code[50];
    begin
        // Skip if running in preview/test mode
        if PreviewMode then
            exit;

        if LoginPage.RunModal() <> Action::OK then
            Error('Authentication failed. Post Receipt canceled.');

        EnteredUserID := LoginPage.GetUserID();

        if WarehouseReceiptHeader.Get(WarehouseReceiptLine."No.") then begin
            WarehouseReceiptHeader.Validate("Device Id / Owner", EnteredUserID);
            WarehouseReceiptHeader.Modify(true);
        end;
    end;

    // Update Posted Whse. Receipt Header after posting
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Receipt", 'OnAfterRun', '', false, false)]
    local procedure UpdatePostedWhseReceiptHdr(var WarehouseReceiptLine: Record "Warehouse Receipt Line")
    var
        WarehouseReceiptHeader: Record "Warehouse Receipt Header";
        PostedRcptHeader: Record "Posted Whse. Receipt Header";
    begin
        // At OnAfterRun the source receipt header may already be deleted,
        // so we read "Device Id / Owner" from our own staging or rely on the
        // value we stored before posting. Adjust the lookup key as needed.
        PostedRcptHeader.SetRange("No.", WarehouseReceiptLine."No.");

        if PostedRcptHeader.FindSet() then
            repeat
                PostedRcptHeader.Validate("Device Id / Owner", PostedRcptHeader."Device Id / Owner");
                PostedRcptHeader.Modify(true);
            until PostedRcptHeader.Next() = 0;
    end;
}