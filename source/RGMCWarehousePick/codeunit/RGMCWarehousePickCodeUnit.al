codeunit 50120 "RGMCRegisterPickAuth"
{
    // Authenticate before registration
    [EventSubscriber(ObjectType::Page, Page::"Whse. Pick Subform", 'OnBeforeRegisterActivityYesNo', '', false, false)]
    local procedure AuthenticateBeforeRegisterPick(var WarehouseActivityLine: Record "Warehouse Activity Line"; var IsHandled: Boolean)
    var
        LoginPage: Page "Register Pick Login";
        WarehouseActivityHeader: Record "Warehouse Activity Header";
        EnteredUserID: Code[50];
    begin
        if LoginPage.RunModal() <> Action::OK then begin
            Message('Authentication failed. Register Pick canceled.');
            IsHandled := true;
            exit;
        end;

        EnteredUserID := LoginPage.GetUserID();

        if WarehouseActivityHeader.Get(WarehouseActivityLine."Activity Type", WarehouseActivityLine."No.") then begin
            WarehouseActivityHeader.Validate("Device Id / Owner", EnteredUserID);
            WarehouseActivityHeader.Modify(true);
        end;
    end;


    //update Registered Whse. Activity Hdr.
    [EventSubscriber(ObjectType::Page, Page::"Whse. Pick Subform", 'OnAfterRegisterActivityYesNo', '', false, false)]
    local procedure UpdateRegisteredWhseActivityHdr(var WarehouseActivityLine: Record "Warehouse Activity Line")
    var
        WarehouseActivityHeader: Record "Warehouse Activity Header";
        RegisteredHdr: Record "Registered Whse. Activity Hdr.";
    begin
        if WarehouseActivityHeader.Get(WarehouseActivityLine."Activity Type", WarehouseActivityLine."No.") then begin
            RegisteredHdr.SetRange("Type", WarehouseActivityHeader."Type");
            RegisteredHdr.SetRange("No.", WarehouseActivityHeader."No.");

            if RegisteredHdr.FindSet() then
                repeat
                    RegisteredHdr.Validate("Device Id / Owner", WarehouseActivityHeader."Device Id / Owner");
                    RegisteredHdr.Modify(true);
                until RegisteredHdr.Next() = 0;
        end;
    end;
}
