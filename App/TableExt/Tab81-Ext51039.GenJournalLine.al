tableextension 51039 "Setup Gen. Journal Line" extends "Gen. Journal Line"
{
    fields
    {
        //Fields ids permission 51004..51005,51030..51039,,51045..51049,51050..51061
        //Legal Document Begin
        field(51000; "Legal Document"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Legal Document', Comment = 'ESM="Documento Legal"';
        }

        field(51001; "Legal Status"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Legal Status', Comment = 'ESM="Estado legal"';
            OptionMembers = Success,Anulled,OutFlow;
            OptionCaption = 'Success,Anulled,OutFlow', Comment = 'ESM="Normal,Anulado,Extornado"';
        }

        field(51002; "Legal Document Ref."; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Legal Document Ref.', Comment = 'ESM="Documento Legal Ref."';
        }
        field(51003; "VAT Registration Type"; Code[2])
        {
            DataClassification = ToBeClassified;
            Caption = 'VAT Registration Type', Comment = 'ESM="Tipo Doc. Identidad"';
            TableRelation = "Legal Document"."Legal No." where("Option Type" = const("SUNAT Table"), "Type Code" = const('02'));
            ValidateTableRelation = false;
        }
        //Legal Document End
        field(51004; "Applies-to Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Applies-to Entry No.', comment = 'ESM="Liq. por id. movimiento"';
            TableRelation = if ("Account Type" = const(Customer)) "Cust. Ledger Entry" where("Customer No." = field("Account No."), "Document No." = field("Applies-to Doc. No."), Open = const(true)) else
            if ("Account Type" = const(Vendor)) "Vendor Ledger Entry" where("Vendor No." = field("Account No."), "Document No." = field("Applies-to Doc. No."), Open = const(true)) else
            if ("Account Type" = const(Employee)) "Employee Ledger Entry" where("Employee No." = field("Account No."), "Document No." = field("Applies-to Doc. No."), Open = const(true));
            trigger OnValidate()
            var
                CustLedgEntry: Record "Cust. Ledger Entry";
                VendLedgEntry: Record "Vendor Ledger Entry";
                EmplLedgEntry: Record "Employee Ledger Entry";
            begin
                if "Applies-to Entry No." = 0 then
                    exit;
                case "Account Type" of
                    "Account Type"::Customer:
                        begin
                            CustLedgEntry.Get("Applies-to Entry No.");
                            Validate("Applies-to Doc. No.", CustLedgEntry."Document No.");
                        end;
                    "Account Type"::Vendor:
                        begin
                            VendLedgEntry.Get("Applies-to Entry No.");
                            Validate("Applies-to Doc. No.", VendLedgEntry."Document No.");
                        end;
                    "Account Type"::Employee:
                        begin
                            EmplLedgEntry.Get("Applies-to Entry No.");
                            Validate("Applies-to Doc. No.", EmplLedgEntry."Document No.");
                        end;
                end;
            end;
        }
        field(51005; "Posting Text"; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Posting Text', comment = 'ESM="Glosa Principal"';
            ;
            trigger
            OnValidate();
            var
                Character: Text;
                CharacterInvalid: Label 'Cannot enter the stick character "|" in the text field register for the correct display of electronic books.',
                 Comment = 'ESM="No se puede ingresar el caracter palote "|" en el campo texto registro por la correcta visualización de libros electronicos."';
            begin
                Character := '';
                Character := DelChr("Posting Text", '=', DELCHR("Posting Text", '=', '|'));
                IF StrLen(Character) <> 0 THEN
                    Error(CharacterInvalid);
            end;
        }
        field(51017; "Bulk Payment Type"; Code[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Bulk Payment Type', comment = 'ESM="Tipo de pago masivo"';
        }
        field(51020; "Check Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Check Name', Comment = 'ESM="Nombre "';
        }
        field(51030; "Setup Source Code"; Enum "ST Source Code Type")
        {
            DataClassification = ToBeClassified;
            Caption = 'Source Code ULN', Comment = 'ESM="Cód. Origen proceso"';
        }
        field(51031; "Source Currency Factor"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Source Currency Factor', Comment = 'ESM="Factor divisa origen"';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;
        }
        field(51032; "ST Control Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Control Entry No.', Comment = 'ESM="N° Mov. Ref. Control"';
        }
        field(51033; "Source User Id."; Code[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Source User Id.', Comment = 'ESM="Id. Usuario Origen"';
            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }
        field(51034; "Ref. Source Type"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Ref. Source type', Comment = 'ESM="Ref. Tipo de origen"';
            OptionMembers = " ",Customer,Vendor,"Bank Account","Fixed Asset",Employee;
            OptionCaption = ' ,Customer,Vendor,Bank Account,Fixed Asset,Employee', comment = 'ESM=" ,Cliente,Proveedor,Banco,Activo Fijo,Empleado"';
        }
        field(51035; "Ref. Source No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Ref. Source No.', Comment = 'ESM="Ref. Cód. Origen"';
        }
        field(51036; "Ref. Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Ref. Document No.', Comment = 'ESM="Ref. N° Documento"';
        }
        field(51037; "Payment Bank Account No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Payment Bank Account No.', Comment = 'ESM="N° Banco empleado pago"';
            //TableRelation = "ST Employee Bank Account"."Payment Bank Account No." where("Employee No." = field("Employee No."));
            TableRelation = if ("Account Type" = const(Employee)) "ST Employee Bank Account"."Payment Bank Account No." where("Employee No." = field("Account No."));
            ValidateTableRelation = false;
        }
        field(51038; "Payment is check"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Payment is check', Comment = 'ESM="Pago es cheque"';
        }
        field(51039; "Income/Balance"; Option)
        {
            Caption = 'Income/Balance', Comment = 'ESM="Ingresos/Saldo"';
            OptionCaption = ' ,Income Statement,Balance Sheet', Comment = 'ESM=" ,Resultado,Balance"';
            OptionMembers = " ","Income Statement","Balance Sheet";
        }
        field(51045; "Applies-to Acc. Group Mixed"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Applies-to accountant group mixed', Comment = 'ESM="Liq. Grupo contable mixto"';
        }


        modify("Account No.")
        {
            trigger OnAfterValidate()
            begin
                case "Account Type" of
                    "Account Type"::"G/L Account":
                        begin
                            if GLAccount.Get("Account No.") then begin
                                if GLAccount."Income/Balance" = GLAccount."Income/Balance"::"Balance Sheet" then
                                    "Income/Balance" := "Income/Balance"::"Balance Sheet"
                                else
                                    "Income/Balance" := "Income/Balance"::"Income Statement";
                            end;
                        end;
                    else
                        "Income/Balance" := "Income/Balance"::" ";
                end;
                "Source User Id." := UserId;
            end;
        }

        modify("Recipient Bank Account")
        {
            TableRelation = IF ("Account Type" = CONST(Customer)) "Customer Bank Account".Code WHERE("Customer No." = FIELD("Account No."))
            ELSE
            IF ("Account Type" = CONST(Vendor)) "Vendor Bank Account".Code WHERE("Vendor No." = FIELD("Account No."))
            ELSE
            IF ("Account Type" = CONST(Employee)) "ST Employee Bank Account".Code WHERE("Employee No." = FIELD("Account No."))
            ELSE
            IF ("Bal. Account Type" = CONST(Customer)) "Customer Bank Account".Code WHERE("Customer No." = FIELD("Bal. Account No."))
            ELSE
            IF ("Bal. Account Type" = CONST(Vendor)) "Vendor Bank Account".Code WHERE("Vendor No." = FIELD("Bal. Account No."))
            ELSE
            IF ("Bal. Account Type" = CONST(Employee)) "ST Employee Bank Account".Code WHERE("Employee No." = FIELD("Bal. Account No."));
            //TableRelation = "ST Employee Bank Account".Code;

            trigger OnAfterValidate()
            var
                CustBankAcc: Record "Customer Bank Account";
                VendBankAcc: Record "Vendor Bank Account";
                EmplBankAcc: Record "ST Employee Bank Account";
            begin
                if "Recipient Bank Account" <> '' then begin
                    if "Account Type" = "Account Type"::Customer then begin
                        CustBankAcc.Get("Account No.", "Recipient Bank Account");
                        "Payment Bank Account No." := CustBankAcc."Reference Bank Acc. No.";
                        "Payment is check" := CustBankAcc."Bank Type Check";
                    end else
                        if "Account Type" = "Account Type"::Vendor then begin
                            VendBankAcc.Get("Account No.", "Recipient Bank Account");
                            "Payment Bank Account No." := VendBankAcc."Reference Bank Acc. No.";
                            "Payment is check" := VendBankAcc."Bank Type Check";
                        end else
                            if "Account Type" = "Account Type"::Employee then begin
                                EmplBankAcc.Get("Account No.", "Recipient Bank Account");
                                "Payment Bank Account No." := EmplBankAcc."Payment Bank Account No.";
                                "Payment is check" := EmplBankAcc."Bank Type Check";
                            end;
                end else begin
                    "Payment Bank Account No." := '';
                    "Payment is check" := false;
                end;
            end;
        }

        //Retentions Begin
        field(51010; "Retention No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Retention No.', Comment = 'ESM="N° Retención"';
        }
        field(51011; "Retention Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Retention Amount', Comment = 'ESM="Importe retención"';
        }
        field(51012; "Retention Amount LCY"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Retention Amount LCY', Comment = 'ESM="Importe retención DL"';
        }
        field(51013; "Applied Retention"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Applied Retention', Comment = 'ESM="Aplicar retención"';
            trigger OnValidate()
            begin
                if not "Applied Retention" then begin
                    DeleteLineForRetention();
                    "Retention Amount" := 0;
                    "Retention Amount LCY" := 0;
                    "Retention Applies-to Entry No." := 0;
                    "Apply Retention To Line" := false;
                    exit;
                end;
                TestField("Account Type", "Account Type"::Vendor);
                TestField("Posting Date");
                TestField("Applies-to Entry No.");
                TestField("Applies-to Doc. No.");
                RetentionMgt.ValidateRetention("Applied Retention", "Account No.", "Applies-to Doc. No.", "Posting Date");
            end;
        }
        field(51014; "Apply Retention To Line"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Apply Retention To Line', Comment = 'ESM="Aplicación a linea retención"';
        }
        field(51015; "Retention Applies-to Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Retention Applies-to Entry No.', Comment = 'ESM="N° Mov. aplicado retención"';
        }
        field(51016; "Manual Retention"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Manual Retention', Comment = 'ESM="Retención manual"';
        }
        field(51018; "Skip Dimensions"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Skip Dimensions', Comment = 'ESM="Omitir Dimensiones"';
        }
        field(51019; "Opening"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Opening', Comment = 'ESM=Apertura';
        }
        field(51028; "Reference to apply No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Reference to apply No.', Comment = 'ESM="N° de aplicación referencia retención"';
        }
        field(51050; "Source Entry No. apply to ret."; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Source Entry No. apply to ret.', Comment = 'ESM="N° Linea Origen retención en diario"';
        }
        field(51051; "Internal Control Bool"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(51052; "SL Source Currency Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Source Currency Code Loc.', Comment = 'ESM="Cód. Origen Divisa (Loc)"';
        }
        field(51053; "Migration"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Migration', Comment = 'ESM="Migración"';
        }
        //51053 y 51054 libres
        field(51055; "Accountant receipt date"; date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Accountant receipt date', Comment = 'ESM="Fecha recepción contabilidad"';
        }
        modify(Amount)
        {
            trigger OnAfterValidate()
            begin
                SetAutomateRetention();
            end;
        }
        modify("Applies-to Doc. No.")
        {
            trigger OnAfterValidate()
            begin
                SetAutomateRetention();
            end;
        }
        modify("Posting Date")
        {
            trigger OnAfterValidate()
            begin
                SetAutomateRetention();
            end;
        }
        modify("Currency Code")
        {
            trigger OnAfterValidate()
            begin
                Rec."Source Currency Factor" := Rec."Currency Factor";
                Rec."SL Source Currency Code" := Rec."Currency Code";
            end;
        }

        //Retentions End

        //Import
        field(51006; "Importation No."; code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Importation No.', Comment = 'ESP="N° Importación"';
            TableRelation = Importation;
        }
        field(51061; "ST Recipient Bank Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Cta. Bancaria destinatario';
            TableRelation = IF ("Account Type" = CONST(Customer)) "Customer Bank Account".Code WHERE("Customer No." = FIELD("Account No."))
            ELSE
            IF ("Account Type" = CONST(Vendor)) "Vendor Bank Account".Code WHERE("Vendor No." = FIELD("Account No."))
            ELSE
            IF ("Account Type" = CONST(Employee)) "ST Employee Bank Account".Code WHERE("Employee No." = FIELD("Account No."))
            ELSE
            IF ("Bal. Account Type" = CONST(Customer)) "Customer Bank Account".Code WHERE("Customer No." = FIELD("Bal. Account No."))
            ELSE
            IF ("Bal. Account Type" = CONST(Vendor)) "Vendor Bank Account".Code WHERE("Vendor No." = FIELD("Bal. Account No."))
            ELSE
            IF ("Bal. Account Type" = CONST(Employee)) "ST Employee Bank Account".Code WHERE("Employee No." = FIELD("Bal. Account No."));
            //TableRelation = "ST Employee Bank Account".Code;
            trigger OnValidate()
            var
                CustBankAcc: Record "Customer Bank Account";
                VendBankAcc: Record "Vendor Bank Account";
                EmplBankAcc: Record "ST Employee Bank Account";
            begin

                if "ST Recipient Bank Account" <> '' then begin
                    if "Account Type" = "Account Type"::Customer then begin
                        CustBankAcc.Get("Account No.", "ST Recipient Bank Account");
                        "Payment Bank Account No." := CustBankAcc."Reference Bank Acc. No.";
                        "Payment is check" := CustBankAcc."Bank Type Check";
                    end else
                        if "Account Type" = "Account Type"::Vendor then begin
                            VendBankAcc.Get("Account No.", "ST Recipient Bank Account");
                            "Payment Bank Account No." := VendBankAcc."Reference Bank Acc. No.";
                            "Payment is check" := VendBankAcc."Bank Type Check";
                        end else
                            if "Account Type" = "Account Type"::Employee then begin
                                EmplBankAcc.Get("Account No.", "ST Recipient Bank Account");
                                "Payment Bank Account No." := EmplBankAcc."Payment Bank Account No.";
                                "Payment is check" := EmplBankAcc."Bank Type Check";
                            end;
                end else begin
                    "Payment Bank Account No." := '';
                    "Payment is check" := false;
                end;
                "Recipient Bank Account" := "ST Recipient Bank Account";
                if "Recipient Bank Account" = '' then
                    exit;
                if ("Document Type" in ["Document Type"::Invoice, "Document Type"::" ", "Document Type"::"Credit Memo"]) and
                   (("Account Type" in ["Account Type"::Customer, "Account Type"::Vendor]) or
                    ("Bal. Account Type" in ["Bal. Account Type"::Customer, "Bal. Account Type"::Vendor]))
                then
                    "Recipient Bank Account" := '';
            end;
        }

        field(51065; "ST Document CV"; code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ULN::PC:ASIND';
            Caption = 'Document CV', Comment = 'ESP="Document CV"';
        }
        field(51066; "ST Account CV"; code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ULN::PC 001';
            Caption = 'Account CV', Comment = 'ESP="Account CV"';
        }
        field(51067; "ST Date CV"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'ULN::PC 001';
            Caption = 'Date CV', Comment = 'ESP="Fecha CV"';
        }
        field(51068; "ST Job Process"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ULN::PC 001';
            Caption = 'Job Process', Comment = 'ESP="Fecha CV"';
        }
        field(51069; "ST IS Conciliation"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ULN::PC 001';
            Caption = 'ST IS Conciliation', Comment = 'ESP="Conciliación"';
        }
        field(51070; "ST Document No. Conciliation"; Text[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ULN::PC 001';
            Caption = 'Document No. Conciliation', Comment = 'ESP="Nº documento Conciliación"';
        }

    }

    trigger OnAfterDelete()
    begin
        if Rec."Setup Source Code" <> Rec."Setup Source Code"::"Payment Schedule" then
            exit;
        if Rec."ST Control Entry No." = 0 then
            exit;
        PaymentSchedule.Get("ST Control Entry No.");
        PaymentSchedule.Status := PaymentSchedule.Status::Procesado;
        PaymentSchedule.Modify();
    end;

    var
        GLAccount: Record "G/L Account";
        RetentionMgt: Codeunit "Retention Management";
        PaymentSchedule: record "Payment Schedule";

    local procedure SetAutomateRetention()
    begin
        if ("Account Type" = "Account Type"::Vendor) and ("Account No." <> '') and
            ("Posting Date" <> 0D) and ("Applies-to Doc. No." <> '') and ("Amount (LCY)" <> 0) then
            RetentionMgt.SetAutomateRetentionCheck("Applied Retention", "Account No.", "Posting Date", "Applies-to Doc. No.", "Amount (LCY)");
    end;

    local procedure DeleteLineForRetention()
    var
        DelGenJnlLine: Record "Gen. Journal Line";
        UpdateGenJnlLine: Record "Gen. Journal Line";
    begin
        if IsEmpty then
            exit;
        DelGenJnlLine.Reset();
        DelGenJnlLine.SetRange("Journal Template Name", "Journal Template Name");
        DelGenJnlLine.SetRange("Journal Batch Name", "Journal Batch Name");
        DelGenJnlLine.SetRange("Source Entry No. apply to ret.", "Line No.");
        if DelGenJnlLine.FindFirst() then begin
            UpdateGenJnlLine.Reset();
            UpdateGenJnlLine.SetRange("Journal Template Name", "Journal Template Name");
            UpdateGenJnlLine.SetRange("Journal Batch Name", "Journal Batch Name");
            UpdateGenJnlLine.SetRange("Account Type", "Account Type"::"Bank Account");
            if UpdateGenJnlLine.FindFirst() then begin
                UpdateGenJnlLine.Validate("Amount (LCY)", UpdateGenJnlLine."Amount (LCY)" + "Retention Amount LCY");
                UpdateGenJnlLine.Modify();
            end;
            DelGenJnlLine.Delete();
        end;
    end;

    procedure AdjustDifferenceForDumbUser(GenJnlLine: Record "Gen. Journal Line")
    var
        GenJnlLine2: Record "Gen. Journal Line";
        GenJnlLineDocsTemp: Record "Gen. Journal Line" temporary;
        MyAmountLCY: Decimal;
    begin
        GenJnlLine2.Reset();
        GenJnlLine2.SetRange("Journal Template Name", GenJnlLine."Journal Template Name");
        GenJnlLine2.SetRange("Journal Batch Name", GenJnlLine."Journal Batch Name");
        if GenJnlLine2.FindFirst() then
            repeat
                GenJnlLineDocsTemp.Reset();
                GenJnlLineDocsTemp.SetRange("Journal Template Name", GenJnlLine2."Journal Template Name");
                GenJnlLineDocsTemp.SetRange("Journal Batch Name", GenJnlLine2."Journal Batch Name");
                GenJnlLineDocsTemp.SetRange("Document No.", GenJnlLine2."Document No.");
                if GenJnlLineDocsTemp.IsEmpty then begin
                    GenJnlLineDocsTemp.init();
                    GenJnlLineDocsTemp.TransferFields(GenJnlLine2, true);
                    GenJnlLineDocsTemp.Insert();
                end;
            until GenJnlLine2.Next() = 0;

        CalculateNetBalance(GenJnlLineDocsTemp);

        GenJnlLineDocsTemp.Reset();
        if GenJnlLineDocsTemp.FindFirst() then
            repeat
                GenJnlLine2.Reset();
                GenJnlLine2.SetRange("Journal Template Name", GenJnlLineDocsTemp."Journal Template Name");
                GenJnlLine2.SetRange("Journal Batch Name", GenJnlLineDocsTemp."Journal Batch Name");
                GenJnlLine2.SetRange("Document No.", GenJnlLineDocsTemp."Document No.");
                GenJnlLine2.SetRange("Account Type", GenJnlLine."Account Type"::"Bank Account");
                if GenJnlLine2.FindFirst() then
                    repeat
                        if GenJnlLine2."Currency Code" = '' then
                            GenJnlLine2.Validate("Amount (LCY)", GenJnlLine2."Amount (LCY)" + GenJnlLineDocsTemp."Amount (LCY)")
                        else
                            GenJnlLine2.Validate(Amount, (GenJnlLine2."Amount (LCY)" + GenJnlLineDocsTemp."Amount (LCY)") * GenJnlLine2."Currency Factor");
                        GenJnlLine2.Modify();
                    until GenJnlLine2.Next() = 0;
            until GenJnlLineDocsTemp.Next() = 0;
    end;

    local procedure CalculateNetBalance(var GenJnlLineDocsTemp: Record "Gen. Journal Line" temporary)
    var
        GenJnlLine: Record "Gen. Journal Line";
        TotalAmounLCY: Decimal;
    begin
        GenJnlLineDocsTemp.Reset();
        if GenJnlLineDocsTemp.FindFirst() then
            repeat
                TotalAmounLCY := 0;
                GenJnlLine.Reset();
                GenJnlLine.SetRange("Journal Template Name", GenJnlLineDocsTemp."Journal Template Name");
                GenJnlLine.SetRange("Journal Batch Name", GenJnlLineDocsTemp."Journal Batch Name");
                GenJnlLine.SetRange("Document No.", GenJnlLineDocsTemp."Document No.");
                GenJnlLine.SetRange("Account Type", GenJnlLine."Account Type"::"Bank Account");
                if GenJnlLine.Count in [0, 2 .. 100] then
                    GenJnlLineDocsTemp.Delete();
                GenJnlLine.SetRange("Account Type");
                if GenJnlLine.FindFirst() then
                    repeat
                        TotalAmounLCY += GenJnlLine."Amount (LCY)";
                    until GenJnlLine.Next() = 0;
                if TotalAmounLCY <> 0 then begin
                    GenJnlLineDocsTemp."Amount (LCY)" := TotalAmounLCY * -1;
                    GenJnlLineDocsTemp.Modify();
                end else
                    GenJnlLineDocsTemp.Delete();
            until GenJnlLineDocsTemp.Next() = 0;
    end;
}