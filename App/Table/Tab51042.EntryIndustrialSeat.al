table 51042 "Entry Industrial Seat"
{
    Caption = 'Entry Industrial Seat', Comment = 'ESM="Mov. Costeo"';
    DrillDownPageID = "Job Ledger Entries";
    LookupPageID = "Job Ledger Entries";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry No.', Comment = 'ESM="Nº mov."';
        }
        field(2; "Job No."; Code[20])
        {
            Caption = 'Job No.', Comment = 'ESM="Nº proyecto"';
            TableRelation = Job;
        }
        field(3; "Posting Date"; Date)
        {
            Caption = 'Posting Date', Comment = 'ESM="Fecha registro"';
        }
        field(4; "Document No."; Code[20])
        {
            Caption = 'Document No.', Comment = 'ESM="Nº documento"';
        }
        field(5; Type; Option)
        {
            Caption = 'Type', Comment = 'ESM="Tipo"';
            OptionCaption = 'Resource,Item,G/L Account';
            OptionMembers = Resource,Item,"G/L Account";
        }
        field(7; "No."; Code[20])
        {
            Caption = 'No.', Comment = 'ESM="No."';
            TableRelation = IF (Type = CONST(Resource)) Resource
            ELSE
            IF (Type = CONST(Item)) Item
            ELSE
            IF (Type = CONST("G/L Account")) "G/L Account";
        }
        field(8; Description; Text[100])
        {
            Caption = 'Description', Comment = 'ESM="Descripción"';
        }
        field(9; Quantity; Decimal)
        {
            Caption = 'Quantity', Comment = 'ESM="Cantidad"';
            DecimalPlaces = 0 : 5;
        }
        field(11; "Direct Unit Cost (LCY)"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Direct Unit Cost (LCY)';
        }
        field(12; "Unit Cost (LCY)"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Cost (LCY)';
            Editable = false;
        }
        field(13; "Total Cost (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Total Cost (LCY)', Comment = 'ESM="Costo total ($)"';
            Editable = false;
        }
        field(14; "Unit Price (LCY)"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            Caption = 'Unit Price (LCY)', Comment = 'ESM="Precio unitario"';
            Editable = false;
        }
        field(15; "Total Price (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Total Price (LCY)';
            Editable = false;
        }
        field(16; "Resource Group No."; Code[20])
        {
            Caption = 'Resource Group No.';
            Editable = false;
            TableRelation = "Resource Group";
        }
        field(17; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = IF (Type = CONST(Item)) "Item Unit of Measure".Code WHERE("Item No." = FIELD("No."))
            ELSE
            IF (Type = CONST(Resource)) "Resource Unit of Measure".Code WHERE("Resource No." = FIELD("No."));
        }
        field(20; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
        }
        field(29; "Job Posting Group"; Code[20])
        {
            Caption = 'Job Posting Group';
            TableRelation = "Inventory Posting Group";
        }
        field(30; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(31; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(32; "Work Type Code"; Code[10])
        {
            Caption = 'Work Type Code';
            TableRelation = "Work Type";
        }
        field(33; "Customer Price Group"; Code[10])
        {
            Caption = 'Customer Price Group';
            TableRelation = "Customer Price Group";
        }
        field(37; "User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(38; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            TableRelation = "Source Code";
        }
        field(40; "Shpt. Method Code"; Code[10])
        {
            Caption = 'Shpt. Method Code';
            TableRelation = "Shipment Method";
        }
        field(60; "Amt. to Post to G/L"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amt. to Post to G/L';
        }
        field(61; "Amt. Posted to G/L"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amt. Posted to G/L';
        }
        field(64; "Entry Type"; Option)
        {
            Caption = 'Entry Type', Comment = 'ESM="Tipo movimiento"';
            OptionCaption = 'Uso,Venta';
            OptionMembers = Usage,Sale;
        }
        field(75; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
        }
        field(76; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(77; "Transaction Type"; Code[10])
        {
            Caption = 'Transaction Type';
            TableRelation = "Transaction Type";
        }
        field(78; "Transport Method"; Code[10])
        {
            Caption = 'Transport Method';
            TableRelation = "Transport Method";
        }
        field(79; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(80; "Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(81; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(82; "Entry/Exit Point"; Code[10])
        {
            Caption = 'Entry/Exit Point';
            TableRelation = "Entry/Exit Point";
        }
        field(83; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(84; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
        }
        field(85; "Area"; Code[10])
        {
            Caption = 'Area';
            TableRelation = Area;
        }
        field(86; "Transaction Specification"; Code[10])
        {
            Caption = 'Transaction Specification';
            TableRelation = "Transaction Specification";
        }
        field(87; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(88; "Additional-Currency Total Cost"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Additional-Currency Total Cost';
        }
        field(89; "Add.-Currency Total Price"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Add.-Currency Total Price';
        }
        field(94; "Add.-Currency Line Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Add.-Currency Line Amount';
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

        }
        field(1000; "Job Task No."; Code[20])
        {
            Caption = 'Job Task No.', Comment = 'ESM="Nº tarea proyecto"';
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("Job No."));
        }
        field(1001; "Line Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Line Amount (LCY)';
            Editable = false;
        }
        field(1002; "Unit Cost"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            Caption = 'Unit Cost';
        }
        field(1003; "Total Cost"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Total Cost';
        }
        field(1004; "Unit Price"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            Caption = 'Unit Price';
        }
        field(1005; "Total Price"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Total Price';
        }
        field(1006; "Line Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Line Amount';
        }
        field(1007; "Line Discount Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Line Discount Amount';
        }
        field(1008; "Line Discount Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Line Discount Amount (LCY)';
            Editable = false;
        }
        field(1009; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(1010; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
        }
        field(1016; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
        }
        field(1017; "Ledger Entry Type"; Option)
        {
            Caption = 'Ledger Entry Type';
            OptionCaption = ' ,Resource,Item,G/L Account';
            OptionMembers = " ",Resource,Item,"G/L Account";
        }
        field(1018; "Ledger Entry No."; Integer)
        {
            BlankZero = true;
            Caption = 'Ledger Entry No.';
            TableRelation = IF ("Ledger Entry Type" = CONST(Resource)) "Res. Ledger Entry"
            ELSE
            IF ("Ledger Entry Type" = CONST(Item)) "Item Ledger Entry"
            ELSE
            IF ("Ledger Entry Type" = CONST("G/L Account")) "G/L Entry";
        }
        field(1019; "Serial No."; Code[50])
        {
            Caption = 'Serial No.';
        }
        field(1020; "Lot No."; Code[50])
        {
            Caption = 'Lot No.';
        }
        field(1021; "Line Discount %"; Decimal)
        {
            Caption = 'Line Discount %';
            DecimalPlaces = 0 : 5;
        }
        field(1022; "Line Type"; Option)
        {
            Caption = 'Line Type';
            OptionCaption = ' ,Budget,Billable,Both Budget and Billable';
            OptionMembers = " ",Budget,Billable,"Both Budget and Billable";
        }
        field(1023; "Original Unit Cost (LCY)"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Original Unit Cost (LCY)';
            Editable = false;
        }
        field(1024; "Original Total Cost (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Original Total Cost (LCY)';
            Editable = false;
        }
        field(1025; "Original Unit Cost"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            Caption = 'Original Unit Cost';
        }
        field(1026; "Original Total Cost"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Original Total Cost';
        }
        field(1027; "Original Total Cost (ACY)"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Original Total Cost (ACY)';
        }
        field(1028; Adjusted; Boolean)
        {
            Caption = 'Adjusted';
        }
        field(1029; "DateTime Adjusted"; DateTime)
        {
            Caption = 'DateTime Adjusted';
        }
        field(5402; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = IF (Type = CONST(Item)) "Item Variant".Code WHERE("Item No." = FIELD("No."));
        }
        field(5403; "Bin Code"; Code[20])
        {
            Caption = 'Bin Code';
            TableRelation = Bin.Code WHERE("Location Code" = FIELD("Location Code"));
        }
        field(5404; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(5405; "Quantity (Base)"; Decimal)
        {
            Caption = 'Quantity (Base)';
        }
        field(5900; "Service Order No."; Code[20])
        {
            Caption = 'Service Order No.';
        }
        field(5901; "Posted Service Shipment No."; Code[20])
        {
            Caption = 'Posted Service Shipment No.';
        }
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
        field(51020; "ST Processed Cost (LCY)"; Decimal)
        {
            //DataClassification = ToBeClassified;
            Description = 'ULN::PC 001';
            Caption = 'Sales Process Cost (LCY)', Comment = 'ESM="Procesado Ventas (DL)-Ejecutado"';
            Editable = false;
        }
        field(51021; "ST Percentage"; Decimal)
        {
            //DataClassification = ToBeClassified;
            Description = 'ULN::PC 001';
            Caption = 'ST Percentage', Comment = 'ESM="Porcentaje Costeado"';
            Editable = false;
        }
        field(51027; "ST Percentage Process"; Decimal)
        {
            //DataClassification = ToBeClassified;
            Description = 'ULN::PC 001';
            Caption = 'ST Percentage', Comment = 'ESM="% Ejecutado Registro C.V."';
            Editable = false;
        }
        field(51022; "ST Related Document"; Text[20])
        {
            //DataClassification = ToBeClassified;
            Description = 'ULN::PC 001';
            Caption = 'ST Related Document', Comment = 'ESM="Documento Relacionado"';
            Editable = false;
        }
        field(51023; "ST Entry No. Related"; Integer)
        {
            //DataClassification = ToBeClassified;
            Description = 'ULN::PC 001';
            Caption = 'ST Entry No.', Comment = 'ESM="Nº. Mov Relacionado"';
            Editable = false;
        }
        field(51024; "Process Date"; Date)
        {
            Description = 'ULN::PC 001';
            Caption = 'Process Date', Comment = 'ESM="Fecha Procesada"';
            Editable = false;
        }
        field(51025; "USERID Process"; Text[100])
        {
            Description = 'ULN::PC 001';
            Caption = 'USERID Process', Comment = 'ESM="Usuario del proceso"';
            Editable = false;
        }
        field(51026; "ST Entry No. Related Sales"; Integer)
        {
            //DataClassification = ToBeClassified;
            Description = 'ULN::PC 001';
            Caption = 'ST Entry No.', Comment = 'ESM="Nº. Mov Relacionado Venta"';
            Editable = false;
        }
    }


    keys
    {
        key(Key1; "Entry No.", "ST Entry No. Related")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Entry No.", "Job No.", "Posting Date", "Document No.")
        {
        }
    }


}
