using Microsoft.CRM.Contact;

page 50204 "LSC Retail Contact Picture API"
{
    PageType = API;
    APIPublisher = 'rgmc';
    APIGroup = 'rgmccustom';
    APIVersion = 'v1.0';
    EntityName = 'contactPicture';
    EntitySetName = 'contactPictures';
    Caption = 'LSC Retail Contact Picture API';

    SourceTable = Contact;
    ODataKeyFields = SystemId;

    DelayedInsert = true;
    InsertAllowed = false;
    ModifyAllowed = true;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            field(id; Rec.SystemId)
            {
                Caption = 'id';
                Editable = false;
            }
            field(contactNo; Rec."No.")
            {
                Caption = 'contactNo';
                Editable = false;
            }
            field(picture; PictureBase64)
            {
                Caption = 'picture';
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        Base64Convert: Codeunit "Base64 Convert";
        TenantMedia: Record "Tenant Media";
        InStr: InStream;
    begin
        PictureBase64 := '';
        if Rec.Image.HasValue() then
            if TenantMedia.Get(Rec.Image.MediaId()) then begin
                TenantMedia.CalcFields(Content);
                if TenantMedia.Content.HasValue then begin
                    TenantMedia.Content.CreateInStream(InStr);
                    PictureBase64 := Base64Convert.ToBase64(InStr);
                end;
            end;
    end;

    trigger OnModifyRecord(): Boolean
    var
        Base64Convert: Codeunit "Base64 Convert";
        TempBlob: Codeunit "Temp Blob";
        OutStr: OutStream;
        InStr: InStream;
    begin
        if PictureBase64 <> '' then begin
            TempBlob.CreateOutStream(OutStr);
            Base64Convert.FromBase64(PictureBase64, OutStr);
            TempBlob.CreateInStream(InStr);
            Rec.Image.ImportStream(InStr, 'picture');
        end;
        exit(true);
    end;

    var
        PictureBase64: Text;
}
