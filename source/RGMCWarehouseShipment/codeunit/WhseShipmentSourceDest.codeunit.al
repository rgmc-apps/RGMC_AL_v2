codeunit 50124 "RGMC Whse. Shpt. Source/Dest."
{
    // Header is updated once per source document, after its lines exist, using the report's own
    // header variable. Updating it from a Warehouse Shipment Line insert/delete subscriber would
    // break the header copy the line table caches and cause "changed by another user" errors.
    [EventSubscriber(ObjectType::Report, Report::"Get Source Documents", 'OnAfterCreateWhseDocuments', '', false, false)]
    local procedure OnAfterCreateWhseDocuments(var WhseReceiptHeader: Record "Warehouse Receipt Header"; var WhseShipmentHeader: Record "Warehouse Shipment Header"; WhseHeaderCreated: Boolean; var WarehouseRequest: Record "Warehouse Request")
    begin
        if WhseShipmentHeader."No." = '' then
            exit;
        if not WhseShipmentHeader.Find() then
            exit;
        UpdateHeader(WhseShipmentHeader);
    end;

    procedure UpdateHeader(var WhseShipmentHeader: Record "Warehouse Shipment Header")
    var
        WhseShipmentLine: Record "Warehouse Shipment Line";
        SourceNo: Code[20];
        DestinationNo: Code[20];
        DestinationName: Text[100];
    begin
        WhseShipmentLine.SetRange("No.", WhseShipmentHeader."No.");
        if WhseShipmentLine.FindLast() then begin
            SourceNo := WhseShipmentLine."Source No.";
            DestinationNo := WhseShipmentLine."Destination No.";
            DestinationName := GetDestinationName(WhseShipmentLine."Destination Type", WhseShipmentLine."Destination No.");
        end;

        if (WhseShipmentHeader."RGMC Source No." = SourceNo) and
           (WhseShipmentHeader."RGMC Destination No." = DestinationNo) and
           (WhseShipmentHeader."RGMC Destination Name" = DestinationName)
        then
            exit;

        WhseShipmentHeader."RGMC Source No." := SourceNo;
        WhseShipmentHeader."RGMC Destination No." := DestinationNo;
        WhseShipmentHeader."RGMC Destination Name" := DestinationName;
        WhseShipmentHeader.Modify();
    end;

    procedure UpdateAllHeaders()
    var
        WhseShipmentHeader: Record "Warehouse Shipment Header";
    begin
        if WhseShipmentHeader.FindSet(true) then
            repeat
                UpdateHeader(WhseShipmentHeader);
            until WhseShipmentHeader.Next() = 0;
    end;

    procedure GetDestinationName(DestinationType: Enum "Warehouse Destination Type"; DestinationNo: Code[20]): Text[100]
    var
        Customer: Record Customer;
        Vendor: Record Vendor;
        Location: Record Location;
    begin
        if DestinationNo = '' then
            exit('');

        case DestinationType of
            DestinationType::Customer:
                if Customer.Get(DestinationNo) then
                    exit(Customer.Name);
            DestinationType::Vendor:
                if Vendor.Get(DestinationNo) then
                    exit(Vendor.Name);
            DestinationType::Location:
                if Location.Get(DestinationNo) then
                    exit(Location.Name);
        end;
        exit('');
    end;
}

codeunit 50125 "RGMC Whse. Shpt. Upgrade"
{
    Subtype = Upgrade;

    trigger OnUpgradePerCompany()
    var
        UpgradeTag: Codeunit "Upgrade Tag";
        WhseShptSourceDest: Codeunit "RGMC Whse. Shpt. Source/Dest.";
        WhsePickDestName: Codeunit "RGMC Whse. Pick Dest. Name";
    begin
        if not UpgradeTag.HasUpgradeTag(SourceDestUpgradeTag()) then begin
            WhseShptSourceDest.UpdateAllHeaders();
            UpgradeTag.SetUpgradeTag(SourceDestUpgradeTag());
        end;

        if not UpgradeTag.HasUpgradeTag(PickDestNameUpgradeTag()) then begin
            WhsePickDestName.UpdateAllPicks();
            UpgradeTag.SetUpgradeTag(PickDestNameUpgradeTag());
        end;
    end;

    local procedure SourceDestUpgradeTag(): Code[250]
    begin
        exit('RGMC-WHSESHPT-SOURCEDEST-20260925');
    end;

    local procedure PickDestNameUpgradeTag(): Code[250]
    begin
        exit('RGMC-WHSEPICK-DESTNAME-20260925');
    end;
}
