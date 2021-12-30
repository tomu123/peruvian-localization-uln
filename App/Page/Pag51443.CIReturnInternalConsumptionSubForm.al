page 51443 "CI Return Int. Cnsmpt. SubForm"
{
    // ULN::RM.01  DSI.PE.20.03-01   2020.03.27  * Internal Consumption Process.

    AutoSplitKey = true;
    Caption = 'Int. Consumption Return Subform',
                Comment = 'ESM="Devolución del Cons. Int. Líneas"';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Sales Line";
    SourceTableView = WHERE("Document Type" = FILTER("Credit Memo"));

    layout
    {
        area(content)
        {
            repeater(Control85)
            {
                field("Line No."; "Line No.")
                {
                    Editable = false;
                    Visible = false;
                }
                field(Type; Type)
                {
                    Caption = 'Type',
                                Comment = 'ESM="Tipo"';

                    trigger OnValidate();
                    begin
                        TypeOnAfterValidate;
                        NoOnAfterValidate;
                        TypeChosen := HasTypeToFillMandatoryFields;
                        SetLocationCodeMandatory;

                        if xRec."No." <> '' then
                            RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("No."; "No.")
                {

                    trigger OnLookup(var Text: Text): Boolean;
                    var
                        lcItemRec: Record Item;
                        lcGeneralLedgerSetup: Record "General Ledger Setup";
                    begin
                        lcItemRec.RESET;
                        if PAGE.RUNMODAL(0, lcItemRec) = ACTION::LookupOK then begin
                            Text := lcItemRec."No.";
                            exit(true);
                        end;
                    end;
                }
                field(Description; Description)
                {
                    QuickEntry = false;
                }
                field("Description 2"; "Description 2")
                {
                }
                field("Variant Code"; "Variant Code")
                {
                    Visible = false;

                    trigger OnValidate();
                    begin
                        VariantCodeOnAfterValidate;
                    end;
                }
                field("Purchasing Code"; "Purchasing Code")
                {
                    Visible = false;
                }
                field("VAT Bus. Posting Group"; "VAT Bus. Posting Group")
                {
                }
                field("VAT Prod. Posting Group"; "VAT Prod. Posting Group")
                {
                    Visible = false;

                    trigger OnValidate();
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Gen. Bus. Posting Group"; "Gen. Bus. Posting Group")
                {
                }
                field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
                {
                }
                field("Location Code"; "Location Code")
                {
                    QuickEntry = false;
                    ShowMandatory = LocationCodeMandatory;

                    trigger OnValidate();
                    begin
                        LocationCodeOnAfterValidate;
                        DisponibilidadInventario();
                    end;
                }
                field("Bin Code"; "Bin Code")
                {
                    Visible = false;
                }
                field(Quantity; Quantity)
                {
                    BlankZero = true;
                    Caption = 'Quantity Consumption',
                                Comment = 'ESM="Cantidad Consumo"';
                    ShowMandatory = TypeChosen;

                    trigger OnValidate();
                    begin
                        QuantityOnAfterValidate;
                        RedistributeTotalsOnAfterValidate;

                        SalesHeader.SETRANGE(SalesHeader."No.", "Document No.");
                        SalesHeader.SETRANGE(SalesHeader."Document Type", "Document Type");
                        if SalesHeader.FINDSET then begin
                            if SalesHeader."Internal Consumption" then
                                "Unit Price" := 0;
                            CurrPage.UPDATE;
                        end;
                    end;
                }
                field("Quantity (Base)"; "Quantity (Base)")
                {
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                    QuickEntry = false;

                    trigger OnValidate();
                    begin
                        UnitofMeasureCodeOnAfterValida;
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Qty. per Unit of Measure"; "Qty. per Unit of Measure")
                {
                }
                field("Unit of Measure"; "Unit of Measure")
                {
                    Visible = false;
                }
                field("Unit Cost (LCY)"; "Unit Cost (LCY)")
                {
                    Visible = false;
                }
                field(SalesPriceExist; PriceExists)
                {
                    Caption = 'Sales Price Exists',
                                Comment = 'ESM="Existe precio venta"';
                    Editable = false;
                    Visible = false;
                }
                field("Unit Price"; "Unit Price")
                {
                    BlankZero = true;
                    ShowMandatory = TypeChosen;

                    trigger OnValidate();
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Line Amount"; "Line Amount")
                {
                    BlankZero = true;

                    trigger OnValidate();
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field(SalesLineDiscExists; LineDiscExists)
                {
                    Caption = 'Sales Line Disc. Exists',
                                Comment = 'ESM="Existe dto. línea venta"';
                    Editable = false;
                    Visible = false;
                }
                field("Line Discount %"; "Line Discount %")
                {
                    BlankZero = true;

                    trigger OnValidate();
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Line Discount Amount"; "Line Discount Amount")
                {
                    Visible = false;

                    trigger OnValidate();
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Prepayment %"; "Prepayment %")
                {
                    Visible = false;

                    trigger OnValidate();
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Prepmt. Line Amount"; "Prepmt. Line Amount")
                {
                    Visible = false;

                    trigger OnValidate();
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Prepmt. Amt. Inv."; "Prepmt. Amt. Inv.")
                {
                    Visible = false;

                    trigger OnValidate();
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Allow Invoice Disc."; "Allow Invoice Disc.")
                {
                    Visible = false;
                }
                field("Inv. Discount Amount"; "Inv. Discount Amount")
                {
                    Visible = false;
                }
                field("Qty. to Ship"; "Qty. to Ship")
                {
                    BlankZero = true;

                    trigger OnValidate();
                    begin
                        if "Qty. to Asm. to Order (Base)" <> 0 then begin
                            CurrPage.SAVERECORD;
                            CurrPage.UPDATE(false);
                        end;
                    end;
                }
                field("Quantity Shipped"; "Quantity Shipped")
                {
                    BlankZero = true;
                    QuickEntry = false;
                }
                field("Qty. to Invoice"; "Qty. to Invoice")
                {
                    BlankZero = true;
                }
                field("Quantity Invoiced"; "Quantity Invoiced")
                {
                    BlankZero = true;
                }
                field("Prepmt Amt to Deduct"; "Prepmt Amt to Deduct")
                {
                    Visible = false;
                }
                field("Prepmt Amt Deducted"; "Prepmt Amt Deducted")
                {
                    Visible = false;
                }
                field("Allow Item Charge Assignment"; "Allow Item Charge Assignment")
                {
                    Visible = false;
                }
                field("Qty. to Assign"; "Qty. to Assign")
                {
                    BlankZero = true;
                    QuickEntry = false;

                    trigger OnDrillDown();
                    begin
                        CurrPage.SAVERECORD;
                        ShowItemChargeAssgnt;
                        UpdateForm(false);
                    end;
                }
                field("Qty. Assigned"; "Qty. Assigned")
                {
                    BlankZero = true;
                    QuickEntry = false;

                    trigger OnDrillDown();
                    begin
                        CurrPage.SAVERECORD;
                        ShowItemChargeAssgnt;
                        CurrPage.UPDATE(false);
                    end;
                }
                field("Requested Delivery Date"; "Requested Delivery Date")
                {
                    Visible = false;
                }
                field("Promised Delivery Date"; "Promised Delivery Date")
                {
                    Visible = false;
                }
                field("Planned Delivery Date"; "Planned Delivery Date")
                {
                    QuickEntry = false;
                }
                field("Planned Shipment Date"; "Planned Shipment Date")
                {
                }
                field("Shipment Date"; "Shipment Date")
                {
                    QuickEntry = false;

                    trigger OnValidate();
                    begin
                        ShipmentDateOnAfterValidate;
                    end;
                }
                field("Shipping Agent Code"; "Shipping Agent Code")
                {
                    Visible = false;
                }
                field("Shipping Agent Service Code"; "Shipping Agent Service Code")
                {
                    Visible = false;
                }
                field("Shipping Time"; "Shipping Time")
                {
                    Visible = false;
                }
                field("Work Type Code"; "Work Type Code")
                {
                    Visible = false;
                }
                field("Whse. Outstanding Qty."; "Whse. Outstanding Qty.")
                {
                    Visible = false;
                }
                field("Whse. Outstanding Qty. (Base)"; "Whse. Outstanding Qty. (Base)")
                {
                    Visible = false;
                }
                field("ATO Whse. Outstanding Qty."; "ATO Whse. Outstanding Qty.")
                {
                    Visible = false;
                }
                field("ATO Whse. Outstd. Qty. (Base)"; "ATO Whse. Outstd. Qty. (Base)")
                {
                    Visible = false;
                }
                field("Outbound Whse. Handling Time"; "Outbound Whse. Handling Time")
                {
                    Visible = false;
                }
                field("Blanket Order No."; "Blanket Order No.")
                {
                    Visible = false;
                }
                field("Blanket Order Line No."; "Blanket Order Line No.")
                {
                    Visible = false;
                }
                field("FA Posting Date"; "FA Posting Date")
                {
                    Visible = false;
                }
                field("Depr. until FA Posting Date"; "Depr. until FA Posting Date")
                {
                    Visible = false;
                }
                field("Depreciation Book Code"; "Depreciation Book Code")
                {
                    Visible = false;
                }
                field("Use Duplication List"; "Use Duplication List")
                {
                    Visible = false;
                }
                field("Duplicate in Depreciation Book"; "Duplicate in Depreciation Book")
                {
                    Visible = false;
                }
                field("Appl.-from Item Entry"; "Appl.-from Item Entry")
                {
                    ApplicationArea = All;
                }
                field("Appl.-to Item Entry"; "Appl.-to Item Entry")
                {
                    ApplicationArea = All;
                }
                field("Deferral Code"; "Deferral Code")
                {
                    Enabled = (Type <> Type::"Fixed Asset") AND (Type <> Type::" ");
                    TableRelation = "Deferral Template"."Deferral Code";
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                    Visible = false;
                }
                field("ShortcutDimCode[3]"; ShortcutDimCode[3])
                {
                    CaptionClass = '1,2,3';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = false;

                    trigger OnValidate();
                    begin
                        ValidateShortcutDimCode(3, ShortcutDimCode[3]);
                    end;
                }
                field("ShortcutDimCode[4]"; ShortcutDimCode[4])
                {
                    CaptionClass = '1,2,4';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = false;

                    trigger OnValidate();
                    begin
                        ValidateShortcutDimCode(4, ShortcutDimCode[4]);
                    end;
                }
                field("ShortcutDimCode[5]"; ShortcutDimCode[5])
                {
                    CaptionClass = '1,2,5';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = false;

                    trigger OnValidate();
                    begin
                        ValidateShortcutDimCode(5, ShortcutDimCode[5]);
                    end;
                }
                field("ShortcutDimCode[6]"; ShortcutDimCode[6])
                {
                    CaptionClass = '1,2,6';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = false;

                    trigger OnValidate();
                    begin
                        ValidateShortcutDimCode(6, ShortcutDimCode[6]);
                    end;
                }
                field("ShortcutDimCode[7]"; ShortcutDimCode[7])
                {
                    CaptionClass = '1,2,7';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = false;

                    trigger OnValidate();
                    begin
                        ValidateShortcutDimCode(7, ShortcutDimCode[7]);
                    end;
                }
                field("ShortcutDimCode[8]"; ShortcutDimCode[8])
                {
                    CaptionClass = '1,2,8';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = false;

                    trigger OnValidate();
                    begin
                        ValidateShortcutDimCode(8, ShortcutDimCode[8]);
                    end;
                }
                field("Document No."; "Document No.")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Resource Type"; "Resource Type")
                {
                    Caption = 'Resource Type', Comment = 'ESP="Tipo Recurso"';

                    trigger OnValidate();
                    begin
                        if "Resource Type" <> xRec."Resource Type" then
                            "Resource No." := '';
                    end;
                }
                field("Resource No."; "Resource No.")
                {

                    trigger OnLookup(var Text: Text): Boolean;
                    var
                        lcResource: Record Resource;
                        lcGeneralLedgerSetup: Record "General Ledger Setup";
                    begin
                        lcGeneralLedgerSetup.GET;

                        lcResource.RESET;
                        case "Resource Type" of
                            1:
                                lcResource.SETRANGE(Type, 0);
                            2:
                                lcResource.SETRANGE(Type, 1);
                        end;

                        lcResource."No." := "Resource No.";
                        if PAGE.RUNMODAL(0, lcResource) = ACTION::LookupOK then begin
                            Text := lcResource."No.";
                            exit(true);
                        end;
                    end;

                    trigger OnValidate();
                    begin
                        fGetDimesionsResource();
                    end;
                }
            }
            group(Control10)
            {
                Visible = false;
                group(Control7)
                {
                    Visible = false;
                    field("Invoice Discount Amount"; TotalSalesLine."Inv. Discount Amount")
                    {
                        AutoFormatExpression = TotalSalesHeader."Currency Code";
                        AutoFormatType = 1;
                        Caption = 'Invoice Discount Amount',
                                    Comment = 'ESM="Importe descuento factura"';
                        Editable = InvDiscAmountEditable;
                        Style = Subordinate;
                        StyleExpr = RefreshMessageEnabled;

                        trigger OnValidate();
                        var
                            SalesHeader: Record "Sales Header";
                        begin
                            SalesHeader.GET("Document Type", "Document No.");
                            SalesCalcDiscByType.ApplyInvDiscBasedOnAmt(TotalSalesLine."Inv. Discount Amount", SalesHeader);
                            CurrPage.UPDATE(false);
                        end;
                    }
                    field("Invoice Disc. Pct."; SalesCalcDiscByType.GetCustInvoiceDiscountPct(Rec))
                    {
                        Caption = 'Invoice Discount %',
                                    Comment = 'ESM="% descuento en factura"';
                        DecimalPlaces = 0 : 2;
                        Editable = false;
                        Style = Subordinate;
                        StyleExpr = RefreshMessageEnabled;
                        Visible = true;
                    }
                }
                group(Control6)
                {
                    Visible = false;
                    field("Total Amount Excl. VAT"; TotalSalesLine.Amount)
                    {
                        AutoFormatExpression = TotalSalesHeader."Currency Code";
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalExclVATCaption(SalesHeader."Currency Code");
                        Caption = 'Total Amount Excl. VAT',
                                    Comment = 'ESM="Importe total sin IVA"';
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
                        Caption = 'Total VAT',
                                    Comment = 'ESM="IVA total"';
                        Editable = false;
                        Style = Subordinate;
                        StyleExpr = RefreshMessageEnabled;
                    }
                    field("Total Amount Incl. VAT"; TotalSalesLine."Amount Including VAT")
                    {
                        AutoFormatExpression = TotalSalesHeader."Currency Code";
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalInclVATCaption(SalesHeader."Currency Code");
                        Caption = 'Total Amount Incl. VAT',
                                    Comment = 'ESM="Importe total con IVA"';
                        Editable = false;
                        StyleExpr = TotalAmountStyle;
                    }
                    field(RefreshTotals; RefreshMessageText)
                    {
                        DrillDown = true;
                        Editable = false;
                        Enabled = RefreshMessageEnabled;
                        ShowCaption = false;

                        trigger OnDrillDown();
                        begin
                            DocumentTotals.SalesRedistributeInvoiceDiscountAmounts(Rec, VATAmount, TotalSalesLine);
                            CurrPage.UPDATE(false);
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
            group("&Line")
            {
                Caption = '&Line',
                            Comment = 'ESM="&Línea"';
                Image = Line;
                group("Item Availability by")
                {
                    Caption = 'Item Availability by',
                                Comment = 'ESM="Disponibilidad prod. por"';
                    Image = ItemAvailability;
                    action("<Action3>")
                    {
                        Caption = 'Event',
                                    Comment = 'ESM="Evento"';
                        Image = "Event";

                        trigger OnAction();
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromSalesLine(Rec, ItemAvailFormsMgt.ByEvent)
                        end;
                    }
                    action(Period)
                    {
                        Caption = 'Period',
                                    Comment = 'ESM="Periodo"';
                        Image = Period;

                        trigger OnAction();
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromSalesLine(Rec, ItemAvailFormsMgt.ByPeriod)
                        end;
                    }
                    action(Variant)
                    {
                        Caption = 'Variant',
                                    Comment = 'ESM="Variante"';
                        Image = ItemVariant;

                        trigger OnAction();
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromSalesLine(Rec, ItemAvailFormsMgt.ByVariant)
                        end;
                    }
                    action(Location)
                    {
                        AccessByPermission = TableData Location = R;
                        Caption = 'Location',
                                    Comment = 'ESM="Almacén"';
                        Image = Warehouse;

                        trigger OnAction();
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromSalesLine(Rec, ItemAvailFormsMgt.ByLocation)
                        end;
                    }
                    action("BOM Level")
                    {
                        Caption = 'BOM Level',
                                    Comment = 'ESM="Nivel L.M."';
                        Image = BOMLevel;

                        trigger OnAction();
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromSalesLine(Rec, ItemAvailFormsMgt.ByBOM)
                        end;
                    }
                }
                action("Reservation Entries")
                {
                    AccessByPermission = TableData Item = R;
                    Caption = 'Reservation Entries',
                                Comment = 'ESM="Movs. reserva"';
                    Image = ReservationLedger;

                    trigger OnAction();
                    begin
                        ShowReservationEntries(true);
                    end;
                }
                action(ItemTrackingLines)
                {
                    Caption = 'Item &Tracking Lines',
                                Comment = 'ESM="Líns. se&guim. prod."';
                    Image = ItemTrackingLines;
                    ShortCutKey = 'Shift+Ctrl+I';

                    trigger OnAction();
                    begin
                        OpenItemTrackingLines;
                    end;
                }

                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension = R;
                    Caption = 'Dimensions',
                                Comment = 'ESM="Dimensiones"';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction();
                    begin
                        ShowDimensions;
                    end;
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments',
                                Comment = 'ESM="C&omentarios"';
                    Image = ViewComments;

                    trigger OnAction();
                    begin
                        ShowLineComments;
                    end;
                }
                action("Item Charge &Assignment")
                {
                    AccessByPermission = TableData "Item Charge" = R;
                    Caption = 'Item Charge &Assignment',
                                Comment = 'ESM="Asi&gnación cargos prod."';
                    Image = ItemCosts;

                    trigger OnAction();
                    begin
                        ItemChargeAssgnt;
                    end;
                }
                action(OrderPromising)
                {
                    AccessByPermission = TableData "Order Promising Line" = R;
                    Caption = 'Order &Promising',
                                Comment = 'ESM="Comprom&iso entrega"';
                    Image = OrderPromising;

                    trigger OnAction();
                    begin
                        OrderPromisingLine;
                    end;
                }
                group("Assemble to Order")
                {
                    Caption = 'Assemble to Order',
                                Comment = 'ESM="Ensamblar para pedido"';
                    Image = AssemblyBOM;
                    action(AssembleToOrderLines)
                    {
                        AccessByPermission = TableData "BOM Component" = R;
                        Caption = 'Assemble-to-Order Lines',
                                    Comment = 'ESM="Ensamblar para líneas de pedido"';

                        trigger OnAction();
                        begin
                            ShowAsmToOrderLines;
                        end;
                    }
                    action("Roll Up &Price")
                    {
                        AccessByPermission = TableData "BOM Component" = R;
                        Caption = 'Roll Up &Price',
                                    Comment = 'ESM="Revertir &precio"';
                        Ellipsis = true;

                        trigger OnAction();
                        begin
                            RollupAsmPrice;
                        end;
                    }
                    action("Roll Up &Cost")
                    {
                        AccessByPermission = TableData "BOM Component" = R;
                        Caption = 'Roll Up &Cost',
                                    Comment = 'ESM="Distribuir &costo"';
                        Ellipsis = true;

                        trigger OnAction();
                        begin
                            RollUpAsmCost;
                        end;
                    }
                }
                action(DeferralSchedule)
                {
                    Caption = 'Deferral Schedule',
                                Comment = 'ESM="Previsión fraccionamiento"';
                    Enabled = "Deferral Code" <> '';
                    Image = PaymentPeriod;

                    trigger OnAction();
                    begin
                        SalesHeader.GET("Document Type", "Document No.");
                        ShowDeferrals(SalesHeader."Posting Date", SalesHeader."Currency Code");
                    end;
                }
            }
            group("F&unctions")
            {
                Caption = 'F&unctions',
                            Comment = 'ESM="Acci&ones"';
                Image = "Action";
                action(ExplodeBOM_Functions)
                {
                    AccessByPermission = TableData "BOM Component" = R;
                    Caption = 'E&xplode BOM',
                                Comment = 'ESM="&Desplegar L.M."';
                    Image = ExplodeBOM;

                    trigger OnAction();
                    begin
                        ExplodeBOM;
                    end;
                }
                action("Insert Ext. Texts")
                {
                    AccessByPermission = TableData "Extended Text Header" = R;
                    Caption = 'Insert &Ext. Texts',
                                Comment = 'ESM="Insertar t&extos adicionales"';
                    Image = Text;

                    trigger OnAction();
                    begin
                        InsertExtendedText(true);
                    end;
                }
                action(Reserve)
                {
                    Caption = '&Reserve',
                                Comment = 'ESM="&Reserva"';
                    Ellipsis = true;
                    Image = Reserve;

                    trigger OnAction();
                    begin
                        FIND;
                        ShowReservation;
                    end;
                }
                action(OrderTracking)
                {
                    Caption = 'Order &Tracking',
                                Comment = 'ESM="&Seguimiento pedido"';
                    Image = OrderTracking;

                    trigger OnAction();
                    begin
                        ShowTracking;
                    end;
                }
                action("Nonstoc&k Items")
                {
                    AccessByPermission = TableData "Nonstock Item" = R;
                    Caption = 'Nonstoc&k Items',
                                Comment = 'ESM="Prods. no in&ventariables"';
                    Image = NonStockItem;

                    trigger OnAction();
                    begin
                        ShowNonstockItems;
                    end;
                }
            }
            group("O&rder")
            {
                Caption = 'O&rder',
                            Comment = 'ESM="&Pedido"';
                Image = "Order";
                group("Dr&op Shipment")
                {
                    Caption = 'Dr&op Shipment',
                                Comment = 'ESM="Enví&o directo"';
                    Image = Delivery;
                    action("Purchase &Order")
                    {
                        AccessByPermission = TableData "Purch. Rcpt. Header" = R;
                        Caption = 'Purchase &Order',
                                    Comment = 'ESM="Pedido de &compra"';
                        Image = Document;

                        trigger OnAction();
                        begin
                            OpenPurchOrderForm;
                        end;
                    }
                }
                group("Speci&al Order")
                {
                    Caption = 'Speci&al Order',
                                Comment = 'ESM="&Pedido especial"';
                    Image = SpecialOrder;
                    action(OpenSpecialPurchaseOrder)
                    {
                        AccessByPermission = TableData "Purch. Rcpt. Header" = R;
                        Caption = 'Purchase &Order',
                                    Comment = 'ESM="Pedido de &compra"';
                        Image = Document;

                        trigger OnAction();
                        begin
                            OpenSpecialPurchOrderForm;
                        end;
                    }
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord();
    begin
        if SalesHeader.GET("Document Type", "Document No.") then;

        DocumentTotals.SalesUpdateTotalsControls(Rec, TotalSalesHeader, TotalSalesLine, RefreshMessageEnabled,
          TotalAmountStyle, RefreshMessageText, InvDiscAmountEditable, CurrPage.EDITABLE, VATAmount);

        TypeChosen := HasTypeToFillMandatoryFields;
        SetLocationCodeMandatory;

        DisponibilidadInventario();
    end;

    trigger OnAfterGetRecord();
    begin
        ShowShortcutDimCode(ShortcutDimCode);
    end;

    trigger OnDeleteRecord(): Boolean;
    var
        ReserveSalesLine: Codeunit "Sales Line-Reserve";
    begin
        if (Quantity <> 0) and ItemExists("No.") then begin
            COMMIT;
            if not ReserveSalesLine.DeleteLineConfirm(Rec) then
                exit(false);
            ReserveSalesLine.DeleteLine(Rec);
        end;
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        InitType;
        CLEAR(ShortcutDimCode);

        Type := Type::Item;
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
        gCantDisponible: Integer;
        gTipo: Option Persona,"Máquina";
        Text001: Label 'You cannot use the Explode BOM function because a prepayment of the sales order has been invoiced.', Comment = 'ESM="No puede usar la función Desplegar L.M. puesto que se ha facturado un anticipo del pedido de venta."';

    procedure ApproveCalcInvDisc();
    begin
        CODEUNIT.RUN(CODEUNIT::"Sales-Disc. (Yes/No)", Rec);
    end;

    procedure CalcInvDisc();
    begin
        CODEUNIT.RUN(CODEUNIT::"Sales-Calc. Discount", Rec);
    end;

    procedure ExplodeBOM();
    begin
        if "Prepmt. Amt. Inv." <> 0 then
            ERROR(Text001);
        CODEUNIT.RUN(CODEUNIT::"Sales-Explode BOM", Rec);
    end;

    procedure OpenPurchOrderForm();
    var
        PurchHeader: Record "Purchase Header";
        PurchOrder: Page "Purchase Order";
    begin
        TESTFIELD("Purchase Order No.");
        PurchHeader.SETRANGE("No.", "Purchase Order No.");
        PurchOrder.SETTABLEVIEW(PurchHeader);
        PurchOrder.EDITABLE := false;
        PurchOrder.RUN;
    end;

    procedure OpenSpecialPurchOrderForm();
    var
        PurchHeader: Record "Purchase Header";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PurchOrder: Page "Purchase Order";
    begin
        TESTFIELD("Special Order Purchase No.");
        PurchHeader.SETRANGE("No.", "Special Order Purchase No.");
        if not PurchHeader.ISEMPTY then begin
            PurchOrder.SETTABLEVIEW(PurchHeader);
            PurchOrder.EDITABLE := false;
            PurchOrder.RUN;
        end else begin
            PurchRcptHeader.SETRANGE("Order No.", "Special Order Purchase No.");
            if PurchRcptHeader.COUNT = 1 then
                PAGE.RUN(PAGE::"Posted Purchase Receipt", PurchRcptHeader)
            else
                PAGE.RUN(PAGE::"Posted Purchase Receipts", PurchRcptHeader);
        end;
    end;

    procedure InsertExtendedText(Unconditionally: Boolean);
    begin
        if TransferExtendedText.SalesCheckIfAnyExtText(Rec, Unconditionally) then begin
            CurrPage.SAVERECORD;
            COMMIT;
            TransferExtendedText.InsertSalesExtText(Rec);
        end;
        if TransferExtendedText.MakeUpdate then
            UpdateForm(true);
    end;

    procedure ShowNonstockItems();
    begin
        ShowNonstock;
    end;

    procedure ShowTracking();
    var
        TrackingForm: Page "Order Tracking";
    begin
        TrackingForm.SetSalesLine(Rec);
        TrackingForm.RUNMODAL;
    end;

    procedure ItemChargeAssgnt();
    begin
        ShowItemChargeAssgnt;
    end;

    procedure UpdateForm(SetSaveRecord: Boolean);
    begin
        CurrPage.UPDATE(SetSaveRecord);
    end;

    procedure ShowPrices();
    begin
        SalesHeader.GET("Document Type", "Document No.");
        CLEAR(SalesPriceCalcMgt);
        SalesPriceCalcMgt.GetSalesLinePrice(SalesHeader, Rec);
    end;

    procedure ShowLineDisc();
    begin
        SalesHeader.GET("Document Type", "Document No.");
        CLEAR(SalesPriceCalcMgt);
        SalesPriceCalcMgt.GetSalesLineLineDisc(SalesHeader, Rec);
    end;

    procedure OrderPromisingLine();
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

    local procedure TypeOnAfterValidate();
    begin
        ItemPanelVisible := Type = Type::Item;
    end;

    local procedure NoOnAfterValidate();
    begin
        InsertExtendedText(false);
        if (Type = Type::"Charge (Item)") and ("No." <> xRec."No.") and
           (xRec."No." <> '')
        then
            CurrPage.SAVERECORD;

        SaveAndAutoAsmToOrder;

        if Reserve = Reserve::Always then begin
            CurrPage.SAVERECORD;
            if ("Outstanding Qty. (Base)" <> 0) and ("No." <> xRec."No.") then begin
                AutoReserve;
                CurrPage.UPDATE(false);
            end;
        end;
    end;

    local procedure CrossReferenceNoOnAfterValidat();
    begin
        InsertExtendedText(false);
    end;

    local procedure VariantCodeOnAfterValidate();
    begin
        SaveAndAutoAsmToOrder;
    end;

    local procedure LocationCodeOnAfterValidate();
    begin
        SaveAndAutoAsmToOrder;

        if (Reserve = Reserve::Always) and
           ("Outstanding Qty. (Base)" <> 0) and
           ("Location Code" <> xRec."Location Code")
        then begin
            CurrPage.SAVERECORD;
            AutoReserve;
            CurrPage.UPDATE(false);
        end;
    end;

    local procedure ReserveOnAfterValidate();
    begin
        if (Reserve = Reserve::Always) and ("Outstanding Qty. (Base)" <> 0) then begin
            CurrPage.SAVERECORD;
            AutoReserve;
            CurrPage.UPDATE(false);
        end;
    end;

    local procedure QuantityOnAfterValidate();
    var
        UpdateIsDone: Boolean;
    begin
        if Type = Type::Item then
            case Reserve of
                Reserve::Always:
                    begin
                        CurrPage.SAVERECORD;
                        AutoReserve;
                        CurrPage.UPDATE(false);
                        UpdateIsDone := true;
                    end;
                Reserve::Optional:
                    if (Quantity < xRec.Quantity) and (xRec.Quantity > 0) then begin
                        CurrPage.SAVERECORD;
                        CurrPage.UPDATE(false);
                        UpdateIsDone := true;
                    end;
            end;

        if (Type = Type::Item) and
           (Quantity <> xRec.Quantity) and
           not UpdateIsDone
        then
            CurrPage.UPDATE(true);
    end;

    local procedure QtyToAsmToOrderOnAfterValidate();
    begin
        CurrPage.SAVERECORD;
        if Reserve = Reserve::Always then
            AutoReserve;
        CurrPage.UPDATE(true);
    end;

    local procedure UnitofMeasureCodeOnAfterValida();
    begin
        if Reserve = Reserve::Always then begin
            CurrPage.SAVERECORD;
            AutoReserve;
            CurrPage.UPDATE(false);
        end;
    end;

    local procedure ShipmentDateOnAfterValidate();
    begin
        if (Reserve = Reserve::Always) and
           ("Outstanding Qty. (Base)" <> 0) and
           ("Shipment Date" <> xRec."Shipment Date")
        then begin
            CurrPage.SAVERECORD;
            AutoReserve;
            CurrPage.UPDATE(false);
        end;
    end;

    local procedure SaveAndAutoAsmToOrder();
    begin
        if (Type = Type::Item) and IsAsmToOrderRequired then begin
            CurrPage.SAVERECORD;
            AutoAsmToOrder;
            CurrPage.UPDATE(false);
        end;
    end;

    local procedure SetLocationCodeMandatory();
    var
        InventorySetup: Record "Inventory Setup";
    begin
        InventorySetup.GET;
        LocationCodeMandatory := InventorySetup."Location Mandatory" and (Type = Type::Item);
    end;

    local procedure RedistributeTotalsOnAfterValidate();
    begin
        CurrPage.SAVERECORD;

        SalesHeader.GET("Document Type", "Document No.");
        if DocumentTotals.SalesCheckNumberOfLinesLimit(SalesHeader) then
            DocumentTotals.SalesRedistributeInvoiceDiscountAmounts(Rec, VATAmount, TotalSalesLine);
        CurrPage.UPDATE;
    end;

    local procedure DisponibilidadInventario();
    begin
        gCantDisponible := 0;
        recItemLedgerEntry.SETRANGE(recItemLedgerEntry."Item No.", Rec."No.");
        recItemLedgerEntry.SETRANGE(recItemLedgerEntry."Location Code", Rec."Location Code");
        recItemLedgerEntry.SETRANGE(recItemLedgerEntry.Open, true);
        if recItemLedgerEntry.FINDSET then
            repeat
                gCantDisponible := gCantDisponible + recItemLedgerEntry."Remaining Quantity";
            until recItemLedgerEntry.NEXT = 0;
    end;

    local procedure fGetDimesionsResource();
    var
        lrResource: Record Resource;
        lcDefaultDimension: Record "Default Dimension";
        lcTempDimSetEntry: Record "Dimension Set Entry" temporary;
        lcDimv: Record "Dimension Value";
        DimMgt: Codeunit DimensionManagement;
    begin
        lcTempDimSetEntry.DELETEALL;

        lrResource.RESET;
        lrResource.SETRANGE(Type, gTipo);
        lrResource.SETRANGE("No.", "Resource No.");
        if lrResource.FINDSET then begin
            lcDefaultDimension.RESET;
            lcDefaultDimension.SETRANGE("Table ID", 156);
            lcDefaultDimension.SETRANGE("No.", "Resource No.");
            if lcDefaultDimension.FINDSET then
                repeat
                    lcTempDimSetEntry.INIT;
                    lcTempDimSetEntry.VALIDATE("Dimension Code", lcDefaultDimension."Dimension Code");
                    lcTempDimSetEntry.VALIDATE("Dimension Value Code", lcDefaultDimension."Dimension Value Code");
                    lcTempDimSetEntry.INSERT;
                until lcDefaultDimension.NEXT = 0;
            "Dimension Set ID" := DimMgt.GetDimensionSetID(lcTempDimSetEntry);
            VALIDATE("Dimension Set ID");
        end;
    end;
}

