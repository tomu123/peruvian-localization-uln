table 51045 "BankReconciliation Line Buffer"
{
    Caption = 'Bank Acc. Reconciliation Line';
    Permissions = TableData "Data Exch. Field" = rimd;

    fields
    {
        field(1; "Bank Account No."; Code[20])
        {
            Caption = 'Bank Account No.';
            TableRelation = "Bank Account";
        }
        field(2; "Statement No."; Code[20])
        {
            Caption = 'Statement No.';

        }
        field(3; "Statement Line No."; Integer)
        {
            Caption = 'Statement Line No.';
        }
        field(4; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(5; "Transaction Date"; Date)
        {
            Caption = 'Transaction Date';
        }
        field(6; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(7; "Statement Amount"; Decimal)
        {

            AutoFormatType = 1;
            Caption = 'Statement Amount';

            trigger OnValidate()
            begin
                Difference := "Statement Amount" - "Applied Amount";
            end;
        }
        field(8; Difference; Decimal)
        {

            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Difference';

            trigger OnValidate()
            begin
                "Statement Amount" := "Applied Amount" + Difference;
            end;
        }
        field(9; "Applied Amount"; Decimal)
        {

            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Applied Amount';
            Editable = false;

            trigger OnValidate()
            begin
                Difference := "Statement Amount" - "Applied Amount";
            end;
        }
        field(10; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Bank Account Ledger Entry,Check Ledger Entry,Difference';
            OptionMembers = "Bank Account Ledger Entry","Check Ledger Entry",Difference;


        }
        field(11; "Applied Entries"; Integer)
        {
            Caption = 'Applied Entries';
            Editable = false;

        }
        field(12; "Value Date"; Date)
        {
            Caption = 'Value Date';
        }
        field(13; "Ready for Application"; Boolean)
        {
            Caption = 'Ready for Application';
        }
        field(14; "Check No."; Code[20])
        {
            Caption = 'Check No.';
        }
        field(15; "Related-Party Name"; Text[250])
        {
            Caption = 'Related-Party Name';
        }
        field(16; "Additional Transaction Info"; Text[100])
        {
            Caption = 'Additional Transaction Info';
        }
        field(17; "Data Exch. Entry No."; Integer)
        {
            Caption = 'Data Exch. Entry No.';
            Editable = false;
            TableRelation = "Data Exch.";
        }
        field(18; "Data Exch. Line No."; Integer)
        {
            Caption = 'Data Exch. Line No.';
            Editable = false;
        }
        field(20; "Statement Type"; Option)
        {
            Caption = 'Statement Type';
            OptionCaption = 'Bank Reconciliation,Payment Application';
            OptionMembers = "Bank Reconciliation","Payment Application";
        }
        field(21; "Account Type"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Account Type';

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
            Caption = 'Account No.';

        }
        field(23; "Transaction Text"; Text[140])
        {
            Caption = 'Transaction Text';

            trigger OnValidate()
            begin
                if ("Statement Type" = "Statement Type"::"Payment Application") or (Description = '') then
                    Description := CopyStr("Transaction Text", 1, MaxStrLen(Description));
            end;
        }
        field(24; "Related-Party Bank Acc. No."; Text[100])
        {
            Caption = 'Related-Party Bank Acc. No.';
        }
        field(25; "Related-Party Address"; Text[100])
        {
            Caption = 'Related-Party Address';
        }
        field(26; "Related-Party City"; Text[50])
        {
            Caption = 'Related-Party City';
        }
        field(27; "Payment Reference No."; Code[50])
        {
            Caption = 'Payment Reference';
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
            Caption = 'Match Confidence';
            Editable = false;
            FieldClass = FlowField;
            InitValue = "None";
            OptionCaption = 'None,Low,Medium,High,High - Text-to-Account Mapping,Manual,Accepted';
            OptionMembers = "None",Low,Medium,High,"High - Text-to-Account Mapping",Manual,Accepted;
        }
        field(51; "Match Quality"; Integer)
        {
        }
        field(60; "Sorting Order"; Integer)
        {
            Caption = 'Sorting Order';
        }
        field(61; "Parent Line No."; Integer)
        {
            Caption = 'Parent Line No.';
            Editable = false;
        }
        field(70; "Transaction ID"; Text[50])
        {
            Caption = 'Transaction ID';
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
        }
        field(51000; "Import Extract The Bank"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Imported from bank statement', Comment = 'ESM="Importado desde extracto de banco"';

        }
        field(51001; "EB Statement Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Statement Line No.', Comment = 'ESM="Nº lín. Extracto de cta. banco"';

        }
        field(51002; "Description 2"; Text[100])
        {
            Caption = 'Description Atria', Comment = 'ESM="Descripción Atria"';
        }
        field(51003; "Suministro No"; Text[50])
        {
            Caption = 'Suministro No', Comment = 'ESM="Suministro No"';
        }
    }

    keys
    {
        key(Key1; "Statement Type", "Bank Account No.", "Statement No.", "Statement Line No.")
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






}
