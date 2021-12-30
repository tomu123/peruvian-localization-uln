table 51012 "Posted Payment Schedule"
{
    DataClassification = ToBeClassified;
    Caption = 'Payment Schedule', Comment = 'ESM="Hist. Cronograma de pagos"';

    fields
    {
        field(51001; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Entry No.', Comment = 'ESM="No. Movimiento"';
        }
        field(51002; "VAT Registration No."; code[12])
        {
            DataClassification = ToBeClassified;
            Caption = 'VAT Registration No.', Comment = 'ESM="N° RUC/DNI"';
        }
        field(51003; "External Document No."; code[35])
        {
            DataClassification = ToBeClassified;
            Caption = 'External Document No.', Comment = 'ESM="N° Documento Externo"';
        }
        field(51004; "Receipt Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Receipt Date', Comment = 'ESM="Fecha recepción"';
        }

        field(51005; "Due Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Due Date', Comment = 'ESM="Fecha Vencimiento"';
        }
        field(51006; "Delay Days"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Delay Days', Comment = 'ESM="Diferencia en días"';
        }
        field(51007; "Currency Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Currency Code', Comment = 'ESM="Cód. Divisa"';
        }
        field(51008; Amount; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Amount', Comment = 'ESM="Importe Pendiente"';
        }
        field(51009; "Amount LCY"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Amount LCY', Comment = 'ESM="Importe Pendiente D. Local"';
        }
        field(51010; "Total a Pagar"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Total a Pagar';
            trigger OnValidate();
            begin
                IF ABS("Total a Pagar") > ABS(Amount) THEN
                    ERROR('El Monto a Pagar no puede exceder al "Importe", ¡Revisar!');

                IF "Total a Pagar" > 0 THEN
                    "Total a Pagar" := ("Total a Pagar" * -1);
            end;
        }
        field(51011; "Preferred Bank Account Code"; code[45])
        {
            DataClassification = ToBeClassified;
            Caption = 'Preferred Bank Account Code', Comment = 'ESM="CÓD. Banco Destino"';
            trigger OnValidate();
            var
                lcRecCustBankAccount: Record "Customer Bank Account";
                lcRecVendBankAccount: Record "Vendor Bank Account";
            begin
                CASE "Type Source" OF
                    "Type Source"::"Customer Entries":
                        BEGIN
                            lcRecCustBankAccount.RESET;
                            lcRecCustBankAccount.SETRANGE("Customer No.", "VAT Registration No.");
                            lcRecCustBankAccount.SETRANGE(Code, "Preferred Bank Account Code");
                            IF lcRecCustBankAccount.FINDFIRST THEN BEGIN
                                "Reference Bank Acc. No." := lcRecCustBankAccount."Reference Bank Acc. No.";
                                "Bank Account No." := lcRecCustBankAccount."Bank Account No.";
                                //"Is Payment Check" := lcRecCustBankAccount."MPW Check"; Is Agr no
                            END ELSE BEGIN
                                "Reference Bank Acc. No." := '-';
                                "Bank Account No." := '-';
                                "Is Payment Check" := FALSE;
                            END;
                        END;
                    "Type Source"::"Vendor Entries":
                        BEGIN
                            lcRecVendBankAccount.RESET;
                            lcRecVendBankAccount.SETRANGE("Vendor No.", "VAT Registration No.");
                            lcRecVendBankAccount.SETRANGE(Code, "Preferred Bank Account Code");
                            IF lcRecVendBankAccount.FINDFIRST THEN BEGIN
                                "Reference Bank Acc. No." := lcRecVendBankAccount."Reference Bank Acc. No.";
                                "Bank Account No." := lcRecVendBankAccount."Bank Account No.";
                                //"Is Payment Check" := lcRecVendBankAccount."MPW Check"; Is Agr
                            END ELSE BEGIN
                                "Reference Bank Acc. No." := '-';
                                "Bank Account No." := '-';
                                "Is Payment Check" := FALSE;
                            END;
                        END;
                END;
            end;
        }
        field(51012; "Status"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Status', Comment = 'ESM="Estado"';
            OptionMembers = Pendiente,Procesado,"Por Pagar",Pagado;

        }
        field(51013; "Calculate Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Calculate Date', Comment = 'ESM="Fecha de corte"';
        }
        field(51014; "Document No."; Code[90])
        {
            DataClassification = ToBeClassified;
            Caption = 'Document No.', Comment = 'ESM="N° Documento"';
        }
        field(51015; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Posting Date', Comment = 'ESM="Fecha Registro"';
        }
        field(51016; "Bank Account No."; Code[80])
        {
            DataClassification = ToBeClassified;
            Caption = 'Bank Account No.', Comment = 'ESM="N° Cuenta Bancaria Destino Proveedor/Empleador"';
        }
        field(51017; "Reference Bank Acc. No."; Code[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Reference Bank', Comment = 'ESM="Cód. Banco Pagador"';
        }
        field(51018; "Document No. Post"; Code[35])
        {
            DataClassification = ToBeClassified;
            Caption = 'Document No. Post', Comment = 'ESM="N° Documento Registro"';
        }
        field(51019; "Source Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Source Entry No.', Comment = 'ESM="N° Mov. Origen"';
        }
        field(51020; "Type Source"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Type Source', Comment = 'ESM="Tipo de Origen"';
            OptionMembers = "Vendor Entries","Customer Entries","Employee Entries";
            OptionCaption = 'Vendor Entries,Customer Entries,Employee Entries', Comment = 'ESM="Mov. Proveedor,Mov. Cliente,Mov. Empleado"';
        }
        field(51021; "Posting Group"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Posting Group', Comment = 'ESM="Grupo Registro"';
        }
        field(51022; "Process Date"; DateTime)
        {
            DataClassification = ToBeClassified;
            Caption = 'Process Date', Comment = 'ESM="Fecha Procesamiento"';
        }
        field(51023; "Payment Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Payment Date', Comment = 'ESM="Fecha Pago"';
        }
        field(51024; "Payment Terms Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Payment Terms Code', Comment = 'ESM="Condición de pago"';
            TableRelation = "Payment Terms";
        }
        field(51025; "Vend./Cust. Account No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Vend./Cust. Account No.', Comment = 'ESM="Empleado/Proveedor cta contable N°"';
        }
        field(51026; "Document Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Document Date', Comment = 'ESM="Fecha Emisión"';
        }
        field(51027; "Process Date 2"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Process Date 2', Comment = 'ESM="Fecha Procesamiento 2"';
        }
        field(51028; "Business Name"; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Business Name', Comment = 'ESM="Nombre/Razón Social"';
        }
        field(51029; "Description"; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Description', Comment = 'ESM="Descripción"';
        }
        field(51030; "Original Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Original Amount', Comment = 'ESM="Importe Original"';
        }
        field(51031; "Service Type"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Service Type', Comment = 'ESM="Tipo de servicio"';
        }
        field(51032; "Description Service"; Text[90])
        {
            DataClassification = ToBeClassified;
            Caption = 'Description Service', Comment = 'ESM="Descripción de servicio"';
        }
        field(51033; "% Detraction"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = '% Detraction', Comment = 'ESM="% Detracción"';
        }
        field(51034; "Operation Type"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Operation Type', Comment = 'ESM="Tipo de Operación"';
        }
        field(51035; "Description OP."; Text[90])
        {
            DataClassification = ToBeClassified;
            Caption = 'Description OP.', Comment = 'ESM="Descripción de operación"';
        }
        field(51036; "User ID"; Code[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Assigned User ID', Comment = 'ESM="Usuario Proceso CP"';
            TableRelation = User;
        }
        field(51037; "Setup Source Code"; Enum "ST Source Code Type")
        {
            DataClassification = ToBeClassified;
            Caption = 'Source Code ULN', Comment = 'ESM="Cód. Origen ULN"';
        }
        field(51038; "Source User Id."; Code[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Source User Id.', Comment = 'ESM="Usuario Origen"';

        }
        field(51039; "Payment Method Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Payment Method Code', Comment = 'ESM="Cód. Forma de pago"';
            TableRelation = "Payment Method";
        }
        field(51040; "Is Payment Check"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Is Payment Check', Comment = 'ESM="Pago con cheque"';
            //TableRelation = "Payment Method";
        }
        field(51041; "T.C. Dollarized"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'T.C. Dolarizado', Comment = 'ESM="T.C. Dolarizado"';
            DecimalPlaces = 0 : 3;
            //TableRelation = "Payment Method";
        }
        field(51042; "Dollarized"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Dolarizado', Comment = 'ESM="Dolarizado "';
            DecimalPlaces = 0 : 2;
            //TableRelation = "Payment Method";
        }
        field(51043; "Source Currency Factor"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Source Currency Factor', Comment = 'ESM="Factor divisa de origen"';
        }
        field(51044; "Reversed Vendor"; Boolean)
        {
            CalcFormula = lookup("Vendor Ledger Entry".Reversed WHERE("Document No." = FIELD("Document No. Post")));
            Caption = 'Reversed Vendor', Comment = 'ESM="Revertido proveedor"';
            Editable = false;
            FieldClass = FlowField;

            trigger OnLookup()
            begin
                Rec."Source Currency Factor" := Rec."Source Currency Factor";
            end;
        }
        field(51045; "Reversed Employee"; Boolean)
        {
            CalcFormula = lookup("Employee Ledger Entry".Reversed WHERE("Document No." = FIELD("Document No. Post")));
            Caption = 'Reversed Empleado', Comment = 'ESM="Revertido Empleado"';
            Editable = false;
            FieldClass = FlowField;

            trigger OnLookup()
            begin
                Rec."Source Currency Factor" := Rec."Source Currency Factor";
            end;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        recVendorLedgerEntry: Record "Vendor Ledger Entry";
        gNroDocumentoLiquidar: Code[70];
        lcRecVendLedgerEntry: Record "Vendor Ledger Entry";
        lcText0004: Label 'El documento %1 no se encuentra como pendiente.';
        lcRecCustLedgerEntry: Record "Cust. Ledger Entry";
        lcPgApplyVendEntries: Page "Apply Vendor Entries";
        lcPgApplyCustEntries: Page "Apply Customer Entries";
        recCustLedgerEntry: Record "Cust. Ledger Entry";
        gIsBatchCheck: Boolean;

    procedure fnNextLine(): Integer;
    var
        PostedPaymentSchedule: Record "Posted Payment Schedule";
    begin
        PostedPaymentSchedule.RESET;
        PostedPaymentSchedule.SETCURRENTKEY("Entry No.");
        PostedPaymentSchedule.SETFILTER("Entry No.", '<>%1', 0);
        IF PostedPaymentSchedule.FINDLAST THEN
            EXIT(PostedPaymentSchedule."Entry No." + 1)
        ELSE
            EXIT(1);
    end;
}

