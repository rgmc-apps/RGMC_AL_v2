codeunit 50100 "RGMC Loyalty Print Ext"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC POS Print Utility", 'OnAfterPrintLoyalty', '', true, false)]
    local procedure MyOnAfterPrintLoyaltyHandler(
        var Transaction: Record "LSC Transaction Header";
        var PrintBuffer: Record "LSC POS Print Buffer";
        var PrintBufferIndex: Integer;
        var LinesPrinted: Integer;
        var DSTR1: Text[100])
    var
    //NewLine: Record "LSC POS Print Buffer";
    begin

        PrintBuffer.Init();

        // Parameters From current printout
        PrintBuffer."Store No." := Transaction."Store No.";
        PrintBuffer."Terminal No." := Transaction."POS Terminal No.";
        PrintBuffer."Transaction No." := Transaction."Transaction No.";
        PrintBuffer."Entry No." := PrintBuffer."Entry No." + 1;
        PrintBuffer.TransactionType := Transaction."Transaction Type";
        PrintBuffer.LineType := PrintBuffer.LineType::PrintLine;

        // Increment buffer index based on last printed index
        PrintBufferIndex := PrintBufferIndex + 1;
        PrintBuffer."Buffer Index" := PrintBufferIndex;

        // The one to be printed
        PrintBuffer.Text := 'Member Name: Glenn Eregia';
        PrintBuffer.Width := 40;
        PrintBuffer.Height := 40;

        // Insert into the temporary buffer
        PrintBuffer.Insert();

        // Update counter
        LinesPrinted := LinesPrinted + 1;
    end;
}

