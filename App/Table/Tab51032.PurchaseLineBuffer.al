table 59010 "PR Purch. Line Buffer"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document Type"; Enum "Purchase Document Type")
        {
            Caption = 'Document Type', Comment = 'ESM="Tipo Documento"';
        }
        field(2; "Buy-from Vendor No."; Code[20])
        {
            Caption = 'Buy-from Vendor No.', Comment = 'ESM="Compra a Proveedor N°"';
            Editable = false;
            TableRelation = Vendor;
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.', Comment = 'ESM="N° Documento"';
            TableRelation = "Purchase Header"."No." WHERE("Document Type" = FIELD("Document Type"));
        }
        field(4; "Line No."; Integer)
        {
            Caption = 'Line No.', Comment = 'ESM="N° Linea"';
        }
        field(5; Type; Enum "Purchase Line Type")
        {
            Caption = 'Type', Comment = 'ESM="Tipo"';
        }
        field(6; "No."; Code[20])
        {
            Caption = 'No.', Comment = 'ESM="N°"';
        }
        field(7; "Location Code"; Code[10])
        {
            Caption = 'Location Code', Comment = 'ESM="Cód. Almacén"';
        }
        field(11; Description; Text[100])
        {
            Caption = 'Description', Comment = 'ESM="Descripción"';
        }
        field(13; "Unit of Measure"; Text[50])
        {
            Caption = 'Unit of Measure', Comment = 'ESM="Unidad de medida"';
        }
        field(15; Quantity; Decimal)
        {
            Caption = 'Quantity', Comment = 'ESM="Cantidad"';
            DecimalPlaces = 0 : 5;
        }
        field(17; "Qty. to Invoice"; Decimal)
        {
            Caption = 'Qty. to Invoice', Comment = 'ESM="Cantida a facturar"';
            DecimalPlaces = 0 : 5;
        }
        field(29; Amount; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount', Comment = 'ESM="Importe"';
            Editable = false;
        }
        field(31; "Unit Price (LCY)"; Decimal)
        {
            Caption = 'Unit Price (LCY)', Comment = 'ESM="Precio Unitario DL"';
        }
        field(23; "Unit Cost (LCY)"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Cost (LCY)', Comment = 'ESM="Costo unitario DL"';
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID', Comment = 'ESM="Id. grupo dimensión"';
            Editable = false;
        }
        field(5795; "Order Date"; Date)
        {
            Caption = 'Order Date', Comment = 'ESM="Fecha pedido"';
            Editable = false;
        }
        field(51061; DimPPTO; Code[20])
        {
            CaptionClass = '1,2,3';
        }
        field(51070; DimCECO; Code[20])
        {
            CaptionClass = '1,2,2';
        }
        field(51062; EntryNo; Integer)
        {
            Caption = 'Entry No.', Comment = 'ESM="N° Mov."';
        }
        field(51063; Amount1; Decimal)
        {
            Caption = 'Budget Amount', Comment = 'ESM="Importe Presupuesto"';
        }
        field(51064; Amount2; Decimal)
        {
            Caption = 'PO';
        }
        field(51065; NamePPTO; Code[20])
        {
            Caption = 'Name Ppto', Comment = 'ESM="Nombre PPTO"';
        }
        field(51066; Status; Code[20])
        {
            Caption = 'Status', Comment = 'ESM="Estado"';
        }
        field(51067; "Dimension Name"; Code[200])
        {
            Caption = 'Dimensión Ppto.';
        }
        field(51068; "Net Budget Balance"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Net budget balance', Comment = 'ESM="Saldo presupuesto"';
        }
        field(51069; "Status within Budget"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Status within budget', Comment = 'ESM="Excede presupuesto"';
        }
    }
    keys
    {
        key(PK; EntryNo)
        {
            Clustered = true;
        }
    }

    var
        DimMgt: Codeunit DimensionManagement;
        AmtLabelTxt: Label 'Amount', Comment = 'ESM="Importe"';
        tb39: Record 39;

    procedure ShowShortcutDimCode(var ShortcutDimCode: array[8] of Code[20])
    begin
        DimMgt.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin

        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");

    end;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}