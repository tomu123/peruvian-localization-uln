table 51038 "Sales Cost Records"
{
    // version ULNPERUW1::JOBS
    Description = 'ULN::PC 001';
    Caption = 'Sales Cost Records', Comment = 'ESM="Registros Costo Venta"';
    //DrillDownPageID = 50029;

    fields
    {
        field(1; "Entry No."; Integer)
        {
        }
        field(2; "Job No."; Code[20])
        {
            Caption = 'Job No.', Comment = 'ESM="No. Proyecto"';
        }
        field(3; "Job Task No."; Code[20])
        {
            Caption = 'Job Task No.', Comment = 'ESM="No. Tarea Proyecto"';
        }
        field(4; "Pla Line No. Draft"; Integer)
        {
            Caption = 'Entry No.', Comment = 'ESM="No. Linea Pla. Proyecto"';
        }
        field(5; "Processed Sales Cost"; Decimal)
        {
            Caption = 'Processed Sales Cost', Comment = 'ESM="Costo Venta Procesado"';
        }
        field(6; "Nro. Processed Sales"; Decimal)
        {
            Caption = 'Nro Processed Sales', Comment = 'ESM="Nro. Venta Procesado"';
        }
        field(7; "Process Date"; Date)
        {
            Caption = 'Process Date', Comment = 'ESM="Fecha Proceso"';
        }
        field(8; Percentage; Decimal)
        {
            Caption = 'Percentage', Comment = 'ESM="Porcentaje"';
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
        fieldgroup(DropDown; "Process Date", "Pla Line No. Draft", "Processed Sales Cost", Percentage, "Nro. Processed Sales")
        {
        }
    }
}

