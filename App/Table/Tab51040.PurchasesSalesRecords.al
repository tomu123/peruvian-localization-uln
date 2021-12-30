table 51040 "Purchases / Sales Records"
{
    // version NAVNA11.00,ULNLPE.v1

    // Identify Nro. yyyy.mm.dd Version  Description
    // -----------------------------------------------------------------------------------------------------
    // ULN::CRM 001  2018.01.08  v.001  "Table LPE"

    Caption = 'Purchases / Sales Records', Comment = 'ESM="Registro de Ventas y Compras"';

    fields
    {
        field(1; Campos1; Text[50])
        {
            Caption = 'Fecha', Comment = 'ESM="Fecha"';
        }
        field(2; Campos2; Text[50])
        {
            Caption = 'Nro Transaccion', Comment = 'ESM="Nro Transaccion"';
        }
        field(3; Campos3; Text[50])
        {
            Caption = 'Nro Correlativo', Comment = 'ESM="Nro Correlativo"';
        }
        field(4; Campos4; Text[50])
        {
            Caption = 'Document Date', Comment = 'ESM="Document Date"';
        }
        field(5; Campos5; Text[50])
        {
            Caption = 'Due Date', Comment = 'ESM="Due Date"';
        }
        field(6; Campos6; Text[50])
        {
            Caption = 'Sunat Document', Comment = 'ESM="Sunat Document"';
        }
        field(7; Campos7; Text[50])
        {
            Caption = 'Serie', Comment = 'ESM="Serie"';
        }
        field(8; Campos8; Text[50])
        {
            Caption = 'Document Date', Comment = 'ESM="Document Date"';
        }
        field(9; Campos9; Text[50])
        {
        }
        field(10; Campos10; Text[50])
        {
        }
        field(11; Campos11; Text[50])
        {
        }
        field(12; Campos12; Text[50])
        {
        }
        field(13; Campos13; Text[50])
        {
        }
        field(14; Campos14; Text[50])
        {
        }
        field(15; Campos15; Text[50])
        {
        }
        field(16; Campos16; Text[50])
        {
        }
        field(17; Campos17; Text[50])
        {
        }
        field(18; Campos18; Text[50])
        {
        }
        field(19; Campos19; Text[50])
        {
        }
        field(20; Campos20; Text[50])
        {
        }
        field(21; Campos21; Text[50])
        {
        }
        field(22; Campos22; Text[50])
        {
        }
        field(23; Campos23; Text[50])
        {
        }
        field(24; Campos24; Text[50])
        {
        }
        field(25; Campos25; Text[50])
        {
        }
        field(26; Campos26; Text[50])
        {
        }
        field(27; Campos27; Text[50])
        {
        }
        field(28; Campos28; Text[50])
        {
        }
        field(29; Campos29; Text[50])
        {
        }
        field(30; Campos30; Text[50])
        {
        }
        field(31; Campos31; Text[50])
        {
        }
        field(32; Campos32; Text[50])
        {
        }
        field(33; Campos33; Text[50])
        {
        }
        field(34; Campos34; Text[50])
        {
        }
        field(35; Purchases; Boolean)
        {
            Caption = 'Purchases';
        }
        field(36; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(37; "Posting Date"; Date)
        {
            Caption = 'Posting date';
        }
        field(38; Usuario; Code[50])
        {
            Caption = 'User';
        }
        field(39; Campos35; Text[50])
        {
        }
        field(40; Campos36; Text[50])
        {
        }
        field(41; Campo37; Boolean)
        {
        }
        field(42; Campos38; Code[25])
        {
        }
        field(43; Campos39; Code[25])
        {
        }
        field(44; "Consumo Produccion"; Code[90])
        {
        }
        field(45; Enero; Decimal)
        {
        }
        field(46; Febrero; Decimal)
        {
        }
        field(47; Marzo; Decimal)
        {
        }
        field(48; Abril; Decimal)
        {
        }
        field(49; Mayo; Decimal)
        {
        }
        field(50; Junio; Decimal)
        {
        }
        field(51; Julio; Decimal)
        {
        }
        field(52; Agosto; Decimal)
        {
        }
        field(53; Septiembre; Decimal)
        {
        }
        field(54; Octubre; Decimal)
        {
        }
        field(55; Noviembre; Decimal)
        {
        }
        field(56; Deciembre; Decimal)
        {
        }
        field(57; Total; Decimal)
        {
        }
        field(58; Periodo; Integer)
        {
        }
        field(59; Campo38; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Entry No.", Purchases, Usuario)
        {
        }
        key(Key2; Periodo, "Consumo Produccion")
        {
            SumIndexFields = Enero, Febrero, Marzo, Abril, Mayo, Junio, Julio, Agosto, Septiembre, Noviembre, Deciembre;
        }
    }

    fieldgroups
    {
    }
}

