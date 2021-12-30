page 51064 "Internal Consumption Subform"
{
    // ULN::RM.01  DSI.PE.20.03-01   2020.03.26  * Internal Consumption Process.

    AutoSplitKey = true;
    Caption = 'Lines', Comment = 'ESM="Lineas"';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Sales Line";
    SourceTableView = WHERE("Document Type" = FILTER(Invoice));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Type; Type)
                {

                    trigger OnValidate()
                    begin
                        TypeOnAfterValidate;
                        NoOnAfterValidate;
                        TypeChosen := HasTypeToFillMandatoryFields;
                        SetLocationCodeMandatory;

                        IF xRec."No." <> '' THEN
                            RedistributeTotalsOnAfterValidate;
                        //"Item Category Group Panol" := gSetupLocalization."Item Category Group Pañol";
                        "Internal Comsuption" := TRUE;
                    end;
                }
                field(gNo; gNo)
                {
                    TableRelation = Item;
                    Caption = 'No.';
                    trigger OnValidate()
                    begin
                        VALIDATE("No.", gNo);
                    end;
                }
                field("No."; "No.")
                {
                    Enabled = false;
                    TableRelation = Item;
                    Visible = false;
                    trigger OnValidate()
                    begin
                    end;
                }
                field("Variant Code"; "Variant Code")
                {
                    Enabled = false;
                    Visible = false;
                    trigger OnValidate()
                    begin
                        VariantCodeOnAfterValidate;
                    end;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Description 2"; "Description 2")
                {
                    ApplicationArea = All;
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                    ApplicationArea = All;
                    Enabled = false;
                    Visible = false;
                    trigger OnValidate()
                    begin
                        UnitofMeasureCodeOnAfterValida;
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Location Code"; "Location Code")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        LocationCodeOnAfterValidate;
                        DisponibilidadInventario();
                    end;
                }
                field("Inventory Availability"; "Inventory Availability")
                {
                    Enabled = false;
                    Visible = false;
                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        QuantityOnAfterValidate;
                        RedistributeTotalsOnAfterValidate;

                        SalesHeader.SETRANGE(SalesHeader."No.", "Document No.");
                        SalesHeader.SETRANGE(SalesHeader."Document Type", "Document Type");
                        if SalesHeader.FindFirst() then begin
                            if SalesHeader."Internal Consumption" then
                                "Unit Price" := 0;

                            CurrPage.Update();
                        end;
                    end;
                }
                field("Unit of Measure"; "Unit of Measure")
                {
                    ApplicationArea = All;
                }
                field("Appl.-from Item Entry"; "Appl.-from Item Entry")
                {
                    Enabled = false;
                    Visible = false;
                }
                field("Appl.-to Item Entry"; "Appl.-to Item Entry")
                {
                    Enabled = false;
                    Visible = false;
                }
                field("Deferral Code"; "Deferral Code")
                {
                    Enabled = false;
                    Visible = false;
                }
                field("Resource Type"; "Resource Type")
                {
                    Enabled = false;
                    Visible = false;

                    trigger OnValidate()
                    begin
                        IF "Resource Type" <> xRec."Resource Type" THEN BEGIN
                            "Resource No." := '';
                            "Requisition No." := '';
                        END;
                    end;
                }
                field("Resource No."; "Resource No.")
                {
                    Enabled = false;
                    Visible = false;
                    trigger OnValidate()
                    begin
                        fGetDimesionsResource();
                    end;
                }
                field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
                {
                    Enabled = false;
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("ShortcutDimCode[3]"; ShortcutDimCode[3])
                {
                    ApplicationArea = All;
                    CaptionClass = '1,2,3';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(3, ShortcutDimCode[3]);
                    end;
                }
                field("ShortcutDimCode[4]"; ShortcutDimCode[4])
                {
                    ApplicationArea = All;
                    CaptionClass = '1,2,4';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    //Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(4, ShortcutDimCode[4]);
                    end;
                }
                field("ShortcutDimCode[5]"; ShortcutDimCode[5])
                {
                    ApplicationArea = All;
                    CaptionClass = '1,2,5';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    //Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(5, ShortcutDimCode[5]);
                    end;
                }
                field("ShortcutDimCode[6]"; ShortcutDimCode[6])
                {
                    ApplicationArea = All;
                    CaptionClass = '1,2,6';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    //Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(6, ShortcutDimCode[6]);
                    end;
                }
                field("ShortcutDimCode[7]"; ShortcutDimCode[7])
                {
                    ApplicationArea = All;
                    CaptionClass = '1,2,7';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    //Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(7, ShortcutDimCode[7]);
                    end;
                }
                field("ShortcutDimCode[8]"; ShortcutDimCode[8])
                {
                    ApplicationArea = All;
                    CaptionClass = '1,2,8';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    //Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(8, ShortcutDimCode[8]);
                    end;
                }
                field("Document No."; "Document No.")
                {
                    Enabled = false;
                    Visible = false;
                }
                field("Requisition No."; "Requisition No.")
                {
                    Enabled = false;
                    Visible = false;
                }
                field("Resource Fam.No."; fnGetResourceFam)
                {
                    Enabled = false;
                    Visible = false;
                    Caption = 'Resource Fam.No.';
                    Editable = false;
                }
                field("Department Name"; fnGetDepartmentName)
                {
                    Enabled = false;
                    Visible = false;
                    Caption = 'Department Name';
                    Editable = false;
                }
            }
            group(MyGroup)
            {
                group(MyGroup2)
                {
                    Visible = false;
                    field("Invoice Discount Amount"; TotalSalesLine."Inv. Discount Amount")
                    {
                        AutoFormatExpression = TotalSalesHeader."Currency Code";
                        AutoFormatType = 1;
                        Caption = 'Invoice Discount Amount';
                        Editable = InvDiscAmountEditable;
                        Style = Subordinate;
                        StyleExpr = RefreshMessageEnabled;

                        trigger OnValidate()
                        var
                            SalesHeader: Record "Sales Header";
                        begin
                            SalesHeader.GET("Document Type", "Document No.");
                            SalesCalcDiscByType.ApplyInvDiscBasedOnAmt(TotalSalesLine."Inv. Discount Amount", SalesHeader);
                            CurrPage.UPDATE(FALSE);
                        end;
                    }
                    field("Invoice Disc. Pct."; SalesCalcDiscByType.GetCustInvoiceDiscountPct(Rec))
                    {
                        Caption = 'Invoice Discount %';
                        DecimalPlaces = 0 : 2;
                        Editable = false;
                        Style = Subordinate;
                        StyleExpr = RefreshMessageEnabled;
                        Visible = true;
                    }
                }
                group(MyGroup3)
                {
                    Visible = false;
                    field("Total Amount Excl. VAT"; TotalSalesLine.Amount)
                    {
                        AutoFormatExpression = TotalSalesHeader."Currency Code";
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalExclVATCaption(SalesHeader."Currency Code");
                        Caption = 'Total Amount Excl. VAT';
                        DrillDown = false;
                        Editable = false;
                        Style = Subordinate;
                        StyleExpr = RefreshMessageEnabled;
                    }
                    field("Total VAT Amount"; VATAmount)
                    {
                        AutoFormatExpression = TotalSalesHeader."Currency Code";
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalVATCaption(SalesHeader."Currency Code");
                        Caption = 'Total VAT';
                        Editable = false;
                        Style = Subordinate;
                        StyleExpr = RefreshMessageEnabled;
                    }
                    field("Total Amount Incl. VAT"; TotalSalesLine."Amount Including VAT")
                    {
                        AutoFormatExpression = TotalSalesHeader."Currency Code";
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalInclVATCaption(SalesHeader."Currency Code");
                        Caption = 'Total Amount Incl. VAT';
                        Editable = false;
                        StyleExpr = TotalAmountStyle;
                    }
                    field(RefreshTotals; RefreshMessageText)
                    {
                        DrillDown = true;
                        Editable = false;
                        Enabled = RefreshMessageEnabled;
                        ShowCaption = false;

                        trigger OnDrillDown()
                        begin
                            DocumentTotals.SalesRedistributeInvoiceDiscountAmounts(Rec, VATAmount, TotalSalesLine);
                            CurrPage.UPDATE(FALSE);
                        end;
                    }
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Dimensions)
            {
                AccessByPermission = TableData 348 = R;
                ApplicationArea = Dimensions;
                Caption = 'Dimensions';
                Image = Dimensions;
                Scope = Repeater;
                ShortCutKey = 'Shift+Ctrl+D';
                ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                trigger OnAction()
                begin
                    ShowDimensions;
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        IF SalesHeader.GET("Document Type", "Document No.") THEN;

        DocumentTotals.SalesUpdateTotalsControls(Rec, TotalSalesHeader, TotalSalesLine, RefreshMessageEnabled,
          TotalAmountStyle, RefreshMessageText, InvDiscAmountEditable, CurrPage.EDITABLE, VATAmount);

        TypeChosen := HasTypeToFillMandatoryFields;
        SetLocationCodeMandatory;

        DisponibilidadInventario();
        //"Item Category Group Panol" := gSetupLocalization."Item Category Group Pañol";
        "Internal Comsuption" := TRUE;
        gNo := "No.";
        //IF Rec.ISEMPTY THEN
        //    "No." := '';
    end;

    trigger OnAfterGetRecord()
    begin
        ShowShortcutDimCode(ShortcutDimCode);
        //"Item Category Group Panol" := gSetupLocalization."Item Category Group Pañol";
        "Internal Comsuption" := TRUE;
        gNo := "No.";
        //IF Rec.ISEMPTY THEN
        //    "No." := '';
    end;

    trigger OnDeleteRecord(): Boolean
    var
        ReserveSalesLine: Codeunit "Sales Line-Reserve";
    begin
        IF (Quantity <> 0) AND ItemExists("No.") THEN BEGIN
            COMMIT;
            IF NOT ReserveSalesLine.DeleteLineConfirm(Rec) THEN
                EXIT(FALSE);
            ReserveSalesLine.DeleteLine(Rec);
        END;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        //"Item Category Group Panol" := gSetupLocalization."Item Category Group Pañol";
        "Internal Comsuption" := TRUE;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        //"Item Category Group Panol" := gSetupLocalization."Item Category Group Pañol";
        "Internal Comsuption" := TRUE;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var

    begin
        InitType;
        CLEAR(ShortcutDimCode);
        Type := Type::Item;
        //"Item Category Group Panol" := gSetupLocalization."Item Category Group Pañol";
        "Internal Comsuption" := TRUE;
        //"No." := '';
    end;

    trigger OnOpenPage()
    begin
        gSetupLocalization.GET;
        //gSetupLocalization.TESTFIELD("Item Category Group Pañol");
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        /*Lineas.RESET;
        Lineas.SETRANGE("Document Type", "Document Type");
        Lineas.SETRANGE("Document No.", "Document No.");
        IF Lineas.FINDSET THEN
            REPEAT
                IF "Resource No." = '' THEN
                    Message('No ah ingresado el recurso en la línea %1.', "Line No.");
            UNTIL Lineas.NEXT = 0;*/
    end;

    var
        TotalSalesHeader: Record "Sales Header";
        TotalSalesLine: Record "Sales Line";
        SalesHeader: Record "Sales Header";
        SalesPriceCalcMgt: Codeunit "Sales Price Calc. Mgt.";
        TransferExtendedText: Codeunit "Transfer Extended Text";
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
        SalesCalcDiscByType: Codeunit "Sales - Calc Discount By Type";
        DocumentTotals: Codeunit "Document Totals";
        VATAmount: Decimal;
        ShortcutDimCode: array[8] of Code[20];
        [InDataSet]
        ItemPanelVisible: Boolean;
        TypeChosen: Boolean;
        LocationCodeMandatory: Boolean;
        InvDiscAmountEditable: Boolean;
        TotalAmountStyle: Text;
        RefreshMessageEnabled: Boolean;
        RefreshMessageText: Text;
        recItemLedgerEntry: Record "Item Ledger Entry";
        gCantDisponible: Decimal;
        gTipo: Option Persona,"Máquina";
        Lineas: Record "Sales Line";
        Text001: Label 'You cannot use the Explode BOM function because a prepayment of the sales order has been invoiced.';
        gSetupLocalization: Record "Setup Localization";
        gNo: Code[20];

    procedure ApproveCalcInvDisc()
    begin
        CODEUNIT.RUN(CODEUNIT::"Sales-Disc. (Yes/No)", Rec);
    end;

    procedure CalcInvDisc()
    begin
        CODEUNIT.RUN(CODEUNIT::"Sales-Calc. Discount", Rec);
    end;

    procedure ExplodeBOM()
    begin
        IF "Prepmt. Amt. Inv." <> 0 THEN
            ERROR(Text001);
        CODEUNIT.RUN(CODEUNIT::"Sales-Explode BOM", Rec);
    end;

    procedure OpenPurchOrderForm()
    var
        PurchHeader: Record "Purchase Header";
        PurchOrder: Page "Purchase Order";
    begin
        TESTFIELD("Purchase Order No.");
        PurchHeader.SETRANGE("No.", "Purchase Order No.");
        PurchOrder.SETTABLEVIEW(PurchHeader);
        PurchOrder.EDITABLE := FALSE;
        PurchOrder.RUN;
    end;

    procedure OpenSpecialPurchOrderForm()
    var
        PurchHeader: Record "Purchase Header";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PurchOrder: Page "Purchase Order";
    begin
        TESTFIELD("Special Order Purchase No.");
        PurchHeader.SETRANGE("No.", "Special Order Purchase No.");
        IF NOT PurchHeader.ISEMPTY THEN BEGIN
            PurchOrder.SETTABLEVIEW(PurchHeader);
            PurchOrder.EDITABLE := FALSE;
            PurchOrder.RUN;
        END ELSE BEGIN
            PurchRcptHeader.SETRANGE("Order No.", "Special Order Purchase No.");
            IF PurchRcptHeader.COUNT = 1 THEN
                PAGE.RUN(PAGE::"Posted Purchase Receipt", PurchRcptHeader)
            ELSE
                PAGE.RUN(PAGE::"Posted Purchase Receipts", PurchRcptHeader);
        END;
    end;

    procedure InsertExtendedText(Unconditionally: Boolean)
    begin
        IF TransferExtendedText.SalesCheckIfAnyExtText(Rec, Unconditionally) THEN BEGIN
            CurrPage.SAVERECORD;
            COMMIT;
            TransferExtendedText.InsertSalesExtText(Rec);
        END;
        IF TransferExtendedText.MakeUpdate THEN
            UpdateForm(TRUE);
    end;

    procedure ShowNonstockItems()
    begin
        ShowNonstock;
    end;

    procedure ShowTracking()
    var
        TrackingForm: Page "Order Tracking";
    begin
        TrackingForm.SetSalesLine(Rec);
        TrackingForm.RUNMODAL;
    end;

    procedure ItemChargeAssgnt()
    begin
        ShowItemChargeAssgnt;
    end;

    procedure UpdateForm(SetSaveRecord: Boolean)
    begin
        CurrPage.UPDATE(SetSaveRecord);
    end;

    procedure ShowPrices()
    begin
        SalesHeader.GET("Document Type", "Document No.");
        CLEAR(SalesPriceCalcMgt);
        SalesPriceCalcMgt.GetSalesLinePrice(SalesHeader, Rec);
    end;

    procedure ShowLineDisc()
    begin
        SalesHeader.GET("Document Type", "Document No.");
        CLEAR(SalesPriceCalcMgt);
        SalesPriceCalcMgt.GetSalesLineLineDisc(SalesHeader, Rec);
    end;

    procedure OrderPromisingLine()
    var
        OrderPromisingLine: Record "Order Promising Line" temporary;
        OrderPromisingLines: Page "Order Promising Lines";
    begin
        OrderPromisingLine.SETRANGE("Source Type", "Document Type");
        OrderPromisingLine.SETRANGE("Source ID", "Document No.");
        OrderPromisingLine.SETRANGE("Source Line No.", "Line No.");

        OrderPromisingLines.SetSourceType(OrderPromisingLine."Source Type"::Sales);
        OrderPromisingLines.SETTABLEVIEW(OrderPromisingLine);
        OrderPromisingLines.RUNMODAL;
    end;

    local procedure TypeOnAfterValidate()
    begin
        ItemPanelVisible := Type = Type::Item;
    end;

    local procedure NoOnAfterValidate()
    begin
        InsertExtendedText(FALSE);
        IF (Type = Type::"Charge (Item)") AND ("No." <> xRec."No.") AND
           (xRec."No." <> '')
        THEN
            CurrPage.SAVERECORD;

        SaveAndAutoAsmToOrder;

        IF Reserve = Reserve::Always THEN BEGIN
            CurrPage.SAVERECORD;
            IF ("Outstanding Qty. (Base)" <> 0) AND ("No." <> xRec."No.") THEN BEGIN
                AutoReserve;
                CurrPage.UPDATE(FALSE);
            END;
        END;
    end;

    local procedure CrossReferenceNoOnAfterValidat()
    begin
        InsertExtendedText(FALSE);
    end;

    local procedure VariantCodeOnAfterValidate()
    begin
        SaveAndAutoAsmToOrder;
    end;

    local procedure LocationCodeOnAfterValidate()
    begin
        SaveAndAutoAsmToOrder;

        IF (Reserve = Reserve::Always) AND
           ("Outstanding Qty. (Base)" <> 0) AND
           ("Location Code" <> xRec."Location Code")
        THEN BEGIN
            CurrPage.SAVERECORD;
            AutoReserve;
            CurrPage.UPDATE(FALSE);
        END;
    end;

    local procedure ReserveOnAfterValidate()
    begin
        IF (Reserve = Reserve::Always) AND ("Outstanding Qty. (Base)" <> 0) THEN BEGIN
            CurrPage.SAVERECORD;
            AutoReserve;
            CurrPage.UPDATE(FALSE);
        END;
    end;

    local procedure QuantityOnAfterValidate()
    var
        UpdateIsDone: Boolean;
    begin
        IF Type = Type::Item THEN
            CASE Reserve OF
                Reserve::Always:
                    BEGIN
                        CurrPage.SAVERECORD;
                        AutoReserve;
                        CurrPage.UPDATE(FALSE);
                        UpdateIsDone := TRUE;
                    END;
                Reserve::Optional:
                    IF (Quantity < xRec.Quantity) AND (xRec.Quantity > 0) THEN BEGIN
                        CurrPage.SAVERECORD;
                        CurrPage.UPDATE(FALSE);
                        UpdateIsDone := TRUE;
                    END;
            END;

        IF (Type = Type::Item) AND
           (Quantity <> xRec.Quantity) AND
           NOT UpdateIsDone
        THEN
            CurrPage.UPDATE(TRUE);
    end;

    local procedure QtyToAsmToOrderOnAfterValidate()
    begin
        CurrPage.SAVERECORD;
        IF Reserve = Reserve::Always THEN
            AutoReserve;
        CurrPage.UPDATE(TRUE);
    end;

    local procedure UnitofMeasureCodeOnAfterValida()
    begin
        IF Reserve = Reserve::Always THEN BEGIN
            CurrPage.SAVERECORD;
            AutoReserve;
            CurrPage.UPDATE(FALSE);
        END;
    end;

    local procedure ShipmentDateOnAfterValidate()
    begin
        IF (Reserve = Reserve::Always) AND
           ("Outstanding Qty. (Base)" <> 0) AND
           ("Shipment Date" <> xRec."Shipment Date")
        THEN BEGIN
            CurrPage.SAVERECORD;
            AutoReserve;
            CurrPage.UPDATE(FALSE);
        END;
    end;

    local procedure SaveAndAutoAsmToOrder()
    begin
        IF (Type = Type::Item) AND IsAsmToOrderRequired THEN BEGIN
            CurrPage.SAVERECORD;
            AutoAsmToOrder;
            CurrPage.UPDATE(FALSE);
        END;
    end;

    local procedure SetLocationCodeMandatory()
    var
        InventorySetup: Record "Inventory Setup";
    begin
        InventorySetup.GET;
        LocationCodeMandatory := InventorySetup."Location Mandatory" AND (Type = Type::Item);
    end;

    local procedure RedistributeTotalsOnAfterValidate()
    begin
        CurrPage.SAVERECORD;

        SalesHeader.GET("Document Type", "Document No.");
        IF DocumentTotals.SalesCheckNumberOfLinesLimit(SalesHeader) THEN
            DocumentTotals.SalesRedistributeInvoiceDiscountAmounts(Rec, VATAmount, TotalSalesLine);
        CurrPage.UPDATE;
    end;

    local procedure DisponibilidadInventario()
    begin
        gCantDisponible := 0;
        recItemLedgerEntry.SETRANGE(recItemLedgerEntry."Item No.", Rec."No.");
        recItemLedgerEntry.SETRANGE(recItemLedgerEntry."Location Code", Rec."Location Code");
        recItemLedgerEntry.SETRANGE(recItemLedgerEntry.Open, TRUE);
        IF recItemLedgerEntry.FINDSET THEN
            REPEAT
                gCantDisponible := gCantDisponible + recItemLedgerEntry."Remaining Quantity";
            UNTIL recItemLedgerEntry.NEXT = 0;
    end;

    local procedure fGetDimesionsResource()
    var
        lcRecResource: Record "Resource";
        lcRecDefaultDim: Record "Default Dimension";
        lcRecDimValue: Record "Dimension Value";
        lcRecDimSetEntry: Record "Dimension Set Entry";
        lcCuDimMgt: Codeunit "DimensionManagement";
    begin
        IF ("Resource No." = '') OR ("Resource Type" = "Resource Type"::" ") THEN
            EXIT;
        lcRecResource.RESET;
        CASE "Resource Type" OF
            "Resource Type"::Person:
                lcRecResource.SETRANGE(Type, lcRecResource.Type::Person);
            "Resource Type"::Machine:
                lcRecResource.SETRANGE(Type, lcRecResource.Type::Machine);
        END;
        lcRecResource.SETRANGE("No.", "Resource No.");
        IF lcRecResource.FINDSET THEN BEGIN
            lcRecDefaultDim.RESET;
            lcRecDefaultDim.SETRANGE("Table ID", 156);
            lcRecDefaultDim.SETRANGE("No.", "Resource No.");
            IF lcRecDefaultDim.FINDSET THEN
                REPEAT
                    IF lcRecDimValue.GET(lcRecDefaultDim."Dimension Code", lcRecDefaultDim."Dimension Value Code") THEN BEGIN
                        CASE lcRecDimValue."Global Dimension No." OF
                            1:
                                VALIDATE("Shortcut Dimension 1 Code", lcRecDefaultDim."Dimension Value Code");
                            2:
                                VALIDATE("Shortcut Dimension 2 Code", lcRecDefaultDim."Dimension Value Code");
                            ELSE
                                ValidateShortcutDimCode(lcRecDimValue."Global Dimension No.", lcRecDefaultDim."Dimension Value Code");
                        END;
                    END;
                UNTIL lcRecDefaultDim.NEXT = 0;
        END;

        // Division.RESET;
        // Division.SETRANGE("Table ID",156);
        // Division.SETRANGE("No.","Resource No.");
        // Division.SETRANGE("Dimension Code",'DIV');
        // IF Division.FINDFIRST THEN
        //  VALIDATE("Shortcut Dimension 1 Code",Division."Dimension Value Code");
        //
        // Departamento.RESET;
        // Departamento.SETRANGE("Table ID",156);
        // Departamento.SETRANGE("No.","Resource No.");
        // Departamento.SETRANGE("Dimension Code",'DEPT');
        // IF Departamento.FINDFIRST THEN
        //  VALIDATE("Shortcut Dimension 2 Code",Departamento."Dimension Value Code");
    end;

    local procedure fnGetResourceFam(): Text
    var
        Recurso: Record "Resource";
    begin
        IF Recurso.GET("Resource No.") THEN
            EXIT(Recurso."Resource Group No.")
        ELSE BEGIN
            EXIT('');
            CLEAR(Recurso);
        END;
    end;

    local procedure fnGetDepartmentName(): Text
    var
        Departamento: Record "Default Dimension";
        ValorDimension: Record "Dimension Value";
    begin
        Departamento.RESET;
        Departamento.SETRANGE("Table ID", 156);
        Departamento.SETRANGE("No.", "Resource No.");
        Departamento.SETRANGE("Dimension Code", 'DEPT');
        IF Departamento.FINDFIRST THEN BEGIN
            ValorDimension.RESET;
            ValorDimension.SETRANGE("Dimension Code", 'DEPT');
            ValorDimension.SETRANGE(Code, Departamento."Dimension Value Code");
            IF ValorDimension.FINDFIRST THEN
                EXIT(ValorDimension.Name)
            ELSE
                EXIT('');
        END ELSE
            EXIT('');
    end;
}

