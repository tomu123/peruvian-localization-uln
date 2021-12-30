codeunit 51014 "Telecredit Utility"
{

    procedure fnValidateBankAccountNo(pBanckAccountSelected: Code[20])
    var
        lcRecBankAccount: Record "Bank Account";
    begin
        lcRecBankAccount.RESET;
        lcRecBankAccount.SETRANGE("No.", pBanckAccountSelected);
        IF pBanckAccountSelected <> '' THEN
            lcRecBankAccount.FINDSET;
    end;

    procedure fnMessageNotificationRemittanceFiles(pFileName: text[50]; pMessage: Text[1024])
    var
        lcNotification: Notification;
        ViewFile: Label 'View File', Comment = 'ESM="Ver archivo"';
    begin
        lcNotification.Message(pMessage);
        lcNotification.Scope := NotificationScope::LocalScope;
        lcNotification.SetData('NameFile', pFileName);
        lcNotification.AddAction(ViewFile, Codeunit::"Telecredit Utility", 'fnViewRemittanceFiles');
        lcNotification.Send();
    end;


    procedure fnViewRemittanceFiles(MyNotification: Notification)
    var
        lcNameFile: Text;
        lcCuGenJnlMgt: Codeunit GenJnlManagement;
        lcRecRemittanceFiles: Record "ST Control File";
        lcPgRemittanceFiles: Page "ST Control File List";
    begin
        lcNameFile := MyNotification.GETDATA('NameFile');
        CLEAR(lcPgRemittanceFiles);
        lcRecRemittanceFiles.RESET;
        lcRecRemittanceFiles.SETRANGE("File Name", lcNameFile);
        lcPgRemittanceFiles.SETTABLEVIEW(lcRecRemittanceFiles);
        lcPgRemittanceFiles.RUNMODAL;

    end;

    procedure fnLookUpRestrictedListBankCurrencyCode(VAR pBanckAccountSelected: Code[20]; VAR pCurrencyCodeSelected: Code[10])
    var
        lcRecBankAccount: Record "Bank Account";
        lcPgListBankRestricted: Page "Bank Account List";
    begin
        CLEAR(lcPgListBankRestricted);
        lcRecBankAccount.RESET;
        lcPgListBankRestricted.LOOKUPMODE(TRUE);
        lcPgListBankRestricted.EDITABLE(FALSE);
        lcPgListBankRestricted.SETTABLEVIEW(lcRecBankAccount);
        lcPgListBankRestricted.SETRECORD(lcRecBankAccount);
        IF lcPgListBankRestricted.RUNMODAL IN [ACTION::LookupOK, ACTION::OK] THEN BEGIN
            lcPgListBankRestricted.GETRECORD(lcRecBankAccount);
            pBanckAccountSelected := lcRecBankAccount."No.";
            pCurrencyCodeSelected := lcRecBankAccount."Currency Code";
        END;

    end;

}

