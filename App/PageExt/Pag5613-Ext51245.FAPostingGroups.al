pageextension 51245 "ST FA Posting Groups" extends "FA Posting Groups"
{
    layout
    {
        addafter("Acquisition Cost Account")
        {
            field("Acquisition Cost Account Description"; fnGetAccountDescription("Acquisition Cost Account"))
            {
                Caption = 'Acquisition Cost Account Description', Comment = 'ESM="Cta. costo Descripción"';
                ApplicationArea = All;
                Editable = false;
            }
        }
        modify("Write-Down Account")
        {
            Editable = true;
        }
        modify("Write-Down Acc. on Disposal")
        {
            Editable = true;
        }
    }


    procedure fnGetAccountDescription(pCode: Code[20]): Text;
    var
        gGLAccount: Record "G/L Account";
    begin
        gGLAccount.Reset();
        if gGLAccount.get(pCode) then
            exit(gGLAccount.Name);

        exit('');
    end;
}
