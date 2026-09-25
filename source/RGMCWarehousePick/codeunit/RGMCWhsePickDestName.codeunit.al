codeunit 50126 "RGMC Whse. Pick Dest. Name"
{
    // Create Pick does not fill the header's destination, so take it from the first line of the
    // new pick (TempWhseActivityLine) and set it before the header is inserted - no extra Modify.
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Pick", 'OnBeforeWhseActivHeaderInsert', '', false, false)]
    local procedure OnBeforeWhseActivHeaderInsert(var WarehouseActivityHeader: Record "Warehouse Activity Header"; var TempWhseActivityLine: Record "Warehouse Activity Line" temporary; CreatePickParameters: Record "Create Pick Parameters"; WhseShptLine: Record "Warehouse Shipment Line")
    var
        WhseShptSourceDest: Codeunit "RGMC Whse. Shpt. Source/Dest.";
    begin
        WarehouseActivityHeader."RGMC Destination Name" :=
          WhseShptSourceDest.GetDestinationName(TempWhseActivityLine."Destination Type", TempWhseActivityLine."Destination No.");
    end;

    procedure UpdateAllPicks()
    var
        WhseActivityHeader: Record "Warehouse Activity Header";
        WhseActivityLine: Record "Warehouse Activity Line";
        WhseShptSourceDest: Codeunit "RGMC Whse. Shpt. Source/Dest.";
        DestinationName: Text[100];
    begin
        WhseActivityHeader.SetRange(Type, WhseActivityHeader.Type::Pick);
        if WhseActivityHeader.FindSet(true) then
            repeat
                DestinationName := '';
                WhseActivityLine.SetRange("Activity Type", WhseActivityHeader.Type);
                WhseActivityLine.SetRange("No.", WhseActivityHeader."No.");
                if WhseActivityLine.FindFirst() then
                    DestinationName := WhseShptSourceDest.GetDestinationName(WhseActivityLine."Destination Type", WhseActivityLine."Destination No.");
                if WhseActivityHeader."RGMC Destination Name" <> DestinationName then begin
                    WhseActivityHeader."RGMC Destination Name" := DestinationName;
                    WhseActivityHeader.Modify();
                end;
            until WhseActivityHeader.Next() = 0;
    end;
}
