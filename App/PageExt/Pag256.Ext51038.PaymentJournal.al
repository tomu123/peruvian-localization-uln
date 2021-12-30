pageextension 51038 "Setup Payment Journal" extends "Payment Journal"
{
    layout
    {
        // Add changes to page layout here
        addafter("Applies-to ID")
        {
            field("Applies-to Entry No."; Rec."Applies-to Entry No.")
            {
                ApplicationArea = All;
                Caption = 'Applied-to Entry No.', Comment = 'ESM="Liq. por N° Mov."';
            }
        }
        addafter(Description)
        {
            field("Posting Group"; Rec."Posting Group")
            {
                ApplicationArea = All;
                Editable = true;
                Caption = 'Posting Group', Comment = 'ESM="Grupo contable"';

                trigger OnValidate()
                begin
                    SLSetupMgt.ValidatePostingGroup(Rec);
                end;

                trigger OnLookup(var Text: Text): Boolean
                begin
                    SLSetupMgt.LookUpPostingGroup(Rec);
                end;
            }
        }
        addafter(CurrentJnlBatchName)
        {
            field(IsManual; IsManual)
            {
                Caption = 'Manual Retention', Comment = 'ESM="Retención Manual"';
                ApplicationArea = All;
                Visible = ShowRetention;
            }
        }

        addafter("Bal. Account No.")
        {
            field("Applied Retention"; Rec."Applied Retention")
            {
                ApplicationArea = All;
                Visible = ShowRetention;
            }
            field("Retention Amount"; Rec."Retention Amount")
            {
                ApplicationArea = All;
                Visible = ShowRetention;
                Editable = false;
            }
            field("Retention Amount LCY"; Rec."Retention Amount LCY")
            {
                ApplicationArea = All;
                Visible = ShowRetention;
                Editable = false;
            }
        }


        modify(GetAppliesToDocDueDate)
        {
            Visible = false;
        }
        modify("Currency Code")
        {
            Editable = "Account Type" = "Account Type"::"G/L Account";
        }
        modify(Correction)
        {
            Visible = false;
        }
        modify("Exported to Payment File")
        {
            Visible = false;
        }
        modify(TotalExportedAmount)
        {
            Visible = false;
        }
        modify("Has Payment Export Error")
        {
            Visible = false;
        }
        //Add Pc 27.09.20
        addafter("Account No.")
        {
            field("Check Name15467"; Rec."Check Name")
            {
                ApplicationArea = All;
            }
        }
        addafter("Document Type")
        {
            field("Document Date24911"; Rec."Document Date")
            {
                ApplicationArea = All;
            }
            field("Due Date45223"; Rec."Due Date")
            {
                ApplicationArea = All;
            }
        }
        modify("Applied (Yes/No)")
        {
            Visible = false;
        }
        addafter("Job Queue Status")
        {
            field("Check Printed54770"; Rec."Check Printed")
            {
                ApplicationArea = All;
            }
        }

        addafter("Recipient Bank Account")
        {
            field("ST Recipient Bank Account"; "ST Recipient Bank Account")
            {
                ApplicationArea = All;
            }
            field("gAccountBankNation"; "gAccountBankNation")
            {
                Caption = 'Cód. Cuenta Banco de la Nación', Comment = 'ESM="Cód. Cuenta Banco de la Nación"';
                ApplicationArea = All;
                Editable = false;

            }
        }
        modify("Recipient Bank Account")
        {
            Visible = false;
        }
        addafter(Description)
        {
            field("Posting Text"; "Posting Text")
            {


            }
        }
        //End PC 27.09.20
        modify("Total Balance")
        {
            Caption = 'Total Balance (DL)', Comment = 'ESM="Saldo Total (DL)"';
        }
        modify(TotalBalance)
        {
            Caption = 'Total Balance (DL)', Comment = 'ESM="Saldo Total (DL)"';
        }
        modify("Amount (LCY)")
        {
            Caption = 'Amount (DL)', Comment = 'ESM="Importe (DL)"';
        }
        addbefore(Control1900545401)
        {
            group("Total Debit 1")
            {
                Caption = 'Total Debit', Comment = 'ESM="Total DébitO"';
                //Visible = IsSimplePage;
                field(DisplayTotalDebit1; GetTotalDebitAmt)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Total Debit';
                    Editable = false;
                    ToolTip = 'Specifies the total debit amount in the general journal.';
                }
            }
            group("Total Credit 1")
            {
                Caption = 'Total Credit', Comment = 'ESM="Total Crédito"';
                //Visible = IsSimplePage;
                field(DisplayTotalCredit1; GetTotalCreditAmt)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Total Credit';
                    Editable = false;
                    ToolTip = 'Specifies the total credit amount in the general journal.';
                }
            }
        }
        addafter("Total Balance")
        {
            group("Total Balance ME")
            {
                Caption = 'Total Balance (ME)', Comment = 'ESM="Saldo Total (ME)"';
                field(TotalBalanceME; TotalBalanceME + Amount - xRec.Amount)
                {
                    ApplicationArea = All;
                    AutoFormatType = 1;
                    Caption = 'Total Balance (ME)', Comment = 'ESM="Saldo Total (ME)"';
                    Editable = false;
                    ToolTip = 'Specifies the total balance ME in the general journal.';
                    //Visible = TotalBalanceVisible;
                }
            }
        }
    }
    actions
    {
        addafter("&Payments")
        {
            group("Telecrédito Proveedores & Haberes")
            {
                Image = PaymentDays;
                Visible = true;
                Enabled = True;
                Caption = 'Telecredit Vendor & ', Comment = 'ESM="Telecrédito Prov. & Haberes"';

                action(ExportAccountsPayableRegister)
                {
                    ApplicationArea = All;
                    Caption = 'Registro COACTIVA';
                    Image = SuggestCustomerPayments;
                    Visible = true;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    trigger OnAction();
                    var
                    begin
                        CLEAR(MassiveBankPayments);
                        SLSetupMgt.ValidateMixedCurrencyCode(rec."Journal Template Name", Rec."Journal Batch Name");
                        MassiveBankPayments.fnGenerateRegisterAccountsPayable(Rec);

                    end;
                }


                action(ExportBCPBankPayroll)
                {
                    ApplicationArea = All;
                    Caption = 'BCP Haberes';
                    Visible = ViewPaymentsBCP;
                    Image = SuggestCustomerPayments;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    trigger OnAction();
                    var

                    begin
                        CLEAR(MassiveBankPayments);
                        SLSetupMgt.ValidateMixedCurrencyCode(rec."Journal Template Name", Rec."Journal Batch Name");
                        MassiveBankPayments.fnGenerateSalaryTelecreditEmployee(Rec);

                    end;
                }
                action(ExportBCPBank)
                {
                    ApplicationArea = All;
                    Caption = 'BCP Proveedores';
                    Visible = ViewPaymentsBCP;
                    Image = ElectronicPayment;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    trigger OnAction();
                    var
                        lcSetupLocalization: Record "Setup Localization";
                        RecGenJournalLine: Record 81;
                    begin
                        RecGenJournalLine.Reset();
                        RecGenJournalLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                        RecGenJournalLine.SetRange("Journal Template Name", Rec."Journal Template Name");
                        RecGenJournalLine.SetRange("Applied Retention", true);
                        if RecGenJournalLine.FindSet() then begin
                            repeat
                                if (RecGenJournalLine."Retention Amount LCY" = 0) or (RecGenJournalLine."Retention Amount LCY" = 0) then
                                    Error('La linea %1 tiene marcado el check de retencion, favor de calcular retencion para la linea', RecGenJournalLine."Line No.");
                            until RecGenJournalLine.Next() = 0;

                        end;


                        CLEAR(MassiveBankPayments);
                        lcSetupLocalization.GET;

                        SLSetupMgt.ValidateMixedCurrencyCode(rec."Journal Template Name", Rec."Journal Batch Name");

                        if lcSetupLocalization."Telecredit New Version" then
                            MassiveBankPayments.fnGenerateVendorTelecreditBCPV2(Rec, FALSE, FALSE)
                        else
                            MassiveBankPayments.fnGenerateVendorTelecreditBCP(Rec, FALSE, FALSE);
                    end;
                }
                action(ExportBBVABankPayroll)
                {
                    ApplicationArea = All;
                    Caption = 'BBVA Haberes';
                    Visible = ViewPaymentsBBVA;
                    Image = SuggestCustomerPayments;
                    Promoted = true;
                    PromotedIsBig = true;

                    PromotedCategory = Process;
                    trigger OnAction();

                    begin
                        CLEAR(MassiveBankPayments);
                        SLSetupMgt.ValidateMixedCurrencyCode(rec."Journal Template Name", Rec."Journal Batch Name");
                        MassiveBankPayments.fnGenerateSalaryTelecreditEmployee(Rec);

                    end;
                }

                action(ExportBBVABank)
                {
                    ApplicationArea = All;
                    Caption = 'BBVA Proveedores';
                    Visible = ViewPaymentsBBVA;
                    Image = ElectronicPayment;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    trigger OnAction();

                    begin
                        CLEAR(MassiveBankPayments);
                        SLSetupMgt.ValidateMixedCurrencyCode(rec."Journal Template Name", Rec."Journal Batch Name");
                        MassiveBankPayments.fnGenerateVendorTelecreditBBVA(Rec);


                    end;
                }
                action(ExportINTKBankPayroll)
                {
                    ApplicationArea = All;
                    Caption = 'INTERBANK Haberes';
                    // CaptionML = 'ENU=ExportBCPBank;ESP=Telecrédito BCP Proveedores;ESM=BCP Haberes';
                    Visible = ViewPaymentsIBK;
                    Image = SuggestCustomerPayments;
                    Promoted = true;
                    PromotedIsBig = true;

                    PromotedCategory = Process;
                    trigger OnAction();
                    begin
                        CLEAR(MassiveBankPayments);
                        SLSetupMgt.ValidateMixedCurrencyCode(rec."Journal Template Name", Rec."Journal Batch Name");
                        MassiveBankPayments.fnGenerateSalaryTelecreditEmployee(Rec);

                    end;
                }


                action(ExportINTKBank)
                {
                    ApplicationArea = All;
                    Caption = 'INTERBANK Proveedores';
                    // CaptionML = 'ENU=ExportBCPBank;ESP=Telecrédito BCP Proveedores;ESM=BCP Haberes';
                    Visible = ViewPaymentsIBK;
                    Image = ElectronicPayment;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    trigger OnAction();
                    begin
                        CLEAR(MassiveBankPayments);
                        IF Rec.ISEMPTY THEN
                            EXIT;
                        SLSetupMgt.ValidateMixedCurrencyCode(rec."Journal Template Name", Rec."Journal Batch Name");
                        MassiveBankPayments.fnGenerateVendorTelecreditITBK(Rec);

                    end;
                }

                action(ExportSCOTIABankPayroll)
                {
                    ApplicationArea = All;
                    Caption = 'SCOTIABANK Haberes';
                    Visible = ViewPaymentsSBP;
                    Image = SuggestCustomerPayments;
                    Promoted = true;
                    PromotedIsBig = true;

                    PromotedCategory = Process;
                    trigger OnAction();
                    begin
                        CLEAR(MassiveBankPayments);
                        SLSetupMgt.ValidateMixedCurrencyCode(rec."Journal Template Name", Rec."Journal Batch Name");
                        MassiveBankPayments.fnGenerateSalaryTelecreditEmployee(Rec);

                    end;
                }

                action(ExportSCOTIABank)
                {
                    ApplicationArea = All;
                    Caption = 'SCOTIABANK Proveedores';
                    Visible = ViewPaymentsSBP;
                    Image = SuggestCustomerPayments;
                    Promoted = true;
                    PromotedIsBig = true;

                    PromotedCategory = Process;
                    trigger OnAction();
                    begin
                        CLEAR(MassiveBankPayments);
                        IF Rec.ISEMPTY THEN
                            EXIT;
                        SLSetupMgt.ValidateMixedCurrencyCode(rec."Journal Template Name", Rec."Journal Batch Name");
                        MassiveBankPayments.fnGenerateVendorTelecreditScotiabank(Rec);

                    end;
                }

                action(ExportCITIBankPayroll)
                {
                    ApplicationArea = All;
                    Caption = 'CITIBANK Haberes';
                    Visible = ViewPaymentsCITI;
                    Image = SuggestCustomerPayments;
                    Promoted = true;
                    PromotedIsBig = true;

                    PromotedCategory = Process;
                    trigger OnAction();
                    begin
                        CLEAR(MassiveBankPayments);
                        SLSetupMgt.ValidateMixedCurrencyCode(rec."Journal Template Name", Rec."Journal Batch Name");
                        MassiveBankPayments.fnGenerateSalaryTelecreditEmployee(Rec);


                    end;
                }

                action(ExportCITIBank)
                {
                    ApplicationArea = All;
                    Caption = 'CITIBANK Proveedores';
                    Visible = ViewPaymentsCITI;
                    Image = ElectronicPayment;
                    Promoted = true;
                    PromotedIsBig = true;

                    PromotedCategory = Process;
                    trigger OnAction();
                    begin
                        CLEAR(MassiveBankPayments);
                        IF Rec.ISEMPTY THEN
                            EXIT;
                        SLSetupMgt.ValidateMixedCurrencyCode(rec."Journal Template Name", Rec."Journal Batch Name");
                        MassiveBankPayments.fnGeneratePaymentTelecredit(Rec);

                    end;
                }
            }
        }
        addlast("Electronic Payments")
        {
            action(GenDetractPlainText)
            {
                Caption = 'Generate Detraction Plain Text', Comment = 'ESM="Generar arch. plano detracción"';
                ApplicationArea = All;
                Image = ExportToBank;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    myInt: Integer;
                begin
                    Clear(DetracCalculation);
                    DetracCalculation.GenerateDetrActionFile(Rec);
                end;
            }
            action(ImportDetractionFile)
            {
                ApplicationArea = All;
                Caption = 'Import detraction file', Comment = 'ESM="Importar arch. detracción"';
                Image = ImportExcel;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                RunObject = report "Detrac. Load Detraction File";
            }
        }
        addafter("F&unctions")
        {
            group(Retention)
            {
                Caption = 'Retention';
                Image = CalculateVAT;
                action(CalculateRetention)
                {
                    ApplicationArea = All;
                    Caption = 'Calculate Retention', Comment = 'ESM="Calcular Retención"';
                    Image = CalculateBalanceAccount;
                    trigger OnAction()
                    begin
                        RetentionMgt.CalculateRetention(Rec, IsManual);
                        Rec.AdjustDifferenceForDumbUser(Rec);
                        CurrPage.Update(true);
                    end;
                }
            }
        }
        addafter(ApplyEntries)
        {
            action(AdjusDiffForDumbUser)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Adjust Difference for bank', Comment = 'ESM="Ajustar dif. para banco"';
                Ellipsis = true;
                Image = AdjustEntries;
                Promoted = true;
                PromotedCategory = Process;
                ShortCutKey = 'Shift+Ctrl+E';
                ToolTip = 'This function is used to automatically adjust the difference of a document versus the bank line.', Comment = 'ESM="Esta función sirve para ajustar de manera automatica la diferencia de un documento versus la linea de banco."';

                trigger OnAction()
                var
                    ConfirmAdjust: Label 'Do you want to adjust the difference in the journal?', Comment = 'ESM="¿Desea realizar el ajustar la diferencia en el diario?"';
                begin
                    if Confirm(ConfirmAdjust, false) then
                        Rec.AdjustDifferenceForDumbUser(Rec);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetViewButtons;
        fnGetVendorInfo;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        SetViewButtons;
        if ClientTypeManagement.GetCurrentClientType <> CLIENTTYPE::ODataV4 then
            CalcBalanceME(Rec, xRec, TotalBalanceME, ShowTotalBalanceME);
    end;

    trigger OnOpenPage()
    begin
        SetViewButtons;
        if SetupLoc.Get() then
            ShowRetention := SetupLoc."Retention Agent Option" <> SetupLoc."Retention Agent Option"::Disable;
    end;


    procedure fnGetVendorInfo()
    var
        lcvendor: Record vendor;
    begin
        gAccountBankNation := '';

        if Rec."Account Type" <> Rec."Account Type"::Vendor then
            exit;

        lcvendor.Reset();
        lcvendor.SetRange("No.", Rec."Account No.");
        if lcvendor.FindFirst() then
            gAccountBankNation := lcvendor."Currenct Account BNAC";

    end;

    local procedure SetViewButtons()
    var
        GenJnlBatch2: Record "Gen. Journal Batch";
        BankAccNoFICO: Text;
    begin
        GenJnlBatch2.Reset();
        GenJnlBatch2.SetRange("Journal Template Name", Rec."Journal Template Name");
        GenJnlBatch2.SetRange(Name, Rec."Journal Batch Name");
        if GenJnlBatch2.IsEmpty then
            exit;
        GenJnlBatch2.Find('-');
        BankAccNoFICO := GenJnlBatch2."Bank Account No. FICO";

        if BankAccNoFICO = '' then
            exit;

        ViewPaymentsBBVA := CopyStr(BankAccNoFICO, 1, 6) = 'BBVA-R';
        ViewPaymentsBCP := CopyStr(BankAccNoFICO, 1, 5) = 'BCP-L';
        ViewPaymentsIBK := CopyStr(BankAccNoFICO, 1, 5) = 'IBK-R';
        ViewPaymentsSBP := CopyStr(BankAccNoFICO, 1, 5) = 'SBP-R';
    end;

    procedure CalcBalanceME(var GenJnlLine: Record "Gen. Journal Line"; LastGenJnlLine: Record "Gen. Journal Line"; var TotalBalance: Decimal; var ShowTotalBalance: Boolean)
    var
        TempGenJnlLine: Record "Gen. Journal Line";
    begin
        TempGenJnlLine.CopyFilters(GenJnlLine);
        TempGenJnlLine.SetRange("Currency Code", 'USD');
        if CurrentClientType in [CLIENTTYPE::SOAP, CLIENTTYPE::OData, CLIENTTYPE::ODataV4, CLIENTTYPE::Api] then
            ShowTotalBalance := false
        else
            ShowTotalBalance := TempGenJnlLine.CalcSums(Amount);

        if ShowTotalBalance then begin
            TotalBalance := TempGenJnlLine.Amount;
            if GenJnlLine."Line No." = 0 then
                TotalBalance := TotalBalance + LastGenJnlLine.Amount;
        end;

    end;

    local procedure GetTotalDebitAmt(): Decimal
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        GenJournalLine.SetRange("Journal Template Name", "Journal Template Name");
        GenJournalLine.SetRange("Journal Batch Name", "Journal Batch Name");
        GenJournalLine.SetRange("Document No.", "Document No.");
        GenJournalLine.CalcSums("Debit Amount");
        exit(GenJournalLine."Debit Amount");
    end;

    local procedure GetTotalCreditAmt(): Decimal
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        GenJournalLine.SetRange("Journal Template Name", "Journal Template Name");
        GenJournalLine.SetRange("Journal Batch Name", "Journal Batch Name");
        GenJournalLine.SetRange("Document No.", "Document No.");
        GenJournalLine.CalcSums("Credit Amount");
        exit(GenJournalLine."Credit Amount");
    end;


    var
        SLSetupMgt: Codeunit "Setup Localization";
        DetracCalculation: Codeunit "DetrAction Calculation";
        MassiveBankPayments: Codeunit "Massive Banks Payments";
        rec81: Record 81;
        ViewPaymentsBCP: Boolean;
        ViewPaymentsBBVA: Boolean;
        ViewPaymentsIBK: Boolean;
        ViewPaymentsSBP: Boolean;
        ViewPaymentsCITI: Boolean;
        IsManual: Boolean;
        ShowRetention: Boolean;
        RetentionMgt: Codeunit "Retention Management";
        SetupLoc: Record "Setup Localization";//Dimensions

        gAccountBankNation: Text;
        TotalBalanceME: Decimal;
        ClientTypeManagement: Codeunit "Client Type Management";
        ShowTotalBalanceME: Boolean;
}