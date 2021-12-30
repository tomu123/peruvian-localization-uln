tableextension 51106 "Setup Bank Account" extends "Bank Account"
{
    fields
    {
        // Add changes to table fields here 51000..51002,51004
        field(51000; "Bank Account Type"; Enum "ST Bank Account Type")
        {
            DataClassification = ToBeClassified;
            Caption = 'Bank Account Type', Comment = 'ESM="Tipo cuenta bancaria"';
        }
        field(51001; "Is Check Bank"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Is Check Bank', Comment = 'ESM="Banco Cheque"';
        }
        field(51002; "Bank Account CCI"; Text[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'Bank Account CCI', Comment = 'ESM="N° Cuenta Banco"';
        }
        field(51030; "Process Type BBVA"; Option)
        {
            Caption = 'Process Type', Comment = 'ESM="Tipo Proceso"';
            OptionMembers = " ",Immediate,"Hour","Date";
            OptionCaption = ' ,Immediate,Hour,Date', Comment = 'ESM=" ,Inmediato,Hora,Fecha"';

            trigger OnValidate()
            begin
                IF "Process Type BBVA" <> "Process Type BBVA"::Hour THEN
                    "Process Hour" := "Process Hour"::" ";
            end;
        }
        field(51031; "Process Hour"; Option)
        {
            Caption = 'Process Hour', Comment = 'ESM="Proceso Hora"';
            OptionCaption = ' ,B = 11:00 a.m.,C = 03:00 p.m.,D = 07:00 p.m.';
            OptionMembers = " ","B = 11:00 a.m.","C = 03:00 p.m.","D = 07:00 p.m.";
        }
        //Legal Document
        field(51010; "Legal Document"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Legal Document', Comment = 'ESM="Documento Legal"';
            TableRelation = "Legal Document"."Legal No." where("Option Type" = const("SUNAT Table"), "Type Code" = const('03'));
        }
        field(51011; "Process Bank"; Option)
        {
            Caption = 'Collection Bank', Comment = 'ESM="Banco Recaudación"';
            OptionCaption = ' ,BCP,BBVA,SCOTIA,INTERBANK,BANBIF';
            OptionMembers = " ",BCP,BBVA,SCOTIA,INTERBANK,BANBIF;
        }

        //Conciliacion
        modify("Bank Statement Import Format")
        {
            Caption = 'Bank Statement Import Format Collection', Comment = 'ESM="Formato de importación de estado de cuenta de banco Recaudación"';
            // TableRelation = "Bank Export/Import Setup".Code WHERE(Direction = CONST(Import), "ST Conciliation" = const(false));

        }
        field(51032; "Import Format Statement"; Code[20])
        {
            Caption = 'Bank Statement Import Format Extract', Comment = 'ESM="Formato de importación de estado de cuenta del extracto bancario"';
            //TableRelation = "Bank Export/Import Setup".Code WHERE(Direction = CONST(Import), "ST Conciliation" = const(true));
            // ValidateTableRelation = false;
        }

        field(51033; "G/L Account No."; Code[20])
        {
            Caption = 'Bank Statement Import Format Conciliation', Comment = 'ESM="Formato de importación de estado de cuenta de banco Conciliación"';
            //TableRelation = "Bank Export/Import Setup".Code WHERE(Direction = CONST(Import), "ST Conciliation" = const(true));
            // ValidateTableRelation = false;
            FieldClass = FlowField;
            CalcFormula = Lookup("Bank Account Posting Group"."G/L Bank Account No." WHERE(Code = FIELD("Bank Acc. Posting Group")));
        }
        field(51034; "Balance Extr.Bank Closed"; Decimal)
        {
            Caption = 'Balance Extract The Bank Closed', Comment = 'ESM="Saldo Extracto bancario Cerrados"';
            FieldClass = FlowField;
            CalcFormula = Sum("Extract The Bank"."Statement Amount" WHERE("Bank Account No." = FIELD("No."), Closed = const(true)));
        }
        field(51035; "Balance Extr.Bank Open"; Decimal)
        {
            Caption = 'Balance Extract The Bank Open', Comment = 'ESM="Saldo Extracto bancario Abiertos"';
            FieldClass = FlowField;
            CalcFormula = Sum("Extract The Bank"."Statement Amount" WHERE("Bank Account No." = FIELD("No."), Closed = const(false)));

        }
    }

    procedure GetDataExchDefConciliation(var DataExchDef: Record "Data Exch. Def")
    var
        BankExportImportSetup: Record "Bank Export/Import Setup";
        DataExchDefCodeResponse: Code[20];
        Handled: Boolean;
    begin
        //ULN::PC    002 Begin Conciliación ++++
        if not Handled then begin
            TestField("Import Format Statement");
            DataExchDefCodeResponse := "Import Format Statement";
        end;

        if DataExchDefCodeResponse = '' then
            Error(DataExchNotSetErr);

        BankExportImportSetup.Get(DataExchDefCodeResponse);
        BankExportImportSetup.TestField("Data Exch. Def. Code");

        DataExchDef.Get(BankExportImportSetup."Data Exch. Def. Code");
        DataExchDef.TestField(Type, DataExchDef.Type::"Bank Statement Import");
        //ULN::PC    002 Begin Conciliación ----
    end;

    procedure fnGetExtractAmount(pBankCode: code[20]): Decimal
    var
        lclExtractTheBank: Record "Extract The Bank";
        lcBankAccountStatementLine: Record "Bank Account Statement Line";
        lclAmountExtract: Decimal;
    begin

        lclExtractTheBank.Reset();
        lclExtractTheBank.SetRange("Bank Account No.", pBankCode);
        IF lclExtractTheBank.FindSet() then
            repeat
                lclAmountExtract += lclExtractTheBank."Statement Amount";
            until lclExtractTheBank.Next() = 0;

        lcBankAccountStatementLine.Reset();
        lcBankAccountStatementLine.SetRange("Bank Account No.", pBankCode);
        lcBankAccountStatementLine.SetRange("Import Extract The Bank", true);
        if lcBankAccountStatementLine.FindSet() then
            repeat
                lclAmountExtract += lcBankAccountStatementLine."Statement Amount";
            until lcBankAccountStatementLine.Next() = 0;

        exit(lclAmountExtract);
    end;

    procedure fnGetExtracCount(pBankCode: code[20]): Text
    var
        lclExtractTheBank: Record "Extract The Bank";
        lcBankAccountStatementLine: Record "Bank Account Statement Line";
        lclAmountExtract: Decimal;
        lclTotalLine: Integer;
        lclTotalLineClosed: Integer;
    begin

        lclExtractTheBank.Reset();
        lclExtractTheBank.SetRange("Bank Account No.", pBankCode);
        IF lclExtractTheBank.FindSet() then
            lclTotalLine := lclExtractTheBank.Count;

        lclExtractTheBank.Reset();
        lclExtractTheBank.SetRange("Bank Account No.", pBankCode);
        lclExtractTheBank.SetRange(Closed, true);
        IF lclExtractTheBank.FindSet() then
            lclTotalLineClosed := lclExtractTheBank.Count;

        exit(Format(lclTotalLineClosed) + '/' + Format(lclTotalLine));
    end;

    var
        DataExchNotSetErr: Label 'The Data Exchange Code field must be filled.';
}