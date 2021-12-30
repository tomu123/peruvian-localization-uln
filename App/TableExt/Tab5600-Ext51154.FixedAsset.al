tableextension 51154 "LD Fixed Asset" extends "Fixed Asset"
{
    fields
    {
        // Add changes to table fields here 51005..51015
        field(51005; "LD Fixed Asset Type"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Fixed Asset Type', Comment = 'ESM="Tipo de AF SUNAT"';
            TableRelation = "Legal Document"."Legal No." where("Option Type" = const("SUNAT Table"), "Type Code" = const('18'));
            ValidateTableRelation = false;
        }
        field(51006; "LD Fixed Asset Status"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Fixes Asset Status', Comment = 'ESM="Estado SUNAT"';
            TableRelation = "Legal Document"."Legal No." where("Option Type" = const("SUNAT Table"), "Type Code" = const('19'));
            ValidateTableRelation = false;
        }
        field(51007; "LD Depreciation Method"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Depreciation Method', Comment = 'ESM="Médoto depreciación SUNAT"';
            TableRelation = "Legal Document"."Legal No." where("Option Type" = const("SUNAT Table"), "Type Code" = const('20'));
            ValidateTableRelation = false;
        }
        field(51008; "LD Brand"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Brand', Comment = 'ESM="Marca"';
            TableRelation = Manufacturer;
        }
        field(51009; "LD Model"; Text[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'Model', Comment = 'Modelo';
        }
        field(51010; "LD Intangible Status"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Intangible Status', Comment = 'ESM="Estado Intangible"';
            trigger OnValidate()
            begin
                if not "LD Intangible Status" then
                    "LD Intagible Type" := '';
            end;
        }
        field(51011; "LD Intagible Type"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Intangible Type', Comment = 'ESM="Estado Intagible SUNAT"';
            TableRelation = "Legal Document"."Legal No." where("Option Type" = const("SUNAT Table"), "Type Code" = const('07'));
            ValidateTableRelation = false;
        }
        field(51012; "LD Job No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Job No.', Comment = 'ESM="N° Proyecto"';
            TableRelation = Job;
            trigger OnValidate()
            var

            begin
                fnUpdateDimensionsFixed();
            end;
        }
        field(51013; "LD Job Task No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Job Task No.', Comment = 'ESM="N° Tarea Proyecto"';
            TableRelation = "Job Task"."Job Task No." where("Job No." = field("LD Job No."));
        }
        field(51014; "Invoice Sales No"; Code[20])
        {
            Description = 'ULN:PC 18.01.21 Activos Fijos|Amortizaciòn';
            DataClassification = ToBeClassified;
            Caption = 'Invoice Sales No', Comment = 'ESM="Nº Factura de venta"';
        }
        field(51016; "Tag Number"; Text[10])
        {
            DataClassification = ToBeClassified;
            Description = 'ULN:PC 18.01.21 Activos Fijos|Amortizaciòn';
            Caption = 'Tag Number', Comment = 'ESM="Número de Etiqueta"';
        }
        field(51017; "Country/Region Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'ULN:PC 18.01.21 Activos Fijos|Amortizaciòn';
            Caption = 'Country/Region Code', Comment = 'ESM="Código de país / región"';
            TableRelation = "Country/Region";

        }

        field(51018; "Departament Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ULN:PC 18.01.21 Activos Fijos|Amortizaciòn';
            Caption = 'Departament', Comment = 'ESM="departamento"';
            TableRelation = Ubigeo."Departament Code";
            ValidateTableRelation = false;
            trigger OnLookup()
            var
                lclRecUbigeo: Record Ubigeo;
                UbigeoList: Page "Ubigeo List";
            begin
                Clear(lclRecUbigeo);
                lclRecUbigeo.SetRange("Province Code", '00');
                lclRecUbigeo.SetRange("District Code", '00');
                UbigeoList.SETTABLEVIEW(lclRecUbigeo);
                UbigeoList.SetShowDepartament();
                UbigeoList.LOOKUPMODE(TRUE);

                IF UbigeoList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                    UbigeoList.GETRECORD(lclRecUbigeo);

                    "Departament Code" := lclRecUbigeo."Departament Code";
                    "Ubigeo Description" := lclRecUbigeo.Description;

                    if Rec."Departament Code" <> xRec."Departament Code" then begin
                        Rec."Province Code" := '';
                        Rec."District Code" := '';
                    end
                end;

            end;

            trigger OnValidate()
            begin
                if "Departament Code" = '' then begin
                    "Ubigeo Description" := '';
                    Rec."Province Code" := '';
                    Rec."District Code" := '';
                end;

            end;
        }
        field(51019; "Province Code"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'ULN:PC 18.01.21 Activos Fijos|Amortizaciòn';
            Caption = 'Province', Comment = 'ESM="Provincia"';

            trigger OnLookup()
            var
                lclRecUbigeo: Record Ubigeo;
                UbigeoList: Page "Ubigeo List";
            begin
                Clear(lclRecUbigeo);
                lclRecUbigeo.SetRange("Departament Code", "Departament Code");
                lclRecUbigeo.SetFilter("Province Code", '<>%1', '00');
                lclRecUbigeo.SetRange("District Code", '00');
                UbigeoList.SetShowProvince();
                UbigeoList.SETTABLEVIEW(lclRecUbigeo);

                UbigeoList.LOOKUPMODE(TRUE);

                IF UbigeoList.RUNMODAL = ACTION::LookupOK THEN BEGIN

                    UbigeoList.GETRECORD(lclRecUbigeo);

                    "Province Code" := lclRecUbigeo."Province Code";
                    "Ubigeo Description" := lclRecUbigeo.Description;

                    if Rec."Province Code" <> xRec."Province Code" then begin
                        Rec."District Code" := '';

                    end
                END;
            end;


        }
        field(51020; "District Code"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'ULN:PC 18.01.21 Activos Fijos|Amortizaciòn';
            Caption = 'District', Comment = 'ESM="Distrito"';
            TableRelation = IF ("Province Code" = CONST('')) Ubigeo."District Code" ELSE
            Ubigeo."District Code" where("Province Code" = field("Province Code"), "Departament Code" = field("Departament Code"));
            ValidateTableRelation = false;
            trigger OnValidate()
            var
                lclRecUbigeo: Record Ubigeo;
            begin
                lclRecUbigeo.Reset();
                lclRecUbigeo.SetRange("Departament Code", "Departament Code");
                lclRecUbigeo.SetRange("Province Code", "Province Code");
                lclRecUbigeo.SetRange("District Code", "District Code");
                if lclRecUbigeo.FindSet() then
                    "Ubigeo Description" := lclRecUbigeo.Description;
            end;
        }
        field(51021; "Location"; Text[100])
        {
            DataClassification = ToBeClassified;
            Description = 'ULN:PC 18.01.21 Activos Fijos|Amortizaciòn';
            Caption = 'Location', Comment = 'ESM="Ubicación"';

        }
        field(51022; "Floor"; Text[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ULN:PC 18.01.21 Activos Fijos|Amortizaciòn';
            Caption = 'Floor', Comment = 'ESM="Piso"';

        }
        field(51023; "Area"; Text[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ULN:PC 18.01.21 Activos Fijos|Amortizaciòn';
            Caption = 'Area', Comment = 'ESM="Área"';

        }
        field(51024; "Color"; Text[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ULN:PC 18.01.21 Activos Fijos|Amortizaciòn';
            Caption = 'Color', Comment = 'ESM="Color"';

        }
        field(51025; "Status AF"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","Good","Bad","Regular";
            OptionCaption = ' ,Good,Bad,Regular', Comment = 'ESM=" ,Bueno,Malo,Regular"';
            Description = 'ULN:PC 18.01.21 Activos Fijos|Amortizaciòn';
            Caption = 'Status AF', Comment = 'ESM="Estado"';

        }
        field(51026; "Length"; Text[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ULN:PC 18.01.21 Activos Fijos|Amortizaciòn';
            Caption = 'Length', Comment = 'ESM="Largo"';

        }
        field(51027; "Width"; Text[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ULN:PC 18.01.21 Activos Fijos|Amortizaciòn';
            Caption = 'Width', Comment = 'ESM="Ancho"';

        }
        field(51028; "High"; Text[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ULN:PC 18.01.21 Activos Fijos|Amortizaciòn';
            Caption = 'High', Comment = 'ESM="Alto"';

        }
        field(51029; "Motor"; Text[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ULN:PC 18.01.21 Activos Fijos|Amortizaciòn';
            Caption = 'Motor', Comment = 'ESM="Motor"';

        }
        field(51030; "Power"; Text[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ULN:PC 18.01.21 Activos Fijos|Amortizaciòn';
            Caption = 'Power', Comment = 'ESM="Potencia"';

        }
        field(51031; "Plate"; Text[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ULN:PC 18.01.21 Activos Fijos|Amortizaciòn';
            Caption = 'Plate', Comment = 'ESM="Placa"';

        }
        field(51032; "Fabrication date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'ULN:PC 18.01.21 Activos Fijos|Amortizaciòn';
            Caption = 'Fabrication date', Comment = 'ESM="Fecha Fabricación"';

        }
        field(51033; "Father Code"; Text[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ULN:PC 18.01.21 Activos Fijos|Amortizaciòn';
            Caption = 'Father Code', Comment = 'ESM="Cód. padre"';

        }
        field(51034; "Ubigeo Description"; Text[100])
        {
            DataClassification = ToBeClassified;
            Description = 'ULN:PC 18.01.21 Activos Fijos|Amortizaciòn';
            Caption = 'Ubigeo Description', Comment = 'ESM="Ubigeo Descripción"';

        }
        field(51035; "ST AF Leasing"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'AF Leasing', Comment = 'ESM="Leasing"';

        }
        field(51036; "ST Contract No."; Text[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract No.', Comment = 'ESM="Nº Contrato"';

        }
        field(51037; "ST Contract Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract Date', Comment = 'ESM="Fecha Contrato"';

        }
        field(51038; "ST Lease Start Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Lease Start Date', Comment = 'ESM="Fecha Inicio Arrendamiento"';

        }
        field(51039; "ST Number of Quotas"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Number of Quotas', Comment = 'ESM="Número Cuotas"';

        }
        field(51040; "ST Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Amount', Comment = 'ESM="Importe"';

        }
        field(51041; "Acquisition date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Acquisition date', Comment = 'ESM="Fecha de adquisición"';

        }
        field(51042; "Current Asset"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Current Asset', Comment = 'ESM="Activo en curso"';

        }
        modify("FA Class Code")
        {
            trigger OnAfterValidate()
            var
                FAClass: Record "FA Class";
            begin
                if "FA Class Code" = '' then
                    Validate("LD Intangible Status", false);
                FAClass.Get("FA Class Code");
                Validate("LD Intangible Status", FAClass."LD Intangible Status");
                Validate("ST AF Leasing", FAClass.Leasing);
            end;
        }
        modify("FA Subclass Code")
        {
            trigger OnAfterValidate()
            var
                FASubClass: Record "FA Subclass";
                FADepreciationBook: Record "FA Depreciation Book";
            begin
                //'ULN:PC 18.01.21 Activos Fijos|Amortizaciòn 
                fnValidateBookValue;
                //'ULN:PC 18.01.21 Activos Fijos|Amortizaciòn 
                if "FA Subclass Code" = '' then
                    exit;
                FASubClass.Get("FA Subclass Code");
                FASubClass.TestField("Default FA Posting Group");
                FADepreciationBook.SetAutoCalcFields("Book Value");
                FADepreciationBook.SetRange("FA No.", "No.");
                FADepreciationBook.SetFilter("Book Value", '%1', 0);
                FADepreciationBook.ModifyAll("FA Posting Group", FASubClass."Default FA Posting Group");
            end;
        }
        modify("Responsible Employee")
        {
            trigger OnAfterValidate()
            var
            begin
                fnUpdateDimensionsFixed();
            end;
        }
    }
    procedure fnValidateBookValue()
    var
        lclText001: Label 'Grupo Registro A/F ya cuenta con valor neto,no puede ser modificado', Comment = 'Grupo Registro A/F ya cuenta con valor neto,no puede ser modificado', MaxLength = 999, Locked = true;
        lcRecFADepreciationBook: Record "FA Depreciation Book";
    begin


        lcRecFADepreciationBook.Reset();
        lcRecFADepreciationBook.SetRange("FA No.", Rec."No.");
        if lcRecFADepreciationBook.FindSet() then
            repeat
                lcRecFADepreciationBook.CalcFields("Book Value");
                if xRec."FA Subclass Code" <> Rec."FA Subclass Code" then
                    if lcRecFADepreciationBook."Book Value" <> 0 then
                        Error(lclText001);
            until lcRecFADepreciationBook.Next = 0;


    end;

    procedure fnUpdateDimensionsFixed()
    var
        lclJob: Record Job;
        lcEmployee: Record Employee;
        lcDefaultDimension: Record "Default Dimension";
        lcDefaultDimension2: Record "Default Dimension";
    begin
        lcDefaultDimension2.Reset();

        //Clear Dimensiones
        lcDefaultDimension.Reset();
        lcDefaultDimension.SetRange("Table ID", 5600);
        lcDefaultDimension.SetRange("No.", "No.");
        if lcDefaultDimension.FindSet() then
            repeat
                lcDefaultDimension.Delete();
            until lcDefaultDimension.Next() = 0;



        if "LD Job No." <> '' then begin

            lclJob.Reset();
            lclJob.SetRange("No.", "LD Job No.");
            if lclJob.FindSet() then begin
                lcDefaultDimension.Reset();
                lcDefaultDimension.SetRange("Table ID", 167);
                lcDefaultDimension.SetRange("No.", lclJob."No.");
                if lcDefaultDimension.FindSet() then begin
                    repeat
                        lcDefaultDimension2.Init();
                        lcDefaultDimension2."Table ID" := 5600;
                        lcDefaultDimension2."No." := "No.";
                        lcDefaultDimension2."Dimension Code" := lcDefaultDimension."Dimension Code";
                        lcDefaultDimension2."Dimension Value Code" := lcDefaultDimension."Dimension Value Code";
                        lcDefaultDimension2.Insert();

                    until lcDefaultDimension.Next() = 0;
                end;
            end;

        end;


        if ("Responsible Employee" <> '') and ("LD Job No." = '') then begin

            lcEmployee.Reset();
            lcEmployee.SetRange("No.", "Responsible Employee");
            if lcEmployee.FindSet() then begin
                lcDefaultDimension.Reset();
                lcDefaultDimension.SetRange("Table ID", 5200);
                lcDefaultDimension.SetRange("No.", lcEmployee."No.");
                if lcDefaultDimension.FindSet() then begin
                    repeat
                        lcDefaultDimension2.Init();
                        lcDefaultDimension2."Table ID" := 5600;
                        lcDefaultDimension2."No." := "No.";
                        lcDefaultDimension2."Dimension Code" := lcDefaultDimension."Dimension Code";
                        lcDefaultDimension2."Dimension Value Code" := lcDefaultDimension."Dimension Value Code";
                        lcDefaultDimension2.Insert();

                    until lcDefaultDimension.Next() = 0;
                end;
            end;

        end;
    end;

    var
        PostCode: Record "Post Code";
}