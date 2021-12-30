table 51039 "Extract The Bank"
{
    Caption = 'Bank Acc. Reconciliation Line', Comment = 'ESM="extracto del banco"';
    Permissions = TableData "Data Exch. Field" = rimd;

    fields
    {
        field(1; "Bank Account No."; Code[20])
        {
            Caption = 'Bank Account No.', Comment = 'ESM="Cód. Cuenta Banco"';
            TableRelation = "Bank Account";
        }
        field(2; "Statement No."; Code[20])
        {
            Caption = 'Statement No.', Comment = 'ESM="Nº estado de cta. banco"';
            TableRelation = "Bank Acc. Reconciliation"."Statement No." WHERE("Bank Account No." = FIELD("Bank Account No."));
        }
        field(3; "Statement Line No."; Integer)
        {
            Caption = 'Statement Line No.', Comment = 'ESM="Nº lín. estado de cta. banco"';
        }
        field(4; "Document No."; Code[20])
        {
            Caption = 'Document No.', Comment = 'ESM="N° Documento"';
        }
        field(5; "Transaction Date"; Date)
        {
            Caption = 'Transaction Date', Comment = 'ESM="Fecha movimiento"';
        }
        field(6; Description; Text[100])
        {
            Caption = 'Description', Comment = 'ESM="Descripción"';
        }
        field(7; "Statement Amount"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            Caption = 'Statement Amount', Comment = 'ESM="Importe estado de cuenta"';

            trigger OnValidate()
            begin
                Difference := "Statement Amount" - "Applied Amount";
            end;
        }
        field(8; Difference; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Difference', Comment = 'ESM="Diferencia"';

            trigger OnValidate()
            begin
                "Statement Amount" := "Applied Amount" + Difference;
            end;
        }
        field(9; "Applied Amount"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Applied Amount', Comment = 'ESM="Importe conciliado"';
            Editable = false;

            trigger OnValidate()
            begin
                Difference := "Statement Amount" - "Applied Amount";
            end;
        }
        field(10; Type; Option)
        {
            Caption = 'Type', Comment = 'ESM="Tipo"';
            OptionCaption = 'Bank Account Ledger Entry,Check Ledger Entry,Difference';
            OptionMembers = "Bank Account Ledger Entry","Check Ledger Entry",Difference;


        }
        field(11; "Applied Entries"; Integer)
        {
            Caption = 'Applied Entries', Comment = 'ESM="Movs. conciliados"';
            Editable = false;

        }
        field(12; "Value Date"; Date)
        {
            Caption = 'Value Date', Comment = 'ESM="Fecha Valor"';
        }
        field(13; "Ready for Application"; Boolean)
        {
            Caption = 'Ready for Application', Comment = 'ESM="Listo para Conciliar"';
        }
        field(14; "Check No."; Code[20])
        {
            Caption = 'Check No.', Comment = 'ESM="N° Cheque"';
        }
        field(15; "Related-Party Name"; Text[250])
        {
            Caption = 'Related-Party Name', Comment = 'ESM="Nombre de parte Vinculada"';
        }
        field(16; "Additional Transaction Info"; Text[100])
        {
            Caption = 'Additional Transaction Info', Comment = 'ESM="Información adicional de transacción"';
        }
        field(17; "Data Exch. Entry No."; Integer)
        {
            Caption = 'Data Exch. Entry No.', Comment = 'ESM="N.º mov. intercambio de datos"';
            Editable = false;
            TableRelation = "Data Exch.";
        }
        field(18; "Data Exch. Line No."; Integer)
        {
            Caption = 'Data Exch. Line No.', Comment = 'ESM="N.º línea intercambio de datos"';
            Editable = false;
        }
        field(20; "Statement Type"; Option)
        {
            Caption = 'Statement Type', Comment = 'ESM="Tipo de estado de cuenta"';
            OptionCaption = 'Bank Reconciliation,Payment Application';
            OptionMembers = "Bank Reconciliation","Payment Application";
        }
        field(21; "Account Type"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Account Type', Comment = 'ESM="Tipo de cta."';

            trigger OnValidate()
            begin
                TestField("Applied Amount", 0);
                if "Account Type" = "Account Type"::"IC Partner" then
                    if not ConfirmManagement.GetResponse(ICPartnerAccountTypeQst, false) then begin
                        "Account Type" := xRec."Account Type";
                        exit;
                    end;
                if "Account Type" <> xRec."Account Type" then
                    Validate("Account No.", '');
            end;
        }
        field(22; "Account No."; Code[20])
        {
            Caption = 'Account No.', Comment = 'ESM="Nº cuenta"';
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                                                          Blocked = CONST(false))
            ELSE
            IF ("Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Account Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Account Type" = CONST("IC Partner")) "IC Partner";


        }
        field(23; "Transaction Text"; Text[140])
        {
            Caption = 'Transaction Text', Comment = 'ESM="Texto transacción"';

            trigger OnValidate()
            begin
                if ("Statement Type" = "Statement Type"::"Payment Application") or (Description = '') then
                    Description := CopyStr("Transaction Text", 1, MaxStrLen(Description));
            end;
        }
        field(24; "Related-Party Bank Acc. No."; Text[100])
        {
            Caption = 'Related-Party Bank Acc. No.', Comment = 'ESM="N.º cta. bancaria parte vinculada"';
        }
        field(25; "Related-Party Address"; Text[100])
        {
            Caption = 'Related-Party Address', Comment = 'ESM="Dirección parte vinculada"';
        }
        field(26; "Related-Party City"; Text[50])
        {
            Caption = 'Related-Party City', Comment = 'ESM="Municipio/Ciudad parte vinculada"';
        }
        field(27; "Payment Reference No."; Code[50])
        {
            Caption = 'Payment Reference', Comment = 'ESM="Referencia de Pago"';
        }
        field(31; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));


        }
        field(32; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));


        }
        field(50; "Match Confidence"; Option)
        {
            CalcFormula = Max("Applied Payment Entry"."Match Confidence" WHERE("Statement Type" = FIELD("Statement Type"),
                                                                                "Bank Account No." = FIELD("Bank Account No."),
                                                                                "Statement No." = FIELD("Statement No."),
                                                                                "Statement Line No." = FIELD("Statement Line No.")));
            Caption = 'Match Confidence', Comment = 'ESM="Confianza de la coincidencia"';
            Editable = false;
            FieldClass = FlowField;
            InitValue = "None";
            OptionCaption = 'None,Low,Medium,High,High - Text-to-Account Mapping,Manual,Accepted';
            OptionMembers = "None",Low,Medium,High,"High - Text-to-Account Mapping",Manual,Accepted;
        }
        field(51; "Match Quality"; Integer)
        {
            CalcFormula = Max("Applied Payment Entry".Quality WHERE("Bank Account No." = FIELD("Bank Account No."),
                                                                     "Statement No." = FIELD("Statement No."),
                                                                     "Statement Line No." = FIELD("Statement Line No."),
                                                                     "Statement Type" = FIELD("Statement Type")));
            Caption = 'Match Quality', Comment = 'ESM="Corresponder calida"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60; "Sorting Order"; Integer)
        {
            Caption = 'Sorting Order', Comment = 'ESM="Orden clasificación"';
        }
        field(61; "Parent Line No."; Integer)
        {
            Caption = 'Parent Line No.', Comment = 'ESM="N.º línea maestro"';
            Editable = false;
        }
        field(70; "Transaction ID"; Text[50])
        {
            Caption = 'Transaction ID', Comment = 'ESM="Id. de transacción"';
        }
        field(71; "Closed"; Boolean)
        {
            Caption = 'Closed', Comment = 'ESM="Cerrado"';
        }
        field(72; "Reconciled"; Boolean)
        {
            Caption = 'Reconciled', Comment = 'ESM="Conciliado"';
        }
        field(51002; "Description 2"; Text[100])
        {
            Caption = 'Description Atria', Comment = 'ESM="Descripción Atria"';
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID', Comment = 'ESM="Id. grupo dimensiones"';
            Editable = false;
            TableRelation = "Dimension Set Entry";



            trigger OnValidate()
            begin
                DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
            end;
        }
    }

    keys
    {
        key(Key1; "Statement Type", "Bank Account No.", "Transaction Date", "Document No.", "Statement Amount")
        {
            Clustered = true;
        }
        key(Key2; "Account Type", "Statement Amount")
        {
        }
        key(Key3; Type, "Applied Amount")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if Rec.Closed then
            Error('Mov Cerrado no puede ser eliminado.!');
    end;

    trigger OnInsert()
    begin

        "Applied Entries" := 0;
        Validate("Applied Amount", 0);
        Validate("Statement Amount");
    end;

    trigger OnModify()
    begin

    end;

    trigger OnRename()
    begin
        Error(Text000, TableCaption);
    end;

    var
        Text000: Label 'You cannot rename a %1.';
        Text001: Label 'Delete application?';
        Text002: Label 'Update canceled.';
        BankAccLedgEntry: Record "Bank Account Ledger Entry";
        CheckLedgEntry: Record "Check Ledger Entry";
        BankAccRecon: Record "Bank Acc. Reconciliation";
        BankAccSetStmtNo: Codeunit "Bank Acc. Entry Set Recon.-No.";
        CheckSetStmtNo: Codeunit "Check Entry Set Recon.-No.";
        DimMgt: Codeunit DimensionManagement;
        ConfirmManagement: Codeunit "Confirm Management";
        AmountWithinToleranceRangeTok: Label '>=%1&<=%2', Locked = true;
        AmountOustideToleranceRangeTok: Label '<%1|>%2', Locked = true;
        TransactionAmountMustNotBeZeroErr: Label 'The Transaction Amount field must have a value that is not 0.';
        CreditTheAccountQst: Label 'The remaining amount to apply is %2.\\Do you want to create a new payment application line that will debit or credit %1 with the remaining amount when you post the payment?', Comment = '%1 is the account name, %2 is the amount that is not applied (there is filed on the page named Remaining Amount To Apply)';
        ExcessiveAmountErr: Label 'The remaining amount to apply is %1.', Comment = '%1 is the amount that is not applied (there is filed on the page named Remaining Amount To Apply)';
        ImportPostedTransactionsQst: Label 'The bank statement contains payments that are already applied, but the related bank account ledger entries are not closed.\\Do you want to include these payments in the import?';
        ICPartnerAccountTypeQst: Label 'The resulting entry will be of type IC Transaction, but no Intercompany Outbox transaction will be created. \\Do you want to use the IC Partner account type anyway?';



    procedure GetCurrencyCode(): Code[10]
    var
        BankAcc: Record "Bank Account";
    begin
        if "Bank Account No." = BankAcc."No." then
            exit(BankAcc."Currency Code");

        if BankAcc.Get("Bank Account No.") then
            exit(BankAcc."Currency Code");

        exit('');
    end;

    procedure GetStyle(): Text
    begin
        if "Applied Entries" <> 0 then
            exit('Favorable');

        exit('');
    end;

}
