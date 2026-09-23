codeunit 50123 "RGMC Company Context"
{
    // Central check so the warehouse authentication is only active in one of
    // the approved companies. Matches on the technical company name first and
    // falls back to the display name, since the two can differ.

    var
        CoventGardenTok: Label 'CGI', Locked = true;
        KeywestOneTok: Label 'KW1', Locked = true;
        RichfieldGarmentTok: Label 'RGMC', Locked = true;
        UnitedStitchesTok: Label 'USGI', Locked = true;
        LevantGroupeTok: Label 'LGAP', Locked = true;

    procedure IsAuthorizedCompany(): Boolean
    var
        AllowedNames: List of [Text];
        AllowedName: Text;
    begin
        AllowedNames := GetAllowedCompanyNames();

        foreach AllowedName in AllowedNames do
            if IsCompanyMatch(AllowedName) then
                exit(true);

        exit(false);
    end;

    local procedure GetAllowedCompanyNames(): List of [Text]
    var
        AllowedNames: List of [Text];
    begin
        AllowedNames.Add(CoventGardenTok);
        AllowedNames.Add(KeywestOneTok);
        AllowedNames.Add(RichfieldGarmentTok);
        AllowedNames.Add(UnitedStitchesTok);
        AllowedNames.Add(LevantGroupeTok);
        exit(AllowedNames);
    end;

    local procedure IsCompanyMatch(AllowedNameUpper: Text): Boolean
    var
        Company: Record Company;
    begin
        if StrPos(UpperCase(CompanyName()), AllowedNameUpper) > 0 then
            exit(true);

        if Company.Get(CompanyName()) then
            exit(StrPos(UpperCase(Company."Display Name"), AllowedNameUpper) > 0);

        exit(false);
    end;

    // Kept for backward compatibility with existing callers.
    procedure IsCoventGarden(): Boolean
    begin
        exit(StrPos(UpperCase(CompanyName()), CoventGardenTok) > 0);
    end;
}