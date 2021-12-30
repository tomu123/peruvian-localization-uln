page 51003 "Setup Localization"
{
    PageType = Card;
    ApplicationArea = All;
    Caption = 'Setup Localization', Comment = 'ESM="Configuración Localizado"';
    UsageCategory = Administration;
    SourceTable = "Setup Localization";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                Visible = true;

                field("ST GL Account Realized Gain"; Rec."ST GL Account Realized Gain")
                {
                    ApplicationArea = All;
                    trigger OnDrillDown()
                    begin
                        MasterData.Reset();
                        MasterData.FilterGroup(2);
                        MasterData.SetRange("Type Table", 'ADJ-TC-REF');
                        MasterData.SetRange("Type Table ref", 'ADJ-TC');
                        MasterData.SetRange("Code ref", Rec."ST GL Account Realized Gain");
                        MasterData.FilterGroup(0);
                        Clear(MDPage);
                        MDPage.SetDimensionDefault('ADJ-TC-REF', 'ADJ-TC', Rec."ST GL Account Realized Gain");
                        MDPage.SetTableView(MasterData);
                        MDPage.RunModal();
                    end;
                }
                field("ST GL Account Realized Loss"; Rec."ST GL Account Realized Loss")
                {
                    ApplicationArea = All;
                    trigger OnDrillDown()
                    begin
                        MasterData.Reset();
                        MasterData.FilterGroup(2);
                        MasterData.SetRange("Type Table", 'ADJ-TC-REF');
                        MasterData.SetRange("Type Table ref", 'ADJ-TC');
                        MasterData.SetRange("Code ref", Rec."ST GL Account Realized Loss");
                        MasterData.FilterGroup(0);
                        Clear(MDPage);
                        MDPage.SetDimensionDefault('ADJ-TC-REF', 'ADJ-TC', Rec."ST GL Account Realized Loss");
                        MDPage.SetTableView(MasterData);
                        MDPage.RunModal();
                    end;
                }
                field("ST Adj. Exch. Dflt. Dim. Bank"; Rec."ST Adj. Exch. Dflt. Dim. Bank")
                {
                    ApplicationArea = All;
                    trigger OnDrillDown()
                    var
                        QtyDimDescription: Text;
                    begin
                        MasterData.Reset();
                        MasterData.FilterGroup(2);
                        MasterData.SetRange("Type Table", 'ADJ-TC-REF');
                        MasterData.SetRange("Type Table ref", 'ADJ-TC');
                        MasterData.SetRange("Code ref", 'BANK-ADJTC');
                        MasterData.FilterGroup(0);
                        Clear(MDPage);
                        MDPage.SetDimensionDefault('ADJ-TC-REF', 'ADJ-TC', 'BANK-ADJTC');
                        MDPage.SetTableView(MasterData);
                        MDPage.RunModal();
                        UpdateDescription();
                        CurrPage.Update(true);
                    end;
                }
                field("ST Coactiva No. Serie"; Rec."ST Coactiva No. Serie")
                {
                    ApplicationArea = All;
                }
                field("ST Enabled Reverse"; "ST Enabled Reverse")
                {
                    ApplicationArea = All;
                }
                field("ST Show Error Consistent"; "ST Show Error Consistent")
                {
                    ApplicationArea = All;
                }
                group(AdjustExchangeRateLoc)
                {
                    Caption = 'Adjust Exchange Rates';
                    field("Adj. Exch. Rate Localization"; Rec."Adj. Exch. Rate Localization")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Utiliza el desarrollo localizado en referencia al tipo de ajuste pasivo o activo de los grupos contables.';
                        trigger
                        OnValidate()
                        begin
                            if Rec."Adj. Exch. Rate Localization" then
                                gAdjExchRateLocEditable := true
                            else
                                gAdjExchRateLocEditable := false;
                        end;
                    }
                    field("Adj. Exch. Rate Doc. Pstg Gr"; Rec."Adj. Exch. Rate Doc. Pstg Gr")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Hace el ajuste con el grupo contable del documento, el estandar utiliza el grupo contable configurado en el ficha de maestros, cliente, proveedor, banco. Segun corresponda.';
                        Editable = gAdjExchRateLocEditable;
                    }
                    field("Adj. Exch. Rate Ref. Document"; Rec."Adj. Exch. Rate Ref. Document")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Hace el ajuste por tipo de cambio agrupando por documento, el estandar los agrupa por Cliente, Proveedor, Banco, etc.';
                        Editable = gAdjExchRateLocEditable;
                    }
                }
                field("Validate Curr. Exch. Posting"; "Validate Curr. Exch. Posting")
                {
                    ApplicationArea = All;
                }
            }
            group(ControlCUO)
            {
                Caption = 'Control CUO', Comment = 'ESM="Control CUO"';
                field("Enabled Posting (CUO)"; "Enabled Posting (CUO)")
                {
                    ApplicationArea = All;
                }
                field("Type control posting CUO"; "Type control posting CUO")
                {
                    ApplicationArea = All;
                }
                field("Type control filter CUO"; "Type control filter CUO")
                {
                    ApplicationArea = All;
                }
                field("Quantity characters Corr. CUO"; "Quantity characters Corr. CUO")
                {
                    ApplicationArea = All;
                }
                field("User Id. CUO Administrator"; "User Id. CUO Administrator")
                {
                    ApplicationArea = All;
                }
            }
            group(ULNServices)
            {
                Caption = 'ULN Services', Comment = 'ESM="Servicios ULN"';
                group(ConsultRuc)
                {
                    Caption = 'Consult Ruc', Comment = 'ESM="Consulta RUC"';
                    field("Create Option Vendor"; Rec."Create Option Vendor")
                    {
                        ApplicationArea = All;
                    }
                    field("Vendor MN Template Code"; Rec."Vendor MN Template Code")
                    {
                        ApplicationArea = All;
                    }
                    field("Vendor ME Template Code"; Rec."Vendor ME Template Code")
                    {
                        ApplicationArea = All;
                    }
                    field("Vendor Ext Template Code"; Rec."Vendor Ext Template Code")
                    {
                        ApplicationArea = All;
                    }
                    field("Create Option Customer"; Rec."Create Option Customer")
                    {
                        ApplicationArea = All;
                    }
                    field("Customer MN Template Code"; Rec."Customer MN Template Code")
                    {
                        ApplicationArea = All;
                    }
                    field("Customer ME Template Code"; Rec."Customer ME Template Code")
                    {
                        ApplicationArea = All;
                    }
                    field("Customer Ext Template Code"; Rec."Customer Ext Template Code")
                    {
                        ApplicationArea = All;
                    }
                }
                group(ConsultTC)
                {
                    Caption = 'Consult TC', Comment = 'ESM="Consultar Tipo de cambio"';
                    field("ST URL Service Consulta TC"; "ST URL Service Consulta TC")
                    {
                        ApplicationArea = All;
                    }
                }
            }
            group(Retention)
            {
                Caption = 'Retention', Comment = 'ESM="Retención"';
                field("Retention Agent Option"; Rec."Retention Agent Option")
                {
                    ApplicationArea = All;
                }
                field("Regime Retention Code"; Rec."Regime Retention Code")
                {
                    ApplicationArea = All;
                }
                field("Retention Percentage %"; Rec."Retention Percentage %")
                {
                    ApplicationArea = All;
                }
                field("Retention Limit Amount"; Rec."Retention Limit Amount")
                {
                    ApplicationArea = All;
                }
                field("Retention G/L Account No."; Rec."Retention G/L Account No.")
                {
                    ApplicationArea = All;
                }
                field("Max. Line. Retention Report"; Rec."Max. Line. Retention Report")
                {
                    ApplicationArea = All;
                }
                field("Retention Physical Nos"; Rec."Retention Physical Nos")
                {
                    ApplicationArea = All;
                }
                field("Retention Electronic Nos"; Rec."Retention Electronic Nos")
                {
                    ApplicationArea = All;
                }
                field("Retention Resolution Number"; Rec."Retention Resolution Number")
                {
                    ApplicationArea = All;
                }
            }
            group(RHRetention)
            {
                Caption = 'RH Retntion', Comment = 'ESM="Retención recibo por honorario"';
                field("Retention RH Nos"; Rec."Retention RH Nos")
                {
                    ApplicationArea = All;
                    Caption = 'Serie Nos', Comment = 'ESM="N° Serie"';
                }
                field("Retention RH Posted Nos"; Rec."Retention RH Posted Nos")
                {
                    ApplicationArea = All;
                    Caption = 'Posted Serie Nos', Comment = 'ESM="N° Serie Registro"';
                }
                field("Retention RH GLAcc. No."; Rec."Retention RH GLAcc. No.")
                {
                    ApplicationArea = All;
                    Caption = 'G/L Account No.', Comment = 'ESM="N° Cuenta"';
                }
                field("Ret. RH VAT Prod Pstg. Gr. Ex."; Rec."Ret. RH VAT Prod Pstg. Gr. Ex.")
                {
                    ApplicationArea = All;
                    Caption = 'VAT Prod. Pstg. Group Ex.', Comment = 'ESM="Gr. reg. IVA Producto exonerado"';
                    ToolTip = 'VAT Product Posting Group Exonerated', Comment = 'ESM="Grupo registro IVA Producto exonerado"';
                }
                field("Retention RH %"; Rec."Retention RH %")
                {
                    ApplicationArea = All;
                    Caption = 'Retention %', Comment = 'ESM="% Retención"';
                }
                field("Retention RH Limit Amount"; Rec."Retention RH Limit Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Limit Amount', Comment = 'ESM="Importe minimo"';
                }
                field("Retention RH Validate Pre-Post"; Rec."Retention RH Validate Pre-Post")
                {
                    ApplicationArea = All;
                    Caption = 'Validate Pre-Post', Comment = 'ESM="Valida pre-registro"';
                    ToolTip = 'Validate record in pre posting process.', Comment = 'ESM="Realiza la validación previa al registro del documento."';
                }
            }
            group(Detrac)
            {
                Caption = 'Detractions', Comment = 'ESM="Detracciones"';
                field("Detraction Posting Group"; Rec."Detraction Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Detraction Vendor"; Rec."Detraction Vendor")
                {
                    ApplicationArea = All;
                }
                field("Correlative SUNAT"; Rec."Correlative SUNAT")
                {
                    ApplicationArea = All;
                }
                field("Lot Number Detraction"; Rec."Lot Number Detraction")
                {
                    ApplicationArea = All;
                }
                field("SUNAT Generation Date"; Rec."SUNAT Generation Date")
                {
                    ApplicationArea = All;
                }
                field("Detraction Route Export"; Rec."Detraction Route Export")
                {
                    ApplicationArea = All;
                }
                field("realized Losses Acc."; Rec."Realized Losses Acc.")
                {
                    ApplicationArea = All;
                    trigger OnDrillDown()
                    begin
                        MasterData.Reset();
                        MasterData.FilterGroup(2);
                        MasterData.SetRange("Type Table", 'ADJ-TC-REF');
                        MasterData.SetRange("Type Table ref", 'ADJ-TC');
                        MasterData.SetRange("Code ref", Rec."Realized Losses Acc.");
                        MasterData.FilterGroup(0);
                        Clear(MDPage);
                        MDPage.SetDimensionDefault('ADJ-TC-REF', 'ADJ-TC', Rec."Realized Losses Acc.");
                        MDPage.SetTableView(MasterData);
                        MDPage.RunModal();
                    end;
                }
                field("Unrealized Gains Acc."; Rec."Realized Gains Acc.")
                {
                    ApplicationArea = All;
                    trigger OnDrillDown()
                    begin
                        MasterData.Reset();
                        MasterData.FilterGroup(2);
                        MasterData.SetRange("Type Table", 'ADJ-TC-REF');
                        MasterData.SetRange("Type Table ref", 'ADJ-TC');
                        MasterData.SetRange("Code ref", Rec."Realized Gains Acc.");
                        MasterData.FilterGroup(0);
                        Clear(MDPage);
                        MDPage.SetDimensionDefault('ADJ-TC-REF', 'ADJ-TC', Rec."Realized Gains Acc.");
                        MDPage.SetTableView(MasterData);
                        MDPage.RunModal();
                    end;
                }
            }
            group(FreeTitle)
            {
                Caption = 'Free tile', Comment = 'ESM="Título gratuito"';
                field("FT Free Title"; Rec."FT Free Title")
                {
                    ApplicationArea = All;
                    trigger
                    OnValidate()
                    begin
                        if Rec."FT Free Title" then
                            gFTFreeTitleEditable := true
                        else
                            gFTFreeTitleEditable := false;
                    end;
                }
                field("FT Gen. Bus. Posting Group"; Rec."FT Gen. Bus. Posting Group")
                {
                    ApplicationArea = All;
                    Editable = gFTFreeTitleEditable;
                }
                field("FT VAT Prod. Posting Group"; Rec."FT VAT Prod. Posting Group")
                {
                    ApplicationArea = All;
                    Editable = gFTFreeTitleEditable;
                }
                field("FT VAT Bus. Posting Group"; Rec."FT VAT Bus. Posting Group")
                {
                    ApplicationArea = All;
                    Editable = gFTFreeTitleEditable;
                }
            }
            group(Import)
            {
                Caption = 'Importation', Comment = 'ESM="Importación"';
                field("Importation No. Series"; Rec."Importation No. Series")
                {
                    ApplicationArea = All;
                }
                field("Importation Vendor No."; Rec."Importation Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("DUA Vendor No."; Rec."DUA Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("Freight Vendor No."; Rec."Freight Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("Other Vendor No. 1"; Rec."Other Vendor No. 1")
                {
                    ApplicationArea = All;
                }
                field("Other Vendor No. 2"; Rec."Other Vendor No. 2")
                {
                    ApplicationArea = All;
                }
                field("Handling Vendor No."; Rec."Handling Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("Insurance Vendor No."; Rec."Insurance Vendor No.")
                {
                    ApplicationArea = All;
                }
            }
            group("Internal Consumption")
            {
                Caption = 'Internal Consumption', Comment = 'ESM="Consumo Interno"';
                field("Cust. Acc. Group Int. Cons."; Rec."Cust. Acc. Group Int. Cons.")
                {
                    ApplicationArea = All;
                }
                field("Gn. Bus. Pst. Group Int. Cons."; Rec."Gn. Bus. Pst. Group Int. Cons.")
                {
                    ApplicationArea = All;
                }
                field("Customer Int. Cons."; Rec."Customer Int. Cons.")
                {
                    ApplicationArea = All;
                }
                field("Serial No. Int. Cons."; Rec."Serial No. Int. Cons.")
                {
                    ApplicationArea = All;
                }
                field("Serial No. Pstd. Int. Cons."; Rec."Serial No. Pstd. Int. Cons.")
                {
                    ApplicationArea = All;
                }
                field("Shipment Serial No."; Rec."Shipment Serial No.")
                {
                    ApplicationArea = All;
                }
                field("Serial No. Int. Cons. Rtn"; "Serial No. Int. Cons. Rtn")
                {
                    ApplicationArea = All;
                }
                field("Serial No. Pstd. Int.Cons. Rtn"; "Serial No. Pstd. Int.Cons. Rtn")
                {
                    ApplicationArea = All;
                }
                field("Return Shipment Serial No."; "Return Shipment Serial No.")
                {
                    ApplicationArea = All;
                }
                field("For Code"; Rec."For Code")
                {
                    ApplicationArea = All;
                }
            }
            group(AccountantBookSetup)
            {
                Caption = 'Setup Accountant Book', Comment = 'ESM="Conf. Libros contables"';
                field("AB Field reference purch. book"; Rec."AB Field reference purch. book")
                {
                    ApplicationArea = All;
                }
            }
            group(Telecredit)
            {
                Caption = 'Analityc', Comment = 'ESM="Telecreditos"';
                field("Telecredit New Version"; Rec."Telecredit New Version")
                {
                    ApplicationArea = All;
                }
            }
            group(AnalitycGroup)
            {
                Caption = 'Analityc', Comment = 'ESM="Analítica"';
                field("Analityc Global Dimension"; Rec."Analityc Global Dimension")
                {
                    ApplicationArea = All;
                }
            }
            group(Advanced)
            {
                Caption = 'Advanced', Comment = 'ESM="Anticipo"';
                field("Account Advanced PEN"; "Account Advanced PEN")
                {
                    ApplicationArea = All;
                }
                field("Account Advanced USD"; "Account Advanced USD")
                {
                    ApplicationArea = All;
                }
                field("Dimension Advanced"; "Dimension Advanced")
                {
                    ApplicationArea = All;
                }
                field("Advanced Unit of Measure"; "Advanced Unit of Measure")
                {
                    ApplicationArea = All;
                }
            }
            group(ReconciliationSetup)
            {
                Caption = 'Reconciliation Setup', Comment = 'ESM="Conf. Rever. Conciliación Cobro"';
                field("RB Journal Template Name"; "RB Journal Template Name")
                {
                    ApplicationArea = All;
                }
                field("RB Journal Batch Name"; "RB Journal Batch Name")
                {
                    ApplicationArea = All;
                }
            }
            group(FixedAssets)
            {
                Caption = 'Fixed Assets', Comment = 'ESM="Activo Fijo"';
                field("Book Amortization Accounting"; Rec."Book Amortization Accounting")
                {
                    ApplicationArea = All;
                }
                field("Book Amortization tributary"; Rec."Book Amortization tributary")
                {
                    ApplicationArea = All;
                }

                group("Industrial Seat")
                {
                    Caption = 'Industrial Seat', Comment = 'ESM="Asiento industrial"';
                    field("ST Industrial Template"; "ST Industrial Template")
                    {
                        ApplicationArea = All;
                    }
                    field("ST Industrial Batch Name"; "ST Industrial Batch Name")
                    {
                        ApplicationArea = All;
                    }
                }
            }
            group("Regularization seat")
            {
                Caption = 'Regularization seat', Comment = 'ESM="Asiento de Regularización"';
                field("Register Regularization"; "Register Regularization")
                {
                    ApplicationArea = All;
                    ToolTip = 'Si la opción esta habilitada se registra de manera estandar , caso contrario se aplicara logica del localizado ';
                }
            }
            group("Open&Closed")
            {
                Caption = 'Open&Closed', Comment = 'ESM="Asiento de Cierre / Apertura"';
                field("Journal Batch Name Open"; "Journal Batch Name Open")
                {
                    ApplicationArea = All;
                }
                field("Journal Batch Name Closed"; "Journal Batch Name Closed")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(MasterData)
            {
                ApplicationArea = All;
                Caption = 'Master Data', Comment = 'ESM="Maestro Datos"';
                Image = Setup;
                RunObject = page "Master Data";
            }

            action(Analityc)
            {
                Caption = 'Manual Analityc', Comment = 'ESM="Analítica Manual"';
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = Process;

                trigger OnAction()
                var
                    AnalitycMgt: Codeunit "Analitycs Management";
                begin
                    AnalitycMgt.ReassignAnalitycsAccounts();
                end;
            }

            action(Test0001)
            {
                ApplicationArea = All;
                Visible = false;
                trigger OnAction()
                var
                    CodeText: Code[20];
                    ResponseEncript: Text;
                    Record36: record 352;
                    Codeunit1: Codeunit 2;
                begin
                    CodeText := 'Renato';
                    if not EncryptionKeyExists() then
                        CreateEncryptionKey();
                    ResponseEncript := Encrypt(CodeText);
                    Message(ResponseEncript);

                    ResponseEncript := Decrypt('NojehoUcBaEggeqxWyyXxrig/0YJ1Ej1HXPtgdUKwx6vcAtBxsBxHubLHy4JWGSTf61jIwK4DHl0Hju+v22S3jQIYExf9dj3P3D5mI+rplzhF39XCnI4j9PK7Z7cG50TXxW2RSxA6/J6yObyVDQtFw8lFvlW3LyPDOmKksblq63FrOow51/1xQJUwAjfWbXP3oQmXOr1Qa/2FZsQT/qQrvlwxzpTisz8WZPhv0P9mDZJNTGSLeYsWrlVjG39U/fe3ss5MXuoVClR9sgxy0DRxXZtHEdh2qH3SzuK3yNJc+yqdWKUtG/GLsUREshdtfYApJSlIB6rZhl+C24C8VE5rQ==');
                    Message(ResponseEncript);
                end;
            }
            action(ExportEncriptionKey)
            {
                ApplicationArea = All;
                Visible = false;
                trigger OnAction()
                var
                    CodeText: Code[20];
                    ResponseEncript: Text;
                    Record36: record 352;
                    Codeunit1: Codeunit 2;
                begin
                    CodeText := 'Renato';
                    if not EncryptionKeyExists() then
                        CreateEncryptionKey();
                    ResponseEncript := Encrypt(CodeText);
                    Message(ResponseEncript);

                    ResponseEncript := Decrypt('NojehoUcBaEggeqxWyyXxrig/0YJ1Ej1HXPtgdUKwx6vcAtBxsBxHubLHy4JWGSTf61jIwK4DHl0Hju+v22S3jQIYExf9dj3P3D5mI+rplzhF39XCnI4j9PK7Z7cG50TXxW2RSxA6/J6yObyVDQtFw8lFvlW3LyPDOmKksblq63FrOow51/1xQJUwAjfWbXP3oQmXOr1Qa/2FZsQT/qQrvlwxzpTisz8WZPhv0P9mDZJNTGSLeYsWrlVjG39U/fe3ss5MXuoVClR9sgxy0DRxXZtHEdh2qH3SzuK3yNJc+yqdWKUtG/GLsUREshdtfYApJSlIB6rZhl+C24C8VE5rQ==');
                    Message(ResponseEncript);
                end;
            }
            action(LastConsistentError)
            {
                ApplicationArea = All;
                Caption = 'Last Consistent Error';
                Image = ErrorFALedgerEntries;
                Enabled = "ST Show Error Consistent";

                trigger OnAction()
                var
                    Code55000: Codeunit 55000;
                begin
                    Code55000.Run();
                end;
            }
            action(ConsultarTipoCambio)
            {
                ApplicationArea = All;
                Caption = 'Consultar Tipo de cambio';
                Image = ErrorFALedgerEntries;

                trigger OnAction()
                var
                    CurrencyTypeMgt: Codeunit "Consulta TC Mgt.";
                begin
                    Clear(CurrencyTypeMgt);
                    CurrencyTypeMgt.SetParameters('USD', 0D);
                    CurrencyTypeMgt.SetStartDate();
                    CurrencyTypeMgt.GetCurrencyAmount()
                end;
            }
        }
    }

    var
        MasterData: Record "Master Data";
        MDPage: Page "Master Data";
        Record81: Record 81;
        DimDescription: Label 'This setup %1 %2.', Comment = 'ESM="Se configuró %1 %2"';
        gAdjExchRateLocEditable: Boolean;
        gFTFreeTitleEditable: Boolean;

    local procedure UpdateDescription()
    var
        QtyDim: Integer;
    begin
        //-------------------
        MasterData.Reset();
        MasterData.FilterGroup(2);
        MasterData.SetRange("Type Table", 'ADJ-TC-REF');
        MasterData.SetRange("Type Table ref", 'ADJ-TC');
        MasterData.SetRange("Code ref", 'BANK-ADJTC');
        QtyDim := MasterData.Count;
        if QtyDim = 1 then
            Rec."ST Adj. Exch. Dflt. Dim. Bank" := StrSubstNo(DimDescription, QtyDim, 'dimensión')
        else
            Rec."ST Adj. Exch. Dflt. Dim. Bank" := StrSubstNo(DimDescription, QtyDim, 'dimensines');
    end;
}
