table 51043 "Master Data Buffer"
{
    // ULN:PER:BOOKS COPIA DE MT


    Caption = 'Master Data', Comment = 'ESM="Maestro Datos"';
    DataPerCompany = false;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code', Comment = 'ESM="Código"';
        }
        field(2; Description; Text[250])
        {
            Caption = 'Description', Comment = 'ESM="Descripción"';
        }
        field(3; Aplication; Boolean)
        {
            Caption = 'Aplication', Comment = 'ESM="Aplicación"';
        }
        field(4; Type; Code[3])
        {
            Caption = 'Type', Comment = 'ESM="Tipo Documento"';
        }
        field(6; "Codigo Generico"; Text[30])
        {
            Caption = 'Generic Code', Comment = 'ESM="Código Generico"';
            Description = 'ULN';
        }
        field(7; "Codigo Nav"; Code[20])
        {
            Description = 'ULN';
        }
        field(107; "No. Mov."; Integer)
        {
            Description = 'ULN';
        }
        field(8; "Descripcion Generico"; Text[250])
        {
            Description = 'ULN';
        }
        field(9; "Descripcion Nav"; Text[250])
        {
            Description = 'ULN';
        }
        field(11; "Cod. Pais"; Code[20])
        {
            Description = 'ULN';
        }
        field(15; Departamento; Text[30])
        {
            Description = 'ULN';
        }
        field(109; "Document No."; Code[30])
        {
            Caption = 'Document No.', Comment = 'ESM="N° Documento"';
            Description = 'ULN';
        }
        field(207; "No. Ruc EPS"; Text[30])
        {
            Description = 'ULN::RRHH::SEGUROS-PENSION';
        }
        field(229; sequence; Integer)
        {
            Description = 'ULN::RRHH';
        }
        field(50328; "Global Dimension 1 Code"; Code[20])
        {
            Caption = 'Global Dimension 1 Code', Comment = 'ESM="Cód. dimensión global 1"';
        }
        field(50329; "Global Dimension 2 Code"; Code[20])
        {
            Caption = 'Global Dimension 2 Code', Comment = 'ESM="Cód. dimensión global 2"';
        }
        field(50304; "Fecha Envio"; Date)
        {
            Description = 'ULN:07-03-15:PALJ';
        }
        field(102; "Importe Base"; Decimal)
        {
            Description = 'ULN';
        }
        field(103; "Importe Rel"; Decimal)
        {
            Description = 'ULN';
        }
        field(50300; "Gran Familia"; Code[45])
        {
            Description = 'ULN:07-03-15:PALJ';

        }
    }

    keys
    {
        key(Key1; "Code", "No. Mov.")
        {
        }
        key(Key2; sequence)
        {
        }

    }

    fieldgroups
    {
        fieldgroup(DropDown; "Code", Description)
        {
        }
    }

    var



}

