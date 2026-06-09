permissionset 50200 "RGMC Custom"
{
    Assignable = true;
    Caption = 'RGMC Custom';

    Permissions =
        tabledata "RGMC Contact Brand Tag" = RIMD,
        table "RGMC Contact Brand Tag" = X,
        page "RGMC Contact Brand Tags" = X,
        page "RGMC Contact Brand Tag API" = X;
}
