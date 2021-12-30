tableextension 51082 "ST Vendor" extends Vendor
{
    fields
    {
        // Add changes to table fields here 51023..51024,51030..51035
        modify("Preferred Bank Account Code")
        {
            Caption = 'Preferred Bank Acc. Code', Comment = 'ESM="Banco destino MN"';
        }
        field(51023; "Preferred Bank Account Code ME"; code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Preferred Bank Acc. Code ME', Comment = 'ESM="Banco destino  ME"';
            TableRelation = "Vendor Bank Account".Code where("Vendor No." = field("No."));
        }
        field(51024; "Vendor Posting Group ME"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Vendor Posting Group ME', Comment = 'ESM="Grupo regitro proveedor ME"';
            TableRelation = "Vendor Posting Group";
        }
        field(51030; "Status approved"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Status approved', Comment = 'ESM="Estado aprobado"';
        }

        //Consult RUC Begin 
        field(51005; "SUNAT Status"; Text[30])
        {
            Caption = 'SUNAT Status', Comment = 'ESM="Estado SUNAT"';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(51006; "SUNAT Condition"; Text[30])
        {
            Caption = 'SUNAT Condition', Comment = 'ESM="Condición SUNAT"';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(51007; "Ubigeo"; Text[30])
        {
            Caption = 'Ubigeo';
            DataClassification = ToBeClassified;
            Editable = false;
            trigger OnValidate()
            begin
                if StrLen(Ubigeo) >= 2 then
                    "Post Code" := CopyStr(Ubigeo, 1, 2);
                if StrLen(Ubigeo) >= 4 then
                    City := CopyStr(Ubigeo, 3, 2);
                if StrLen(Ubigeo) >= 6 then
                    County := CopyStr(Ubigeo, 5, 2);
            end;
        }
        //Consult RUC End

        //Detracc
        field(51004; "Currenct Account BNAC"; Text[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'Current Acc. National Bank', Comment = 'ESM="Cód. Cuenta Banco de la Nación"';
        }

        //Legal Document
        field(51000; "VAT Registration Type"; Code[2])
        {
            DataClassification = ToBeClassified;
            Caption = 'VAT Registration Type', Comment = 'ESM="Tipo Doc. Identidad"';
            TableRelation = "Legal Document"."Legal No." where("Option Type" = const("SUNAT Table"), "Type Code" = const('02'));
            ValidateTableRelation = false;
        }
        //Retentions Begin
        field(51008; "Retention Agent"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Retention Agent', Comment = 'ESM="Agente Retención"';
            trigger OnValidate()
            begin
                if not "Retention Agent" then begin
                    "Retention Agent Start Date" := 0D;
                    "Retention Agent End Date" := 0D;
                    "Retention Agent Resolution" := '';
                end;
            end;
        }
        field(51009; "Retention Agent Start Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Retention Agent Start Date', Comment = 'ESM="Fec. Inicio Agente Retención"';
        }
        field(51010; "Retention Agent End Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Retention Agent End Date', Comment = 'ESM="Fec. Fin Agente Retención"';
        }
        field(51011; "Retention Agent Resolution"; Text[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Retention Agent Resolution', Comment = 'ESM="Resolución Agente Retención"';
        }
        field(51012; "Perception Agent"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Perception Agent', Comment = 'ESM="Agente Percepción"';
            trigger OnValidate()
            begin
                if not "Perception Agent" then begin
                    "Perception Agent Start Date" := 0D;
                    "Perception Agent End Date" := 0D;
                    "Perception Agent Resolution" := '';
                end;
            end;
        }

        field(51013; "Perception Agent Start Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Perception agent start date', Comment = 'ESM="Fec. Inicio Agente Percepción"';
        }
        field(51014; "Perception Agent End Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Perception agent end date', Comment = 'ESM="Fec. Fin Agente Percepción"';
        }
        field(51015; "Perception Agent Resolution"; Text[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Perception agent resolution', Comment = 'ESM="Resolución Agente Percepción"';
        }
        field(51016; "Good Contributor"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Good Contributor', Comment = 'ESM="Buen Contribuyente"';
            trigger OnValidate()
            begin
                if not "Good Contributor" then begin
                    "Good Contributor Start Date" := 0D;
                    "Good Contributor End Date" := 0D;
                    "Good Contributor Resolution" := '';
                end;
            end;
        }
        field(51017; "Good Contributor Start Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Good Contributor Start Date', Comment = 'ESM="Fec. Inicio Buen Contribuyente"';
        }
        field(51018; "Good Contributor End Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Good Contributor End Date', Comment = 'ESM="Fec. Fin Buen Contribuyente"';
        }
        field(51019; "Good Contributor Resolution"; Text[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Good Contributor Resolution', Comment = 'ESM="Resolución Buen Contribuyente"';
        }
        field(51020; "Business Name"; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Business Name', Comment = 'ESM="Razón Social"';
        }
        field(51130; "withholding File Date"; DateTime)
        {
            DataClassification = ToBeClassified;
            Caption = 'withholding File Date', Comment = 'ESM="Fecha archivo retención"';
        }
        field(51131; "Date of last withholding load"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Date of last withholding load', Comment = 'ESM="Fecha ult. Act. SUNAT"';
        }
        field(51132; "Perception File Date"; DateTime)
        {
            DataClassification = ToBeClassified;
            Caption = 'Perception File Date', Comment = 'ESM="Fecha archivo percepción"';
        }
        field(51133; "Date of last Perception load"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Date of last Perception load', Comment = 'ESM="Fecha ult. carga de percepción"';
        }
        field(51134; "Good contrib. File Date"; DateTime)
        {
            DataClassification = ToBeClassified;
            Caption = 'Good contrib. File Date', Comment = 'ESM="Fecha archivo buen contrib."';
        }
        field(51135; "Date last good contrib. load"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Date of last good contrib. load', Comment = 'ESM="Fecha ult. carga de buen contrib."';
        }
        //Retentions End

        //Ubigeo
        modify(County)
        {
            TableRelation = Ubigeo."District Code" where("Province Code" = field(City), "Departament Code" = field("Post Code"));
        }

        //Import
        field(51021; "Double Taxation Agreements"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Double Taxation Agreements', Comment = 'ESM="Convenios Doble Tributación"';
            TableRelation = "Legal Document"."Legal No." WHERE("Option Type" = filter("SUNAT Table"), "Type Code" = filter('25'));
        }
        field(51022; "Economic Linkages Type"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Economic Linkages Type', Comment = 'ESM="Tipo Vinculación Económica"';
            TableRelation = "Legal Document"."Legal No." WHERE("Option Type" = filter("SUNAT Table"), "Type Code" = filter('27'));
        }

        //PR REquest Puechase
        field(51025; "PR Generic Purchase"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Generic Purchase', Comment = 'ESM="Compra genérica"';
        }

        field(57900; Department; Text[100])
        {
            Caption = 'Dummy Field', comment = 'ESM="Campo Región de Chile no se usa para peru"';
            DataClassification = ToBeClassified;
        }

    }
    var
        ErrorVatRegistrationNo: label 'The length of the document does not meet the required length and format.', Comment = 'ESM="El numero de documento no cumple con el formato requerido."';

    local procedure ValidateVATRegistration()
    begin
        if "VAT Registration No." <> '' then
            if (("VAT Registration Type" <> '') and ("VAT Registration Type" = '1') and (StrLen("VAT Registration No.") <> 8)) or
                (("VAT Registration Type" <> '') and ("VAT Registration Type" = '6') and (StrLen("VAT Registration No.") <> 12)) then
                Error(ErrorVatRegistrationNo);
    end;
}