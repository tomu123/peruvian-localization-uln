tableextension 51089 "FT Sales Invoice Line" extends "Sales Invoice Line"
{
    fields
    {
        // Add changes to table fields here
        field(51015; "FT Free Title Line"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Free Title Line';
        }

        //Internal Consumption
        field(51016; "Internal Comsuption"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Internal Consumption', Comment = 'ESM="Consumo Interno"';
        }
        field(51018; "Inventory Availability"; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry"."Remaining Quantity" WHERE("Item No." = FIELD("No."),
                                                                              "Variant Code" = FIELD("Variant Code"),
                                                                              "Location Code" = FIELD("Location Code"),
                                                                              Open = FILTER(true)));
            Caption = 'Inventory Availability', Comment = 'ESM="Disponibilidad Inventario"';
            DecimalPlaces = 0 : 5;
            FieldClass = FlowField;
        }
        field(51019; "Resource Type"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Resource Type', Comment = 'ESM="Tipo Recurso"';
            OptionCaption = ' ,Person,Machine', Comment = 'ESM=" ,Persona,Maquina"';
            OptionMembers = " ",Person,Machine;
        }
        field(51020; "Resource No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Resource No.', Comment = 'ESM="N° Recurso"';
            TableRelation = IF ("Resource Type" = CONST(Machine)) Resource."No." WHERE(Type = CONST(Machine))
            ELSE
            IF ("Resource Type" = CONST(Person)) Resource."No." WHERE(Type = CONST(Person));
        }
        field(51021; "Requisition No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Requisition No.', Comment = 'ESM="N° Solicitud"';
        }
        // -Agrupador para las lineas
        field(51907; "Cluster Items"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Cluster Items', Comment = 'ESM="Prod. Agrupador"';
            TableRelation = Item."No.";
        }
    }
}