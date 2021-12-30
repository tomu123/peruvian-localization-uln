tableextension 51198 "ST Job Ledger Entry" extends "Job Ledger Entry"
{
    fields
    {
        // Add changes to table fields here 51000..51010
        field(51000; "ST Sale Cost to process"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Sales Cost to process', Comment = 'ESM="Costo de venta para procesar"';
            Editable = false;
        }
        field(51001; "ST Sale Cost processed"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Sale Cost processed', Comment = 'ESM="Costo de venta procesado"';
            Editable = false;
        }
        field(51002; "ST Percentage Costed"; Decimal)
        {
            Caption = 'Percentage Costed', Comment = 'Porcentaje Costeado';
            Editable = false;
            FieldClass = FlowField;
            //CalcFormula = sum("SL Cost sale Entry".Percentage where("Job No." = field("Job No."), "Job Task No." = field("Job Task No."), "Job Planning Lines No." = field("Entry No.")));
            CalcFormula = Sum("Sales Cost Records".Percentage WHERE("Job No." = FIELD("Job No."), "Job Task No." = FIELD("Job Task No."), "Pla Line No. Draft" = field("Entry No.")));
        }
        field(51003; "ST Processed"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Processed', Comment = 'ESM="Procesado"';
        }
        field(51004; "ST Percentage to cost"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Percentage to Cost', Comment = 'ESM="Procentaje a Costear"';
        }
        field(51005; "ST Sales Process Cost (LCY)"; Decimal)
        {
            //DataClassification = ToBeClassified;
            Description = 'ULN::PC 001';
            Caption = 'Sales Process Cost (LCY)', Comment = 'ESM="Costo Procesado Ventas (DL)"';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("Sales Cost Records"."Processed Sales Cost" WHERE("Job No." = FIELD("Job No."), "Job Task No." = FIELD("Job Task No."), "Pla Line No. Draft" = FIELD("Entry No.")));
        }

        field(51006; "ST Processed (LCY)"; Decimal)
        {
            //DataClassification = ToBeClassified;
            Description = 'ULN::PC 001';
            Caption = 'Processed (LCY)', Comment = 'ESM="Procesado DL"';

        }
        field(51007; "ST Entry No. Cost of Sale"; Integer)
        {
            //DataClassification = ToBeClassified;
            Description = 'ULN::PC 001';
            Caption = 'No. Mov Cost of Sale', Comment = 'ESM="No. Mov Costo Venta"';

        }
        field(51008; "ST I.S. Processed"; Boolean)
        {
            Caption = 'I.S. Processed', Comment = 'ESM="A.I. Procesado"';
            Description = 'ULN::PC 001';
        }
        field(51009; "Total (LCY)"; Decimal)
        {
            Caption = 'Total (LCY)', Comment = 'ESM="Total (LCY)"';
            CalcFormula = - Sum("Value Entry"."Cost Amount (Actual)" WHERE("Document No." = FIELD("Document No."),
                                                                           "Document Type" = FILTER("Purchase Credit Memo" | "Purchase Invoice"),
                                                                           "Global Dimension 2 Code" = FIELD("Global Dimension 2 Code"),
                                                                           "Item No." = FIELD("No."),
                                                                           "Job Ledger Entry No." = FIELD("Entry No."),
                                                                           "Item Ledger Entry Type" = CONST("Negative Adjmt.")));
            FieldClass = FlowField;
        }

    }
    procedure "#GetRatioCost"(): Decimal
    begin
        CALCFIELDS("ST Percentage Costed");
        EXIT(ROUND("ST Percentage Costed" / 100 * 10000, 1));
    end;

    var
        myInt: Integer;
}