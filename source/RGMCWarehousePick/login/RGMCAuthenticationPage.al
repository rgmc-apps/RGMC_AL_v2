page 50111 "Register Pick Login"
{
    PageType = StandardDialog;
    ApplicationArea = All;
    Caption = 'Register Pick Authentication';

    layout
    {
        area(content)
        {
            field(UserID; UserID)
            {
                ApplicationArea = All;
                Caption = 'User ID';
            }
            field(PIN; PIN)
            {
                ApplicationArea = All;
                Caption = 'Code';
                ExtendedDatatype = Masked;
            }
        }
    }

    var
        UserID: Code[50];
        PIN: Text[20];
        Worker: Record "Dimension Value";

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction = Action::OK then begin
            // Filter to the USER dimension
            Worker.SetRange("Dimension Code", 'USER');
            Worker.SetRange(Name, UserID);
            Worker.SetRange(Code, PIN);

            if not Worker.FindFirst() then begin
                Message('Invalid User ID or PIN.');
                exit(false);
            end;
        end;

        exit(true);
    end;

    procedure GetUserID(): Code[50]
    begin
        exit(UserID);
    end;
}