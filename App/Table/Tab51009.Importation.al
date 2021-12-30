table 51009 Importation
{
    DataClassification = ToBeClassified;
    Caption = 'Importation';
    LookupPageId = "Importation List";
    DrillDownPageId = "Importation List";
    fields
    {
        field(1; "Shortcut Dimension 1 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            CaptionClass = '1,2,1';
        }
        field(2; "Shortcut Dimension 2 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            CaptionClass = '1,2,2';
        }
        field(3; "Entry Point"; Code[10])
        {
            Caption = 'Incoterm';
            DataClassification = ToBeClassified;
            TableRelation = "Entry/Exit Point";
        }
        field(4; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                SLSetup.Get();
                if "Importation Vendor No." = '' then
                    "Importation Vendor No." := SLSetup."Importation Vendor No.";
                if "DUA Vendor No." = '' then
                    "DUA Vendor No." := SLSetup."DUA Vendor No.";
                if "Freight Vendor No." = '' then
                    "Freight Vendor No." := SLSetup."Freight Vendor No.";
                if "Other Vendor No. 1" = '' then
                    "Other Vendor No. 1" := SLSetup."Other Vendor No. 1";
                if "Other Vendor No. 2" = '' then
                    "Other Vendor No. 2" := SLSetup."Other Vendor No. 2";
                if "Vendor Handling" = '' then
                    "Vendor Handling" := SLSetup."Handling Vendor No.";
                if "Vendor Handling" = '' then
                    "Sure Vendor No." := SLSetup."Insurance Vendor No.";
            end;
        }
        field(5; "Description"; Text[200])
        {
            DataClassification = ToBeClassified;
            Caption = 'Description';
        }
        field(6; "Import Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Import Date';
        }

        field(7; "Import Manager"; code[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'Responsible Person No.';
            //CaptionML = ENU = 'Responsible for import', ESP = 'Responsable de importación', ESM = 'Responsable de importación';
            TableRelation = "Salesperson/Purchaser";

        }

        field(8; "Registered Cost (DL)"; Decimal)
        {
            //DataClassification = ToBeClassified;
            //CaptionML = ENU = 'Registered cost (LC)', ESP = 'Costeo registrado (DL)', ESM = 'Costeo registrado (DL)';
            Caption = 'Registered Cost (LCY)';
            FieldClass = FlowField;
            CalcFormula = Sum ("Value Entry"."Cost Amount (Actual)" WHERE("Importation No." = FIELD("No.")));
            Editable = false;
        }
        field(9; "Transit Cost (LCY)"; Decimal)
        {
            //DataClassification = ToBeClassified;
            //CaptionML = ENU = 'Transit cost (LC)', ESP = 'Costeo en tránsito (DL)', ESM = 'Costeo en tránsito (DL)';
            Caption = 'Transit Cost (LCY)';
            FieldClass = FlowField;
            CalcFormula = Sum ("Value Entry"."Cost Amount (Expected)" WHERE("Importation No." = FIELD("No.")));
            Editable = false;
        }
        field(10; "Importation Vendor No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Importation Vendor No.';
            TableRelation = Vendor;
            trigger OnValidate()
            begin
                SetNameVendor();
            end;
        }
        field(11; "DUA Vendor No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'DUA Vendor No.';
            TableRelation = Vendor;
        }
        field(12; "Freight Vendor No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Freight Vendor No.', Comment = 'ESM="N° Proveedor Flete"';
            TableRelation = Vendor;
        }
        field(13; "Other Vendor No. 1"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Other Vendor No. 1', Comment = 'ESM="N° Proveedor Otro 1"';
            TableRelation = Vendor;
        }
        field(14; "Other Vendor No. 2"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Other Vendor No. 2', Comment = 'ESM="N° Proveedor Otro 2"';
            TableRelation = Vendor;
        }
        field(15; "Quantity Order Transit"; Integer)
        {
            //DataClassification = ToBeClassified;
            Caption = 'Amount of orderin progress', Comment = 'ESM="Importe de ordenes en proceso"';
            FieldClass = FlowField;
            CalcFormula = count ("Purchase Header" where("Document Type" = const(Order), "Importation No." = field("No.")));
            Editable = false;
        }
        field(16; "Quantity Invoices"; Integer)
        {
            //DataClassification = ToBeClassified;
            Caption = 'Quantity Invoice', Comment = 'ESM="Cantidad a facturar"';
            FieldClass = FlowField;
            CalcFormula = Count ("Purch. Inv. Header" WHERE("Importation No." = FIELD("No.")));
            Editable = false;
        }
        field(17; "User Modify"; Code[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'Changue Author', Comment = 'ESM="Id. Usuario Modificación"';
            Editable = false;
        }
        field(18; "Hour"; Time)
        {
            DataClassification = ToBeClassified;
            Caption = 'Modification Time', Comment = 'ESM="Hora de modificación"';
            Editable = false;
        }
        field(19; "Modification Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Modification Date', Comment = 'ESM="Fecha de modificación"';
            Editable = false;
        }
        field(20; "Vendor Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Vendor Name', Comment = 'ESM="Nombre Proveedor"';
            Editable = false;

        }
        field(21; "Perception Vendor No."; code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Perception Vendor No.', Comment = 'ESM="N° Proveedor Percepción"';
            TableRelation = Vendor;
        }
        field(22; "No. Series"; code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'No. Series', Comment = 'ESM="N° Serie"';
        }

        field(23; "Nationalization"; Option)
        {
            Caption = 'Nationalization', Comment = 'ESM="Nacionalización"';
            OptionMembers = " ",Yes,No;
            OptionCaption = ' ,Yes,No';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                "Date Nationalization" := WorkDate();
            end;
        }
        field(24; "Vendor Handling"; code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Vendor Handling', Comment = 'ESM="Proveedor Despacho"';
            TableRelation = Vendor;
        }
        field(25; "Lot for sale"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Lot for sale', Comment = 'ESM="Lote venta"';
            Editable = false;
        }
        field(26; "Status"; Option)
        {
            Caption = 'Status', Comment = 'ESM="Estado"';
            OptionCaption = 'Open,Closed', Comment = 'ESM="Abierto,Cerrado"';
            OptionMembers = "Open","Closed";
            DataClassification = ToBeClassified;
        }
        field(27; "Sure Vendor No."; Code[20])
        {
            Caption = 'Sure Vendor No.', Comment = 'ESM="N° Proveedor Seguro"';
            DataClassification = ToBeClassified;
            TableRelation = Vendor;
        }
        field(28; "Date Nationalization"; date)
        {
            Caption = 'Nationalization Date', Comment = 'ESM="Fecha Nacionalización"';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                gCuImportation.Nacionalizar(Rec);
            end;

        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        //BEGIN ULN::OMG 002 ++
        InitInsert;
        //END ULN::OMG 002 --
        Hour := TIME;
        "User Modify" := USERID;
        "Modification Date" := TODAY;
        "Import Manager" := USERID;

    end;

    trigger OnModify()
    begin
        Hour := TIME;
        "User Modify" := USERID;
        "Modification Date" := TODAY;

    end;

    trigger OnDelete()
    begin
        if NOT ("No." = '') then BEGIN
            gPurchLine.SETFILTER("Importation No.", "No.");
            if gPurchLine.COUNT > 0 then ERROR(ULN001);
            gPurchInvLine.SETFILTER("Importation No.", "No.");
            if gPurchInvLine.COUNT > 0 then ERROR(ULN002);
        END;

    end;

    procedure InitInsert()
    begin
        //BEGIN ULN::OMG 002 ++
        if "No." = '' then BEGIN
            SLSetup.Get();
            SLSetup.TestField("Importation No. Series");
            NoSeriesMgt.InitSeries(SLSetup."Importation No. Series", xRec."No. Series", "Modification Date", "No.", "No. Series");
        END;
        if "No." = '' then
            Error('El No. no puede estar vacio');
        //BEGIN ULN::OMG 002 --
    end;

    procedure "#AssistEditMini"(pImp: Record Importation): Boolean
    begin
        //002
        Copy(Rec);
        SLSetup.Get();
        SLSetup.TestField("Importation No. Series");
        if NoSeriesMgt.SelectSeries(SLSetup."Importation No. Series", SLSetup."Importation No. Series", "No. Series") then BEGIN
            EXIT(TRUE);
        END;
        //002
    end;

    local procedure SetNameVendor()
    var
        Vendor: Record Vendor;
    begin
        Vendor.GET("Importation Vendor No.");
        "Vendor Name" := Vendor.Name;
    end;

    VAR
        SLSetup: Record "Setup Localization";
        gGeneralCont: Record "General Ledger Setup";
        NoSeriesMgt: Codeunit "NoSeriesManagement";
        gPurchInvLine: Record "Purch. Inv. Line";
        gPurchLine: Record "Purchase Line";
        gCuImportation: Codeunit "Importation Calculation";
        ULN001: Label 'There are movements pending this import', Comment = 'ESM="Existe movimientos pendientes a esta importación"';
        ULN002: Label 'There are pending invoices for this import', Comment = 'ESM="Existe facturas pendientes a esta importación"';
}