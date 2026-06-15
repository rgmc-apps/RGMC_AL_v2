codeunit 50122 "RGMC Whse Shipment Create Pick"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Pick", 'OnBeforeTempWhseActivLineInsert', '', false, false)]
    local procedure OnBeforeTempWhseActivLineInsertSetShipmentBinCode(var TempWarehouseActivityLine: Record "Warehouse Activity Line" temporary; ActionType: Integer; WhseSource2: Option)
    var
        WarehouseShipmentLine: Record "Warehouse Shipment Line";
        TransferLine: Record "Transfer Line";
        TempBin: Record Bin;
    begin
        // Only override the Bin Code for TAKE actions; keep PLACE unchanged
        if TempWarehouseActivityLine."Action Type" = TempWarehouseActivityLine."Action Type"::Take then begin
            if TempWarehouseActivityLine."Source Type" = Database::"Transfer Line" then begin
                if TransferLine.Get(TempWarehouseActivityLine."Source No.", TempWarehouseActivityLine."Source Line No.") then begin
                    TempWarehouseActivityLine."Bin Code" := TransferLine."Transfer-from Bin Code";
                    if TempBin.Get(TempWarehouseActivityLine."Location Code", TransferLine."Transfer-from Bin Code") then begin
                        TempWarehouseActivityLine.Dedicated := TempBin.Dedicated;
                        TempWarehouseActivityLine."Zone Code" := TempBin."Zone Code";
                        TempWarehouseActivityLine."Bin Ranking" := TempBin."Bin Ranking";
                        TempWarehouseActivityLine."Bin Type Code" := TempBin."Bin Type Code";
                    end;
                end;
            end else if TempWarehouseActivityLine."Whse. Document Type" = TempWarehouseActivityLine."Whse. Document Type"::Shipment then begin
                WarehouseShipmentLine.SetCurrentKey("Source Type", "Source Subtype", "Source No.", "Source Line No.");
                WarehouseShipmentLine.SetRange("Source Type", TempWarehouseActivityLine."Source Type");
                WarehouseShipmentLine.SetRange("Source Subtype", TempWarehouseActivityLine."Source Subtype");
                WarehouseShipmentLine.SetRange("Source No.", TempWarehouseActivityLine."Source No.");
                WarehouseShipmentLine.SetRange("Source Line No.", TempWarehouseActivityLine."Source Line No.");
                if WarehouseShipmentLine.FindFirst() then begin
                    TempWarehouseActivityLine."Bin Code" := WarehouseShipmentLine."Bin Code";
                    if TempBin.Get(TempWarehouseActivityLine."Location Code", WarehouseShipmentLine."Bin Code") then begin
                        TempWarehouseActivityLine.Dedicated := TempBin.Dedicated;
                        TempWarehouseActivityLine."Zone Code" := TempBin."Zone Code";
                        TempWarehouseActivityLine."Bin Ranking" := TempBin."Bin Ranking";
                        TempWarehouseActivityLine."Bin Type Code" := TempBin."Bin Type Code";
                    end;
                end;
            end;
        end;
    end;
}

tableextension 50123 "RGMC Whse Act Line Ext" extends "Warehouse Activity Line"
{
    fields
    {
        field(50100; "RGMC Original Shpt Bin Code"; Code[20])
        {
            Caption = 'RGMC Original Shipment Bin Code';
            DataClassification = ToBeClassified;
        }
    }
}
