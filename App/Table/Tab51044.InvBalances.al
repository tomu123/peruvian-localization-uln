table 51044 "Inv. Balances"
{
    // version NAVNA11.00,ULNLPE.v1

    // Identify Nro. yyyy.mm.dd Version  Description
    // -----------------------------------------------------------------------------------------------------
    // ULN::CRM 001  2018.01.08  v.001  "Table LPE"


    fields
    {
        field(1; "Period Number"; Text[30])
        {
            Caption = 'Period Name', Comment = 'ESM="Nombre Periodo"';
            //TableRelation = "Period Balances";
            // ValidateTableRelation = false;
        }
        field(2; "Sunat Doc. Type"; Code[10])
        {
            Caption = 'Sunat Doc. Type', Comment = 'ESM="Tipo"';
            TableRelation = "Legal Document"."Legal No." where("Option Type" = const("SUNAT Table"), "Type Code" = const('02'));
        }
        field(3; "Sunat Doc. No."; Code[100])
        {
            Caption = 'Sunat Doc. No.', Comment = 'ESM="Número"';
            TableRelation = Vendor."No.";

            trigger OnValidate()
            begin
                lcl_RecVendor.SETRANGE(lcl_RecVendor."No.", "Sunat Doc. No.");
                IF lcl_RecVendor.FINDFIRST THEN BEGIN
                    Name := lcl_RecVendor.Name;
                    "Sunat Doc. Type" := lcl_RecVendor."VAT Registration Type";
                END ELSE BEGIN
                    Name := '';
                    "Sunat Doc. Type" := '';
                END;
            end;
        }
        field(4; Denomination; Text[100])
        {
            Caption = 'Denomination', Comment = 'ESM="Denominación"';
        }
        field(5; "Unit Value"; Decimal)
        {
            Caption = 'Unit Value', Comment = 'ESM="Valor Nominal Unitario"';
        }
        field(6; Quantity; Decimal)
        {
            Caption = 'Quantity', Comment = 'ESM="Cantidad"';
        }
        field(7; "Total Cost"; Decimal)
        {
            Caption = 'Total Cost', Comment = 'ESM="Costo Total"';
        }
        field(8; "Total Provision"; Decimal)
        {
            Caption = 'Total Provision', Comment = 'ESM="Provisión Total"';
        }
        field(9; "Net Total"; Decimal)
        {
            Caption = 'Net Total', Comment = 'ESM="Total Neto"';
        }
        field(10; Name; Text[100])
        {
            Caption = 'Name', Comment = 'ESM="Apellidos y Nombres Denominación o Razón Social del Emisor"';
        }
        field(11; "Period Name"; Text[100])
        {
        }
        field(12; "Imp Capital Social"; Decimal)
        {
        }
        field(13; "Valor Nominal Por Accion"; Decimal)
        {
        }
        field(20; "Share Type"; Option)
        {
            BlankZero = true;
            Caption = 'Share Type', Comment = 'ESM="Pagadas/Suscritas"';
            OptionCaption = ',Suscritas,Pagadas';
            OptionMembers = " ",Suscritas,Pagadas;
        }
        field(21; "Share Number"; Decimal)
        {
            Caption = 'Share Number', Comment = 'ESM="Número de Acciones o Participaciones Sociales"';
        }
        field(22; "Share Percentage"; Decimal)
        {
            Caption = 'Share Percentage', Comment = 'ESM="Porcentaje Total de Participacion"';
        }
        field(23; "Shared Number 2"; Decimal)
        {
            Caption = 'Nro de Acc o Part Sociales Pagadas', Comment = 'ESM="Nro de Acc o Part Sociales Pagadas"';
        }
        field(24; "Shared Number 3"; Decimal)
        {
            Caption = 'Nro de Acc o Part Sociales Suscritas', Comment = 'ESM="Nro de Acc o Part Sociales Suscritas"';
        }
        field(50; "Acc. No Type"; Option)
        {
            OptionCaption = ',31,50,5';
            OptionMembers = ,"31","50","5";
        }
        field(51; "G/L Entry No."; Integer)
        {
            Caption = 'G/L Entry No.', Comment = 'ESM="N° Mov Contabilidad"';
            TableRelation = "G/L Entry"."Entry No." WHERE("G/L Account No." = FILTER('30*|31*'));
        }
        field(52; "G/L Entry Date"; Date)
        {
            CalcFormula = Lookup("G/L Entry"."Posting Date" WHERE("Entry No." = FIELD("G/L Entry No.")));
            FieldClass = FlowField;
        }
        field(53; "Sunat Share Type"; Option)
        {
            OptionCaption = '501,502';
            OptionMembers = "501","502";
        }
        field(54; "ID Balance"; Integer)
        {
            AutoIncrement = true;
        }
        field(55; Capital; Decimal)
        {
            Caption = 'Capital', Comment = 'ESM="Capital"';
        }
        field(56; "Acciones de Inversion"; Decimal)
        {
        }
        field(57; "Resultado No Realizados"; Decimal)
        {
        }
        field(58; "Reservas Legales"; Decimal)
        {
        }
        field(59; "Capital Adicional"; Decimal)
        {
        }
        field(60; "Otras Reservas"; Decimal)
        {
        }
        field(61; "Resultados Acomulados"; Decimal)
        {
        }
        field(62; "Resultado Neto Del Ejercicio"; Decimal)
        {
        }
        field(63; "Excedente de revaluacion"; Decimal)
        {
        }
        field(64; "Resultado del Ejercicio"; Decimal)
        {
        }
        field(65; "Nro Fila"; Code[10])
        {
        }
        field(66; Descripcion; Code[45])
        {
        }
        field(67; "Tipo de Acciones"; Code[20])
        {
            TableRelation = "Legal Document"."Legal No." where("Option Type" = const("SUNAT Table"), "Type Code" = const('16'));


            trigger OnValidate()
            var
                LegalDocument: Record "Legal Document";
            begin
                LegalDocument.RESET;
                LegalDocument.SETRANGE("Option Type", LegalDocument."Option Type"::"SUNAT Table");
                LegalDocument.SETRANGE("Type Code", '16');
                LegalDocument.SETRANGE("Legal No.", "Tipo de Acciones");
                IF LegalDocument.FINDSET THEN BEGIN
                    "Tipo de Acciones Descripcion" := LegalDocument.Description;
                END;
            end;
        }
        field(68; "Tipo de Acciones Fisico"; Option)
        {
            OptionCaption = ' ,COMUNES,NOMINAL,PREFERENTE,CONVERTIBLES,OTROS';
            OptionMembers = " ",COMUNES,NOMINAL,PREFERENTE,CONVERTIBLES,OTROS;
        }
        field(69; "Tipo de Acciones Descripcion"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Period Number", "Sunat Doc. Type", "Sunat Doc. No.", "Acc. No Type")
        {
        }
    }

    fieldgroups
    {
    }

    var
        lcl_RecVendor: Record "vendor";
}

