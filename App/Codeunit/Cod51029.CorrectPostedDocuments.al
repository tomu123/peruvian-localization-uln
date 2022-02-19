codeunit 51029 "LD Correct Posted Documents"
{
    trigger OnRun()
    begin

    end;

    //******************************************** Begin Sales *****************************************************
    [IntegrationEvent(false, false)]
    local procedure OnAfterCorrectInvoice(var SalesHeader: Record "Sales Header")
    begin

    end;

    procedure SalesCorrectInvoice(var pSalesInvoiceHeader: Record "Sales Invoice Header"): Boolean
    var
        SalesHeader: Record "Sales Header";
    begin
        if pSalesInvoiceHeader."Legal Status" = pSalesInvoiceHeader."Legal Status"::OutFlow then
            Error('El documento ya esta extornando');

        if pSalesInvoiceHeader."Legal Status" = pSalesInvoiceHeader."Legal Status"::Anulled then begin
            if not Confirm('¿Desea corregir el Documento %1?', false, pSalesInvoiceHeader."No.") then
                exit(false);
            pSalesInvoiceHeader."Legal Status" := pSalesInvoiceHeader."Legal Status"::OutFlow;
            pSalesInvoiceHeader.Modify();
            RenameSalesDocument(Database::"Sales Invoice Header", pSalesInvoiceHeader."No.");
        end else begin
            CheckPostedSalesInvoiceForCorrectCancel(pSalesInvoiceHeader);
            if not Confirm('¿Desea corregir el Documento %1?', false, pSalesInvoiceHeader."No.") then
                exit(false);

            CreateCreditMemoFromPostedSalesinvoice(SalesHeader, pSalesInvoiceHeader, SalesHeader."Legal Status"::OutFlow);
            Codeunit.Run(Codeunit::"Sales-Post", SalesHeader);
            RenameSalesDocument(Database::"Sales Invoice Header", pSalesInvoiceHeader."No.");
        end;
    end;

    procedure SalesCancelInvoice(var pSalesInvoiceHeader: Record "Sales Invoice Header"): Boolean
    var
        SalesHeader: Record "Sales Header";
    begin
        if pSalesInvoiceHeader."Legal Status" = pSalesInvoiceHeader."Legal Status"::OutFlow then
            Error('El documento ya esta extornando');

        if pSalesInvoiceHeader."Legal Status" = pSalesInvoiceHeader."Legal Status"::Anulled then begin
            if not Confirm('¿Desea corregir el Documento %1?', false, pSalesInvoiceHeader."No.") then
                exit(false);
            RenameSalesDocument(Database::"Sales Invoice Header", pSalesInvoiceHeader."No.");
        end else begin
            CheckPostedSalesInvoiceForCorrectCancel(pSalesInvoiceHeader);
            if not Confirm('¿Desea anular el Documento %1?', false, pSalesInvoiceHeader."No.") then
                exit(false);

            CreateCreditMemoFromPostedSalesinvoice(SalesHeader, pSalesInvoiceHeader, SalesHeader."Legal Status"::Anulled);
            Codeunit.Run(Codeunit::"Sales-Post", SalesHeader);
            RenameSalesDocument(Database::"Sales Invoice Header", pSalesInvoiceHeader."No.");
        end;
    end;

    procedure SalesCorrectCreditMemo(var pSalesCrMemoHdr: Record "Sales Cr.Memo Header"): Boolean
    var
        SalesHeader: Record "Sales Header";
    begin
        pSalesCrMemoHdr.TestField("Legal Status", pSalesCrMemoHdr."Legal Status"::Success);
        CheckOpenItemLedgerEntryInDocuments(Database::"Sales Cr.Memo Header", pSalesCrMemoHdr."No.", pSalesCrMemoHdr."Posting Date");
        CheckPostedSalesCrMemoForCorrectCancel(pSalesCrMemoHdr);
        if not Confirm('¿Desea corregir el Documento %1?', false, pSalesCrMemoHdr."No.") then
            exit(false);

        CreateSalesInvoiceFromPostedSalesCrMemo(SalesHeader, pSalesCrMemoHdr, SalesHeader."Legal Status"::OutFlow);
        Codeunit.Run(Codeunit::"Sales-Post", SalesHeader);
        RenameSalesDocument(Database::"Sales Cr.Memo Header", pSalesCrMemoHdr."No.");
    end;

    procedure SalesCancelCreditMemo(var pSalesCrMemoHdr: Record "Sales Cr.Memo Header"): Boolean
    var
        SalesHeader: Record "Sales Header";
    begin
        pSalesCrMemoHdr.TestField("Legal Status", pSalesCrMemoHdr."Legal Status"::Success);
        CheckOpenItemLedgerEntryInDocuments(Database::"Sales Cr.Memo Header", pSalesCrMemoHdr."No.", pSalesCrMemoHdr."Posting Date");
        CheckPostedSalesCrMemoForCorrectCancel(pSalesCrMemoHdr);
        if not Confirm('¿Desea anular el Documento %1?', false, pSalesCrMemoHdr."No.") then
            exit(false);

        CreateSalesInvoiceFromPostedSalesCrMemo(SalesHeader, pSalesCrMemoHdr, SalesHeader."Legal Status"::Anulled);
        Codeunit.Run(Codeunit::"Sales-Post", SalesHeader);
        RenameSalesDocument(Database::"Sales Cr.Memo Header", pSalesCrMemoHdr."No.");
    end;

    local procedure CheckPostedSalesInvoiceForCorrectCancel(pSalesInvoiceHeader: Record "Sales Invoice Header")
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        CustLedgerEntry2: Record "Cust. Ledger Entry";
        DtldCustLdgEntry: Record "Detailed Cust. Ledg. Entry";
        NumToApply: Integer;
    begin
        NumToApply := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange("Document Type", CustLedgerEntry."Document Type"::Invoice);
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", pSalesInvoiceHeader."Sell-to Customer No.");
        CustLedgerEntry.SetRange(CustLedgerEntry."Posting Date", pSalesInvoiceHeader."Posting Date");
        CustLedgerEntry.SetRange(CustLedgerEntry."Document No.", pSalesInvoiceHeader."No.");
        CustLedgerEntry.SetAutoCalcFields("Remaining Amount");
        if CustLedgerEntry.FindSet() then begin
            DtldCustLdgEntry.Reset();
            DtldCustLdgEntry.SetCurrentKey("Cust. Ledger Entry No.", "Entry Type");
            DtldCustLdgEntry.SetRange("Cust. Ledger Entry No.", CustLedgerEntry."Entry No.");
            DtldCustLdgEntry.SetRange("Entry Type", DtldCustLdgEntry."Entry Type"::Application);
            if DtldCustLdgEntry.FindSet() then
                repeat
                    if not DtldCustLdgEntry.Unapplied then
                        NumToApply += 1
                    else begin
                        CustLedgerEntry2.Reset();
                        CustLedgerEntry2.SetRange("Entry No.", DtldCustLdgEntry."Applied Cust. Ledger Entry No.");
                        CustLedgerEntry2.SetRange(Open, true);
                        if CustLedgerEntry2.FindSet() and (CustLedgerEntry2."Document No." = pSalesInvoiceHeader."No.") then
                            Error('Existe un pago desliquidado por revertir!');
                    end;
                until DtldCustLdgEntry.Next() = 0;
            if NumToApply <> 0 then
                Error('Hay %1 documentos por desliquidar', NumToApply);
        end;
    end;

    local procedure CheckPostedSalesCrMemoForCorrectCancel(pSalesCrMemoHdr: Record "Sales Cr.Memo Header")
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        CustLedgerEntry2: Record "Cust. Ledger Entry";
        DtldCustLdgEntry: Record "Detailed Cust. Ledg. Entry";
        NumToApply: Integer;
    begin
        NumToApply := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange("Document Type", CustLedgerEntry."Document Type"::Invoice);
        CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", pSalesCrMemoHdr."Sell-to Customer No.");
        CustLedgerEntry.SetRange(CustLedgerEntry."Posting Date", pSalesCrMemoHdr."Posting Date");
        CustLedgerEntry.SetRange(CustLedgerEntry."Document No.", pSalesCrMemoHdr."No.");
        CustLedgerEntry.SetAutoCalcFields("Remaining Amount");
        if CustLedgerEntry.FindSet() then begin
            DtldCustLdgEntry.Reset();
            DtldCustLdgEntry.SetCurrentKey("Cust. Ledger Entry No.", "Entry Type");
            DtldCustLdgEntry.SetRange("Cust. Ledger Entry No.", CustLedgerEntry."Entry No.");
            DtldCustLdgEntry.SetRange("Entry Type", DtldCustLdgEntry."Entry Type"::Application);
            if DtldCustLdgEntry.FindSet() then
                repeat
                    if not DtldCustLdgEntry.Unapplied then
                        NumToApply += 1;
                /*else begin
                    CustLedgerEntry2.Reset();
                    CustLedgerEntry2.SetRange("Entry No.", DtldCustLdgEntry."Applied Cust. Ledger Entry No.");
                    CustLedgerEntry2.SetRange(Open, true);
                    if CustLedgerEntry2.FindSet() and (CustLedgerEntry2."Document No." = pSalesCrMemoHdr."No.") then
                        Error('Existe un pago desliquidado por revertir!');
                end;*/
                until DtldCustLdgEntry.Next() = 0;
            if NumToApply <> 0 then
                Error('Hay %1 documentos por desliquidar', NumToApply);
        end;
    end;

    local procedure CreateSalesInvoiceFromPostedSalesCrMemo(var SalesHeader: Record "Sales Header"; pSalesCrMemoHdr: Record "Sales Cr.Memo Header"; LegalStatus: Option Succes,Anulled,OutFlow)
    var
        SalesSetup: Record "Sales & Receivables Setup";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        ItemLedgEntry: Record "Item Ledger Entry";
        ValueEntry: Record "Value Entry";
        SalesLine: Record "Sales Line";
        ReservStatus: Enum "Reservation Status";
        NoSerieMgt: Codeunit NoSeriesManagement;
        CreateReserveEntry: Codeunit "Create Reserv. Entry";
        NextDocumentNo: Code[20];
        Item: Record Item;
        NoSerie: Record "No. Series";
    begin

        NoSerie.Reset();
        NoSerie.SetRange("Operation Type", NoSerie."Operation Type"::Sales);
        NoSerie.SetRange("Legal Document", '01');
        NoSerie.SetRange("Legal Status", NoSerie."Legal Status"::OutFlow);
        NoSerie.SetRange("Internal Operation", true);
        if NoSerie.FindSet() then;

        SalesSetup.Get();
        SalesSetup.TestField("Invoice Nos.");
        //SalesSetup.TestField("Posted Prepmt. Inv. Nos.");
        SalesSetup.TestField("Posted Return Receipt Nos.");
        SalesSetup.TestField("Posted Invoice Nos.");
        SalesHeader.Init();
        SalesHeader.TransferFields(pSalesCrMemoHdr, false);
        SalesHeader.Validate("Sell-to Customer No.", pSalesCrMemoHdr."Sell-to Customer No.");
        SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
        NextDocumentNo := NoSerieMgt.GetNextNo(SalesSetup."Invoice Nos.", WorkDate(), true);
        SalesHeader."No." := NextDocumentNo;
        SalesHeader.Status := SalesHeader.Status::Open;
        SalesHeader."Posting No. Series" := NoSerie.Code;
        SalesHeader.Validate("Legal Status", LegalStatus);
        SalesHeader."Legal Document" := '01';
        SalesHeader."Responsibility Center" := pSalesCrMemoHdr."Responsibility Center";
        SalesHeader.Validate("Legal Document", '01');
        SalesHeader.Validate("Applies-to Doc. Type", SalesHeader."Applies-to Doc. Type"::"Credit Memo");
        SalesHeader.Validate("Applies-to Doc. No.", pSalesCrMemoHdr."No.");
        SalesHeader."Posting Description" := 'Nota de Credito a Factura :' + SalesHeader."No.";
        SalesHeader.Validate("Shipping No. Series", SalesSetup."Posted Shipment Nos.");
        //SalesHeader."Applies-to Document Date Ref." := pSalesCrMemoHdr."Posting Date"; //FMM 07.02.22
        SalesHeader.Insert();
        SalesHeader.Validate("Customer Posting Group", pSalesCrMemoHdr."Customer Posting Group");
        SalesHeader."Currency Code" := pSalesCrMemoHdr."Currency Code";
        SalesHeader.Validate("Applies-to Document Date Ref.", pSalesCrMemoHdr."Applies-to Document Date Ref.");
        SalesHeader.Modify();

        SalesCrMemoLine.Reset();
        SalesCrMemoLine.SetRange("Document No.", pSalesCrMemoHdr."No.");
        SalesCrMemoLine.SetFilter(Type, '<>%1', SalesCrMemoLine.Type::" ");
        if SalesCrMemoLine.FindFirst() then
            repeat
                SalesLine.Init();
                SalesLine."Document Type" := SalesLine."Document Type"::Invoice;
                SalesLine."Document No." := NextDocumentNo;
                SalesLine."Line No." := SalesCrMemoLine."Line No.";
                SalesLine.Type := SalesCrMemoLine.Type;
                SalesLine.Validate("No.", SalesCrMemoLine."No.");
                SalesLine.Validate(Quantity, SalesCrMemoLine.Quantity);
                SalesLine.Validate("Unit Price", SalesCrMemoLine."Unit Price");
                SalesLine.Validate("Gen. Prod. Posting Group", SalesCrMemoLine."Gen. Prod. Posting Group");
                if SalesCrMemoLine.Type = SalesCrMemoLine.Type::Item then begin
                    Item.Get(SalesLine."No.");
                    if Item.Type = Item.Type::Inventory then begin
                        SalesLine.Validate("Location Code", SalesCrMemoLine."Location Code");
                        SalesLine.Validate("Bin Code", SalesCrMemoLine."Bin Code");
                        ValueEntry.Reset();
                        ValueEntry.SetRange("Document No.", SalesCrMemoLine."Document No.");
                        ValueEntry.SetRange("Document Line No.", SalesCrMemoLine."Line No.");
                        ValueEntry.SetRange("Item No.", SalesCrMemoLine."No.");
                        if ValueEntry.FindSet() then begin
                            if ItemLedgEntry.Get(ValueEntry."Item Ledger Entry No.") then begin
                                CreateReserveEntry.CreateReservEntryFor(37, 2, SalesHeader."No.", '', 0, 0, Abs(ItemLedgEntry.Quantity), Abs(ItemLedgEntry.Quantity), Abs(ItemLedgEntry.Quantity), '', ItemLedgEntry."Lot No.");
                                CreateReserveEntry.CreateEntry(ItemLedgEntry."Item No.", '', ItemLedgEntry."Location Code", '', WorkDate(), WorkDate(), 0, ReservStatus::Prospect);
                            end;
                        end;
                    end;
                end;
                SalesLine."Dimension Set ID" := SalesCrMemoLine."Dimension Set ID";
                SalesLine.Insert();
            until SalesCrMemoLine.Next() = 0;
        SalesHeader.Status := SalesHeader.Status::Released;
        SalesHeader.Modify();

        OnAfterCreateSalesInvoiceFromPostedSalesCrMemo(SalesHeader, pSalesCrMemoHdr);
    end;

    local procedure CreateCreditMemoFromPostedSalesinvoice(var SalesHeader: Record "Sales Header"; pSalesInvoiceHeader: Record "Sales Invoice Header"; LegalStatus: Option Succes,Anulled,OutFlow)
    var
        SalesSetup: Record "Sales & Receivables Setup";
        SalesInvHeader: Record "Sales Invoice Header";
        CorrectPostedSalesInvoice: Codeunit "Correct Posted Sales Invoice";
        NoSerie: Record "No. Series";
    begin
        SalesSetup.Get();
        NoSerie.Reset();
        NoSerie.SetRange("Operation Type", NoSerie."Operation Type"::Sales);
        NoSerie.SetRange("Legal Document", '07');
        NoSerie.SetRange("Legal Status", NoSerie."Legal Status"::OutFlow);
        NoSerie.SetRange("Internal Operation", true);
        if NoSerie.FindSet() then;

        SalesSetup.TestField("Posted Credit Memo Nos.");
        SalesSetup.TestField("Posted Return Receipt Nos.");
        if SalesInvHeader.Get(pSalesInvoiceHeader."No.") then
            CorrectPostedSalesInvoice.CreateCreditMemoCopyDocument(SalesInvHeader, SalesHeader);
        SalesHeader."Payment Terms Code" := pSalesInvoiceHeader."Payment Terms Code";
        SalesHeader.Status := SalesHeader.Status::Released;
        SalesSetup.TestField("Posted Credit Memo Nos.");
        //SalesHeader."Posting No. Series" := SalesSetup."Posted Credit Memo Nos.";
        SalesHeader."Posting No. Series" := NoSerie.Code;
        SalesHeader."Legal Document" := '07';
        SalesHeader.Validate("Legal Status", LegalStatus);
        SalesHeader.Validate(SalesHeader."Applies-to Doc. Type", SalesHeader."Applies-to Doc. Type"::Invoice);
        SalesHeader.Validate("Applies-to Doc. No.", pSalesInvoiceHeader."No.");
        SalesHeader."Posting Description" := 'Nota de Credito a Factura :' + SalesHeader."No.";
        SalesHeader.Validate("Return Receipt No. Series", SalesSetup."Posted Return Receipt Nos.");
        SalesHeader.Validate("Applies-to Doc. No. Ref.", pSalesInvoiceHeader."No.");
        SalesHeader.Modify();

        OnAfterCreateCreditMemoFromPostedSalesinvoice(SalesHeader, pSalesInvoiceHeader);
    end;

    procedure RenameSalesDocument(SourceTableID: Integer; DocumentNo: Code[20])
    var
        SalesInvHeader: Record "Sales Invoice Header";
        SalesInvLine: Record "Sales Invoice Line";
        SalesCrMemoHdr: Record "Sales Cr.Memo Header";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        NewSalesInvHeader: Record "Sales Invoice Header";
        NewSalesInvLine: Record "Sales Invoice Line";
        NewSalesCrMemoHdr: Record "Sales Cr.Memo Header";
        NewSalesCrMemoLine: Record "Sales Cr.Memo Line";
        VatEntry: Record "VAT Entry";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        DtldCustLgEntry: Record "Detailed Cust. Ledg. Entry";
        GLEntry: Record "G/L Entry";
        JobLedgerEntry: Record "Job Ledger Entry";
        ItemLedgeEntry: Record "Item Ledger Entry";
        BankAccLgEntry: Record "Bank Account Ledger Entry";
        ValueEntry: Record "Value Entry";
        CostEntry: Record "Cost Entry";
        CUOEntry: Record "ULN CUO Entry";//ULN::RRR
        NewDocumentNo: Code[20];
        IsOutFlow: Boolean;
        LegalStatus: Option;
        ErrorRenameSDoc: Label 'The number of characters has been exceeded to rename document %1.';
    begin
        if StrLen(DocumentNo) + 1 > 20 then
            Error(StrSubstNo(ErrorRenameSDoc, DocumentNo));
        NewDocumentNo := GetExtQuantity(DocumentNo, 2) + DocumentNo;

        case SourceTableID of
            112:
                begin
                    if not SalesInvHeader.Get(DocumentNo) then begin

                    end;
                    LegalStatus := SalesInvHeader."Legal Status";
                    IsOutFlow := SalesInvHeader."Legal Status" = SalesInvHeader."Legal Status"::OutFlow;
                    if IsOutFlow then begin
                        SalesInvHeader.Reset();
                        SalesInvHeader.SetRange("No.", DocumentNo);
                        if SalesInvHeader.FindFirst() then begin
                            NewSalesInvHeader.Init();
                            NewSalesInvHeader.TransferFields(SalesInvHeader);
                            NewSalesInvHeader."No." := NewDocumentNo;
                            NewSalesInvHeader.Insert();
                            SalesInvLine.Reset();
                            SalesInvLine.SetCurrentKey("Document No.", "Line No.");
                            SalesInvLine.SetRange("Document No.", DocumentNo);
                            if SalesInvLine.FindFirst() then
                                repeat
                                    NewSalesInvLine.Init();
                                    NewSalesInvLine.TransferFields(SalesInvLine, true);
                                    NewSalesInvLine."Document No." := NewDocumentNo;
                                    NewSalesInvLine.Insert();
                                    SalesInvLine.Delete();
                                until SalesInvLine.Next() = 0;
                            SalesInvHeader.Delete();
                        end;
                    end;
                end;
            114:
                begin
                    if not SalesCrMemoHdr.Get(DocumentNo) then;
                    LegalStatus := SalesCrMemoHdr."Legal Status";
                    IsOutFlow := SalesCrMemoHdr."Legal Status" = SalesCrMemoHdr."Legal Status"::OutFlow;
                    if IsOutFlow then begin
                        SalesCrMemoHdr.Reset();
                        SalesCrMemoHdr.SetRange("No.", DocumentNo);
                        if SalesCrMemoHdr.FindFirst() then begin
                            NewSalesCrMemoHdr.Init();
                            NewSalesCrMemoHdr.TransferFields(SalesCrMemoHdr);
                            NewSalesCrMemoHdr."No." := NewDocumentNo;
                            NewSalesCrMemoHdr.Insert();
                            SalesCrMemoLine.Reset();
                            SalesCrMemoLine.SetCurrentKey("Document No.", "Line No.");
                            SalesCrMemoLine.SetRange("Document No.", DocumentNo);
                            if SalesCrMemoLine.FindFirst() then
                                repeat
                                    NewSalesCrMemoLine.Init();
                                    NewSalesCrMemoLine.TransferFields(SalesCrMemoLine, true);
                                    NewSalesCrMemoLine."Document No." := NewDocumentNo;
                                    NewSalesCrMemoLine.Insert();
                                    SalesCrMemoLine.Delete();
                                until SalesCrMemoLine.Next() = 0;
                            SalesCrMemoHdr.Delete();
                        end;
                    end;
                end;
        end;

        CustLedgerEntry.SetRange("Document No.", DocumentNo);
        if CustLedgerEntry.FindSet() then begin
            CustLedgerEntry.ModifyAll("Legal Status", LegalStatus);
            if IsOutFlow then
                CustLedgerEntry.ModifyAll("Document No.", NewDocumentNo);
        end;

        GLEntry.SetRange("Document No.", DocumentNo);
        if GLEntry.FindSet() then begin
            GLEntry.ModifyAll("Legal Status", LegalStatus);
            if IsOutFlow then
                GLEntry.ModifyAll("Document No.", NewDocumentNo);
        end;

        VatEntry.SetRange("Document No.", DocumentNo);
        if VatEntry.FindSet() then begin
            VatEntry.ModifyAll("Legal Status", LegalStatus);
            if IsOutFlow then
                VatEntry.ModifyAll("Document No.", NewDocumentNo);
        end;

        if IsOutFlow then begin
            ValueEntry.SetRange("Document No.", DocumentNo);
            if ValueEntry.FindSet() then
                ValueEntry.ModifyAll("Document No.", NewDocumentNo);

            ItemLedgeEntry.SetRange("Document No.", DocumentNo);
            if ItemLedgeEntry.FindSet() then
                ItemLedgeEntry.ModifyAll("Document No.", NewDocumentNo);

            JobLedgerEntry.SetRange("Document No.", DocumentNo);
            if JobLedgerEntry.FindSet() then
                JobLedgerEntry.ModifyAll("Document No.", NewDocumentNo);

            BankAccLgEntry.SetRange("Document No.", DocumentNo);
            if BankAccLgEntry.FindSet() then
                BankAccLgEntry.ModifyAll("Document No.", NewDocumentNo);

            DtldCustLgEntry.SetRange("Document No.", DocumentNo);
            if DtldCustLgEntry.FindSet() then
                DtldCustLgEntry.ModifyAll("Document No.", NewDocumentNo);

            CostEntry.SetRange("Document No.", DocumentNo);
            if CostEntry.FindSet() then
                CostEntry.ModifyAll("Document No.", NewDocumentNo);

            CUOEntry.SetRange("Document No.", DocumentNo);
            if CUOEntry.FindSet() then
                CUOEntry.ModifyAll("Document No.", NewDocumentNo);
        end;

        OnAfterRenameSalesDocument(DocumentNo, NewDocumentNo, IsOutFlow);
    end;

    procedure GetExtQuantity(pDoc: Code[20]; pTipo: Integer): Text
    var
        lclCantidad: Integer;
        lclPurchInvHeader: Record "Purch. Inv. Header";
        lclPurchInvHeader2: Record "Purch. Inv. Header";
        lclPurchCrMemHeader: Record "Purch. Cr. Memo Hdr.";
        lclPurchCrMemHeader2: Record "Purch. Cr. Memo Hdr.";
        lclSalesInvHeader: Record "Sales Invoice Header";
        lclSalesInvHeader2: Record "Sales Invoice Header";
        lclSalesCrMemHeader: Record "Sales Cr.Memo Header";
        lclSalesCrMemHeader2: Record "Sales Cr.Memo Header";
        RetentionLedgerEntry: Record "Retention Ledger Entry";
        RetentionLedgerEntry2: Record "Retention Ledger Entry";
    begin
        lclCantidad := 0;

        CASE pTipo OF
            1:
                BEGIN
                    lclPurchInvHeader.RESET;
                    lclPurchInvHeader.SETRANGE("No.", pDoc);
                    IF lclPurchInvHeader.FINDSET THEN BEGIN
                        lclPurchInvHeader2.RESET;
                        lclPurchInvHeader2.SETFILTER("No.", '%1', '*' + pDoc);
                        lclCantidad := lclPurchInvHeader2.COUNT();
                    END;

                    lclPurchCrMemHeader.RESET;
                    lclPurchCrMemHeader.SETRANGE("No.", pDoc);
                    IF lclPurchCrMemHeader.FINDSET THEN BEGIN
                        lclPurchCrMemHeader2.RESET;
                        lclPurchCrMemHeader2.SETFILTER("No.", '%1', '*' + pDoc);
                        lclCantidad := lclPurchCrMemHeader2.COUNT();
                    END;
                END;
            2:
                BEGIN
                    lclSalesInvHeader.RESET;
                    lclSalesInvHeader.SETRANGE("No.", pDoc);
                    IF lclSalesInvHeader.FINDSET THEN BEGIN
                        lclSalesInvHeader2.RESET;
                        lclSalesInvHeader2.SETFILTER("No.", '%1', '*' + pDoc);
                        lclCantidad := lclSalesInvHeader2.COUNT();
                    END;

                    lclSalesCrMemHeader.RESET;
                    lclSalesCrMemHeader.SETRANGE("No.", pDoc);
                    IF lclSalesCrMemHeader.FINDSET THEN BEGIN
                        lclSalesCrMemHeader2.RESET;
                        lclSalesCrMemHeader2.SETFILTER("No.", '%1', '*' + pDoc);
                        lclCantidad := lclSalesCrMemHeader2.COUNT();
                    END;
                END;
            3:
                BEGIN
                    RetentionLedgerEntry.RESET;
                    RetentionLedgerEntry.SETRANGE("Retention No.", pDoc);
                    IF RetentionLedgerEntry.FINDSET THEN BEGIN
                        RetentionLedgerEntry2.RESET;
                        RetentionLedgerEntry2.SETFILTER("Retention No.", '%1', '*' + pDoc);
                        lclCantidad := RetentionLedgerEntry2.COUNT();
                    END;
                END;
        END;
        IF lclCantidad > 5 THEN
            ERROR('No puede extornar un documento mas de 5 veces.');
        IF lclCantidad = 0 THEN
            exit('E')
        ELSE
            exit(PADSTR('', lclCantidad, 'E'));
    end;


    //******************************************** End Sales *****************************************************

    //******************************************** Begin Purchase *****************************************************
    procedure PurchCorrectInvoice(var pPurchInvHeader: Record "Purch. Inv. Header"): Boolean
    var
        PurchHeader: Record "Purchase Header";
    begin
        pPurchInvHeader.TestField("Legal Status", pPurchInvHeader."Legal Status"::Success);
        CheckOpenItemLedgerEntryInDocuments(Database::"Purch. Inv. Header", pPurchInvHeader."No.", pPurchInvHeader."Posting Date");
        CheckPostedPurchInvoiceForCorrectCancel(pPurchInvHeader);
        if not Confirm('¿Desea corregir el Documento %1?', false, pPurchInvHeader."No.") then
            exit(false);

        CreatePurchCrMemoFromPostedPurchInvoice(PurchHeader, pPurchInvHeader, PurchHeader."Legal Status"::OutFlow);
        Codeunit.Run(Codeunit::"Purch.-Post", PurchHeader);
        //RenamePurchDocument(Database::"Purch. Inv. Header", pPurchInvHeader."No.");
    end;

    procedure PurchCorrectCreditMemo(var pPurchCrMemoHdr: Record "Purch. Cr. Memo Hdr."): Boolean
    var
        PurchHeader: Record "Purchase Header";
    begin
        pPurchCrMemoHdr.TestField("Legal Status", pPurchCrMemoHdr."Legal Status"::Success);
        CheckOpenItemLedgerEntryInDocuments(Database::"Purch. Cr. Memo Hdr.", pPurchCrMemoHdr."No.", pPurchCrMemoHdr."Posting Date");
        CheckPostedPurchCrMemoForCorrectCancel(pPurchCrMemoHdr);
        if not Confirm('¿Desea corregir el Documento %1?', false, pPurchCrMemoHdr."No.") then
            exit(false);

        CreatePurchInvoiceFromPostedPurchCrMemo(PurchHeader, pPurchCrMemoHdr, PurchHeader."Legal Status"::OutFlow);
        Codeunit.Run(Codeunit::"Purch.-Post", PurchHeader);
        //RenamePurchDocument(Database::"Purch. Cr. Memo Hdr.", pPurchCrMemoHdr."No.");
    end;

    local procedure CheckPostedPurchInvoiceForCorrectCancel(pPurchInvHeader: Record "Purch. Inv. Header")
    var
        VendLedgerEntry: Record "Vendor Ledger Entry";
        VendLedgerEntry2: Record "Vendor Ledger Entry";
        DtldVendLdgEntry: Record "Detailed Vendor Ledg. Entry";
        NumToApply: Integer;
    begin
        NumToApply := 0;
        VendLedgerEntry.Reset();
        VendLedgerEntry.SetRange("Document Type", VendLedgerEntry."Document Type"::Invoice);
        VendLedgerEntry.SetRange("Vendor No.", pPurchInvHeader."Sell-to Customer No.");
        VendLedgerEntry.SetRange("Posting Date", pPurchInvHeader."Posting Date");
        VendLedgerEntry.SetRange("Document No.", pPurchInvHeader."No.");
        VendLedgerEntry.SetAutoCalcFields("Remaining Amount");
        if VendLedgerEntry.FindSet() then begin
            DtldVendLdgEntry.Reset();
            DtldVendLdgEntry.SetCurrentKey("Vendor Ledger Entry No.", "Entry Type");
            DtldVendLdgEntry.SetRange("Vendor Ledger Entry No.", VendLedgerEntry."Entry No.");
            DtldVendLdgEntry.SetRange("Entry Type", DtldVendLdgEntry."Entry Type"::Application);
            if DtldVendLdgEntry.FindSet() then
                repeat
                    if not DtldVendLdgEntry.Unapplied then
                        NumToApply += 1;
                until DtldVendLdgEntry.Next() = 0;
            if NumToApply <> 0 then
                Error('Hay %1 documentos por desliquidar', NumToApply);
        end;
    end;

    local procedure CheckPostedPurchCrMemoForCorrectCancel(pPurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.")
    var
        VendLedgerEntry: Record "Vendor Ledger Entry";
        VendLedgerEntry2: Record "Vendor Ledger Entry";
        DtldVendLdgEntry: Record "Detailed Vendor Ledg. Entry";
        NumToApply: Integer;
    begin
        NumToApply := 0;
        VendLedgerEntry.Reset();
        VendLedgerEntry.SetRange("Document Type", VendLedgerEntry."Document Type"::Invoice);
        VendLedgerEntry.SetRange("Vendor No.", pPurchCrMemoHdr."Buy-from Vendor No.");
        VendLedgerEntry.SetRange("Posting Date", pPurchCrMemoHdr."Posting Date");
        VendLedgerEntry.SetRange("Document No.", pPurchCrMemoHdr."No.");
        VendLedgerEntry.SetAutoCalcFields("Remaining Amount");
        if VendLedgerEntry.FindSet() then begin
            DtldVendLdgEntry.Reset();
            DtldVendLdgEntry.SetCurrentKey("Vendor Ledger Entry No.", "Entry Type");
            DtldVendLdgEntry.SetRange("Vendor Ledger Entry No.", VendLedgerEntry."Entry No.");
            DtldVendLdgEntry.SetRange("Entry Type", DtldVendLdgEntry."Entry Type"::Application);
            if DtldVendLdgEntry.FindSet() then
                repeat
                    if not DtldVendLdgEntry.Unapplied then
                        NumToApply += 1;
                until DtldVendLdgEntry.Next() = 0;
            if NumToApply <> 0 then
                Error('Hay %1 documentos por desliquidar', NumToApply);
        end;
    end;

    local procedure CreatePurchInvoiceFromPostedPurchCrMemo(var PurchHeader: Record "Purchase Header"; pPurchCrMemoHdr: Record "Purch. Cr. Memo Hdr."; LegalStatus: Option Succes,Anulled,OutFlow)
    var
        PurchSetup: Record "Purchases & Payables Setup";
        PurchCrMemoLine: Record "Purch. Cr. Memo Line";
        ItemLedgEntry: Record "Item Ledger Entry";
        ValueEntry: Record "Value Entry";
        PurchLine: Record "Purchase Line";
        ReservStatus: Enum "Reservation Status";
        NoSerieMgt: Codeunit NoSeriesManagement;
        CreateReserveEntry: Codeunit "Create Reserv. Entry";
        CorrectPostedPurchInvoice: Codeunit "Correct Posted Purch. Invoice";
        NextDocumentNo: Code[20];
        lcVendorInvoiceNo: Text;
        lcFlag: Boolean;
    begin
        PurchSetup.Get();
        PurchSetup.TestField("Posted Credit Memo Nos.");
        if not pPurchCrMemoHdr.IsEmpty then
            CreateCrMemoCopyDocument(pPurchCrMemoHdr, PurchHeader, PurchHeader."Document Type"::Invoice, false);
        //CorrectPostedPurchInvoice.CreateCreditMemoCopyDocument(pPurchInvHeader, PurchHeader);
        PurchHeader."Payment Terms Code" := pPurchCrMemoHdr."Payment Terms Code";
        PurchHeader.Status := PurchHeader.Status::Released;
        PurchHeader."Posting No. Series" := PurchSetup."Posted Credit Memo Nos.";
        PurchHeader.Validate("Legal Status", LegalStatus);
        PurchHeader.Validate("Legal Document", '01');
        PurchHeader.Validate(PurchHeader."Applies-to Doc. Type", PurchHeader."Applies-to Doc. Type"::"Credit Memo");
        PurchHeader.Validate("Applies-to Doc. No.", pPurchCrMemoHdr."No.");
        case LegalStatus of
            LegalStatus::Anulled:
                PurchHeader."Posting Description" := StrSubstNo('Factura de anulación a Nota de Crédito: %1', Format(pPurchCrMemoHdr."No."));
            LegalStatus::OutFlow:
                PurchHeader."Posting Description" := StrSubstNo('Factura de extorno a Nota de Crédito: %1', Format(pPurchCrMemoHdr."No."));
        end;
        lcVendorInvoiceNo := 'FC' + pPurchCrMemoHdr."Vendor Cr. Memo No.";
        REPEAT
            IF NOT fnVendorCrMemoNo(lcVendorInvoiceNo, PurchHeader."Pay-to Vendor No.", 2) THEN BEGIN
                lcFlag := TRUE;
            END;
            IF NOT lcFlag THEN
                lcVendorInvoiceNo := 'E' + lcVendorInvoiceNo;
        UNTIL lcFlag;
        PurchHeader."Vendor Invoice No." := lcVendorInvoiceNo;
        PurchHeader.Modify();



        /*PurchSetup.Get();
        PurchSetup.TestField("Invoice Nos.");
        PurchSetup.TestField("Posted Receipt Nos.");
        PurchHeader.Init();
        PurchHeader.TransferFields(pPurchCrMemoHdr, false);
        PurchHeader.Validate("Sell-to Customer No.", pPurchCrMemoHdr."Sell-to Customer No.");
        PurchHeader."Document Type" := PurchHeader."Document Type"::Invoice;
        NextDocumentNo := NoSerieMgt.GetNextNo(PurchSetup."Invoice Nos.", WorkDate(), true);
        PurchHeader."No." := NextDocumentNo;
        PurchHeader.Status := PurchHeader.Status::Open;
        //PurchHeader."Posting No. Series" := pPurchCrMemoHdr."No. Series";
        PurchHeader.Validate("Legal Status", LegalStatus);
        PurchHeader.Validate("Legal Document", '01');
        PurchHeader."Responsibility Center" := pPurchCrMemoHdr."Responsibility Center";
        PurchHeader.Validate("Applies-to Doc. Type", PurchHeader."Applies-to Doc. Type"::"Credit Memo");
        PurchHeader.Validate("Applies-to Doc. No.", pPurchCrMemoHdr."No.");
        PurchHeader."Posting Description" := 'Nota de Credito a Factura :' + PurchHeader."No.";
        PurchHeader.Validate("Receiving No. Series", PurchSetup."Posted Receipt Nos.");
        PurchHeader."Vendor Invoice No." := 'FC' + pPurchCrMemoHdr."Vendor Cr. Memo No.";
        PurchHeader."Dimension Set ID" := PurchHeader."Dimension Set ID";
        PurchHeader.Insert();
        PurchHeader.Validate("Shortcut Dimension 1 Code", PurchHeader."Shortcut Dimension 1 Code");
        PurchHeader.Validate("Shortcut Dimension 2 Code", PurchHeader."Shortcut Dimension 2 Code");
        PurchHeader.Modify();

        PurchCrMemoLine.Reset();
        PurchCrMemoLine.SetRange("Document No.", pPurchCrMemoHdr."No.");
        PurchCrMemoLine.SetFilter(Type, '<>%1', PurchCrMemoLine.Type::" ");
        if PurchCrMemoLine.FindFirst() then
            repeat
                PurchLine.Init();
                PurchLine."Document Type" := PurchLine."Document Type"::Invoice;
                PurchLine."Document No." := NextDocumentNo;
                PurchLine."Line No." := PurchCrMemoLine."Line No.";
                PurchLine.Type := PurchCrMemoLine.Type;
                PurchLine.Validate("No.", PurchCrMemoLine."No.");
                PurchLine.Validate(Quantity, PurchCrMemoLine.Quantity);
                PurchLine.Validate("Unit Cost", PurchCrMemoLine."Unit Cost");
                PurchLine.Validate("Gen. Prod. Posting Group", PurchCrMemoLine."Gen. Prod. Posting Group");
                if PurchCrMemoLine.Type = PurchCrMemoLine.Type::Item then begin
                    PurchLine.Validate("Location Code", PurchCrMemoLine."Location Code");
                    PurchLine.Validate("Bin Code", PurchCrMemoLine."Bin Code");
                    ValueEntry.Reset();
                    ValueEntry.SetRange("Document No.", PurchCrMemoLine."Document No.");
                    ValueEntry.SetRange("Document Line No.", PurchCrMemoLine."Line No.");
                    ValueEntry.SetRange("Item No.", PurchCrMemoLine."No.");
                    if ValueEntry.FindSet() then
                        repeat
                            if ItemLedgEntry.Get(ValueEntry."Item Ledger Entry No.") then begin
                                CreateReserveEntry.CreateReservEntryFor(39, 2, PurchHeader."No.", '', 0, 0, Abs(ItemLedgEntry.Quantity), Abs(ItemLedgEntry.Quantity), Abs(ItemLedgEntry.Quantity), '', ItemLedgEntry."Lot No.");
                                CreateReserveEntry.CreateEntry(ItemLedgEntry."Item No.", '', ItemLedgEntry."Location Code", '', WorkDate(), WorkDate(), 0, ReservStatus::Prospect);
                            end;
                        until ValueEntry.Next() = 0;
                end;
                PurchLine."Dimension Set ID" := PurchCrMemoLine."Dimension Set ID";
                PurchLine.Validate("Shortcut Dimension 1 Code", PurchCrMemoLine."Shortcut Dimension 1 Code");
                PurchLine.Validate("Shortcut Dimension 2 Code", PurchCrMemoLine."Shortcut Dimension 2 Code");
                PurchLine.Insert();
            until PurchCrMemoLine.Next() = 0;
        PurchHeader.Status := PurchHeader.Status::Released;
        PurchHeader.Modify();*/

        OnAfterCreatePurchInvoiceFromPostedPurchCrMemo(PurchHeader, pPurchCrMemoHdr);
    end;

    local procedure CreatePurchCrMemoFromPostedPurchInvoice(var PurchHeader: Record "Purchase Header"; pPurchInvHeader: Record "Purch. Inv. Header"; LegalStatus: Option Succes,Anulled,OutFlow)
    var
        PurchSetup: Record "Purchases & Payables Setup";
        CorrectPostedPurchInvoice: Codeunit "Correct Posted Purch. Invoice";
        lcVendorCrMemoNo: Text;
        lcFlag: Boolean;
    begin
        PurchSetup.Get();
        PurchSetup.TestField("Posted Credit Memo Nos.");
        if not pPurchInvHeader.IsEmpty then
            CreatePurchaseCopyDocument(pPurchInvHeader, PurchHeader, PurchHeader."Document Type"::"Credit Memo", false);
        //CorrectPostedPurchInvoice.CreateCreditMemoCopyDocument(pPurchInvHeader, PurchHeader);
        PurchHeader."Payment Terms Code" := pPurchInvHeader."Payment Terms Code";
        PurchHeader.Status := PurchHeader.Status::Released;
        PurchHeader."Posting No. Series" := PurchSetup."Posted Credit Memo Nos.";
        PurchHeader.Validate("Legal Status", LegalStatus);
        PurchHeader.Validate("Legal Document", '07');
        PurchHeader.Validate(PurchHeader."Applies-to Doc. Type", PurchHeader."Applies-to Doc. Type"::Invoice);
        PurchHeader.SetHideValidation(true);
        PurchHeader.Validate("Applies-to Doc. No.", pPurchInvHeader."No.");
        PurchHeader."Applies-to Entry No." := 0;
        PurchHeader."Exclude Validation" := true;
        case LegalStatus of
            LegalStatus::Anulled:
                PurchHeader."Posting Description" := StrSubstNo('Nota de Crédito de anulación a Factura: %1', Format(pPurchInvHeader."No."));
            LegalStatus::OutFlow:
                PurchHeader."Posting Description" := StrSubstNo('Nota de Crédito de extorno a Factura: %1', Format(pPurchInvHeader."No."));
        end;
        lcVendorCrMemoNo := 'NC' + pPurchInvHeader."Vendor Invoice No.";
        REPEAT
            IF NOT fnVendorCrMemoNo(lcVendorCrMemoNo, PurchHeader."Pay-to Vendor No.", 1) THEN BEGIN
                lcFlag := TRUE;
            END;
            IF NOT lcFlag THEN
                lcVendorCrMemoNo := 'E' + lcVendorCrMemoNo;
        UNTIL lcFlag;
        PurchHeader."Vendor Cr. Memo No." := lcVendorCrMemoNo;
        PurchHeader.Modify();

        OnAfterCreatePurchCrMemoFromPostedPurchInvoice(PurchHeader, pPurchInvHeader);
    end;

    local procedure fnVendorCrMemoNo(pVendorCrMemoNo: Text; pVendorNo: Code[20]; pOption: Integer): Boolean
    var
        PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
        PurchInvoiceHdr: Record "Purch. Inv. Header";
    begin
        case pOption of
            1:
                begin
                    PurchCrMemoHdr.Reset();
                    PurchCrMemoHdr.SetRange("Pay-to Vendor No.", pVendorNo);
                    PurchCrMemoHdr.SetRange("Legal Status", PurchCrMemoHdr."Legal Status"::OutFlow);
                    PurchCrMemoHdr.SetRange("Vendor Cr. Memo No.", pVendorCrMemoNo);
                    if PurchCrMemoHdr.FindFirst() then
                        exit(true);
                end;
            2:
                begin
                    PurchInvoiceHdr.Reset();
                    PurchInvoiceHdr.SetRange("Pay-to Vendor No.", pVendorNo);
                    PurchInvoiceHdr.SetRange("Legal Status", PurchInvoiceHdr."Legal Status"::OutFlow);
                    PurchInvoiceHdr.SetRange("Vendor Invoice No.", pVendorCrMemoNo);
                    if PurchInvoiceHdr.FindFirst() then
                        exit(true);
                end;
        end;

        exit(false);
    end;

    local procedure CreatePurchaseCopyDocument(var PurchInvHeader: Record "Purch. Inv. Header"; var PurchaseHeader: Record "Purchase Header"; DocumentType: Enum "Purchase Document Type"; SkipCopyFromDescription: Boolean)
    var
        CopyDocMgt: Codeunit "Copy Document Mgt.";
        WrongDocumentTypeForCopyDocumentErr: Label 'You cannot correct or cancel this type of document.';
    begin
        Clear(PurchaseHeader);
        PurchaseHeader."Document Type" := DocumentType;
        PurchaseHeader."No." := '';
        PurchaseHeader.SetAllowSelectNoSeries;
        PurchaseHeader.Insert(true);

        case DocumentType of
            PurchaseHeader."Document Type"::"Credit Memo":
                CopyDocMgt.SetPropertiesForCreditMemoCorrection;
            PurchaseHeader."Document Type"::Invoice:
                CopyDocMgt.SetPropertiesForInvoiceCorrection(SkipCopyFromDescription);
            else
                Error(WrongDocumentTypeForCopyDocumentErr);
        end;

        CopyDocMgt.CopyPurchaseDocForInvoiceCancelling(PurchInvHeader."No.", PurchaseHeader);
    end;


    local procedure CreateCrMemoCopyDocument(var PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr."; var PurchaseHeader: Record "Purchase Header"; DocumentType: Enum "Purchase Document Type"; SkipCopyFromDescription: Boolean)
    var
        CopyDocMgt: Codeunit "Copy Document Mgt.";
        WrongDocumentTypeForCopyDocumentErr: Label 'You cannot correct or cancel this type of document.';
    begin
        Clear(PurchaseHeader);
        PurchaseHeader."Document Type" := DocumentType;
        PurchaseHeader."No." := '';
        PurchaseHeader.SetAllowSelectNoSeries;
        PurchaseHeader.Insert(true);

        case DocumentType of
            PurchaseHeader."Document Type"::"Credit Memo":
                CopyDocMgt.SetPropertiesForCreditMemoCorrection;
            PurchaseHeader."Document Type"::Invoice:
                CopyDocMgt.SetPropertiesForInvoiceCorrection(SkipCopyFromDescription);
            else
                Error(WrongDocumentTypeForCopyDocumentErr);
        end;

        CopyDocMgt.CopyPurchDocForCrMemoCancelling(PurchCrMemoHdr."No.", PurchaseHeader);
    end;

    procedure RenamePurchDocument(SourceTableID: Integer; DocumentNo: Code[20])
    var
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchInvLine: Record "Purch. Inv. Line";
        PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
        PurchCrMemoLine: Record "Purch. Cr. Memo Line";
        NewPurchInvHeader: Record "Purch. Inv. Header";
        NewPurchInvLine: Record "Purch. Inv. Line";
        NewPurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
        NewPurchCrMemoLine: Record "Purch. Cr. Memo Line";
        VatEntry: Record "VAT Entry";
        VendLedgerEntry: Record "Vendor Ledger Entry";
        DtldVendLgEntry: Record "Detailed Vendor Ledg. Entry";
        GLEntry: Record "G/L Entry";
        JobLedgerEntry: Record "Job Ledger Entry";
        ItemLedgeEntry: Record "Item Ledger Entry";
        BankAccLgEntry: Record "Bank Account Ledger Entry";
        ValueEntry: Record "Value Entry";
        CostEntry: Record "Cost Entry";
        CUOEntry: Record "ULN CUO Entry";
        NewVendorInvoiceNo: Code[20];
        NewVendorCrMemoNo: Code[20];
        NewExternalDocumentNo: Code[20];
        NewDocumentNo: Code[20];
        IsOutFlow: Boolean;
        LegalStatus: Option "Success","Anulled","OutFlow";
        ErrorRenameSDoc: Label 'The number of characters has been exceeded to rename document %1.';
        lclRecDocumentAttachment: Record "Document Attachment";
        lclRecDocumentAttachment1: Record "Document Attachment";
        NewRecDocumentAttachment: Record "Document Attachment";
        LineaNo: Integer;
    begin
        if StrLen(DocumentNo) + 1 > 20 then
            Error(StrSubstNo(ErrorRenameSDoc, DocumentNo));
        NewDocumentNo := 'E' + DocumentNo;

        case SourceTableID of
            122:
                begin
                    PurchInvHeader.Get(DocumentNo);
                    //LegalStatus := PurchInvHeader."Legal Status";
                    case PurchInvHeader."Legal Status" of
                        PurchInvHeader."Legal Status"::Success:
                            LegalStatus := LegalStatus::Success;
                        PurchInvHeader."Legal Status"::OutFlow:
                            LegalStatus := LegalStatus::OutFlow;
                    end;
                    IsOutFlow := PurchInvHeader."Legal Status" = PurchInvHeader."Legal Status"::OutFlow;
                    if IsOutFlow then begin
                        NewVendorInvoiceNo := 'E' + PurchInvHeader."Vendor Invoice No.";
                        NewExternalDocumentNo := NewVendorInvoiceNo;
                        PurchInvHeader.Reset();
                        PurchInvHeader.SetRange("No.", DocumentNo);
                        if PurchInvHeader.FindFirst() then begin
                            NewPurchInvHeader.Init();
                            NewPurchInvHeader.TransferFields(PurchInvHeader);
                            NewPurchInvHeader."Vendor Invoice No." := NewVendorInvoiceNo;
                            NewPurchInvHeader."No." := NewDocumentNo;
                            NewPurchInvHeader.Insert();
                            PurchInvLine.Reset();
                            PurchInvLine.SetCurrentKey("Document No.", "Line No.");
                            PurchInvLine.SetRange("Document No.", DocumentNo);
                            if PurchInvLine.FindFirst() then
                                repeat
                                    NewPurchInvLine.Init();
                                    NewPurchInvLine.TransferFields(PurchInvLine, true);
                                    NewPurchInvLine."Document No." := NewDocumentNo;
                                    NewPurchInvLine.Insert();
                                    PurchInvLine.Delete();
                                until PurchInvLine.Next() = 0;
                            lclRecDocumentAttachment.RESET;
                            lclRecDocumentAttachment.SETRANGE("Table ID", SourceTableID);
                            //lclRecDocumentAttachment.SetRange("Document Type", lclRecDocumentAttachment."Document Type"::Invoice);
                            lclRecDocumentAttachment.SETRANGE("No.", DocumentNo);
                            IF lclRecDocumentAttachment.FINDFIRST THEN
                                REPEAT
                                    lclRecDocumentAttachment1.RESET;
                                    lclRecDocumentAttachment1.SETCURRENTKEY(Id);
                                    IF lclRecDocumentAttachment1.FINDLAST THEN
                                        LineaNo := lclRecDocumentAttachment1.Id;
                                    NewRecDocumentAttachment.INIT;
                                    NewRecDocumentAttachment.TRANSFERFIELDS(lclRecDocumentAttachment, TRUE);
                                    NewRecDocumentAttachment.Id := LineaNo + 1;
                                    NewRecDocumentAttachment."No." := NewDocumentNo;
                                    NewRecDocumentAttachment.Insert();
                                UNTIL lclRecDocumentAttachment.NEXT = 0;
                            PurchInvHeader.Delete();
                        end;
                    end;
                end;
            124:
                begin
                    PurchCrMemoHdr.Get(DocumentNo);
                    //LegalStatus := PurchCrMemoHdr."Legal Status";
                    case PurchCrMemoHdr."Legal Status" of
                        PurchCrMemoHdr."Legal Status"::Success:
                            LegalStatus := LegalStatus::Success;
                        PurchCrMemoHdr."Legal Status"::OutFlow:
                            LegalStatus := LegalStatus::OutFlow;
                    end;
                    IsOutFlow := PurchCrMemoHdr."Legal Status" = PurchCrMemoHdr."Legal Status"::OutFlow;
                    if IsOutFlow then begin
                        NewVendorCrMemoNo := 'E' + PurchCrMemoHdr."Vendor Cr. Memo No.";
                        NewExternalDocumentNo := NewVendorCrMemoNo;
                        PurchCrMemoHdr.Reset();
                        PurchCrMemoHdr.SetRange("No.", DocumentNo);
                        if PurchCrMemoHdr.FindFirst() then begin
                            NewPurchCrMemoHdr.Init();
                            NewPurchCrMemoHdr.TransferFields(PurchCrMemoHdr);
                            NewPurchCrMemoHdr."Vendor Cr. Memo No." := NewVendorCrMemoNo;
                            NewPurchCrMemoHdr."No." := NewDocumentNo;
                            NewPurchCrMemoHdr.Insert();
                            PurchCrMemoLine.Reset();
                            PurchCrMemoLine.SetCurrentKey("Document No.", "Line No.");
                            PurchCrMemoLine.SetRange("Document No.", DocumentNo);
                            if PurchCrMemoLine.FindFirst() then
                                repeat
                                    NewPurchCrMemoLine.Init();
                                    NewPurchCrMemoLine.TransferFields(PurchCrMemoLine, true);
                                    NewPurchCrMemoLine."Document No." := NewDocumentNo;
                                    NewPurchCrMemoLine.Insert();
                                    PurchCrMemoLine.Delete();
                                until PurchCrMemoLine.Next() = 0;
                            PurchCrMemoHdr.Delete();
                        end;
                    end;
                end;
        end;

        VendLedgerEntry.SetRange("Document No.", DocumentNo);
        if VendLedgerEntry.FindSet() then begin
            VendLedgerEntry.ModifyAll("Legal Status", LegalStatus);
            if IsOutFlow then begin
                VendLedgerEntry.ModifyAll("External Document No.", NewExternalDocumentNo);
                VendLedgerEntry.ModifyAll("Document No.", NewDocumentNo);
            end;
        end;

        GLEntry.SetRange("Document No.", DocumentNo);
        if GLEntry.FindSet() then begin
            GLEntry.ModifyAll("Legal Status", LegalStatus);
            if IsOutFlow then begin
                GLEntry.ModifyAll("External Document No.", NewExternalDocumentNo);
                GLEntry.ModifyAll("Document No.", NewDocumentNo);
            end;
        end;

        VatEntry.SetRange("Document No.", DocumentNo);
        if VatEntry.FindSet() then begin
            VatEntry.ModifyAll("Legal Status", LegalStatus);
            if IsOutFlow then begin
                VatEntry.ModifyAll("External Document No.", NewExternalDocumentNo);
                VatEntry.ModifyAll("Document No.", NewDocumentNo);
            end;
        end;

        if IsOutFlow then begin
            ValueEntry.SetRange("Document No.", DocumentNo);
            if ValueEntry.FindSet() then begin
                ValueEntry.ModifyAll("External Document No.", NewExternalDocumentNo);
                ValueEntry.ModifyAll("Document No.", NewDocumentNo);
            end;

            ItemLedgeEntry.SetRange("Document No.", DocumentNo);
            if ItemLedgeEntry.FindSet() then begin
                ItemLedgeEntry.ModifyAll("External Document No.", NewExternalDocumentNo);
                ItemLedgeEntry.ModifyAll("Document No.", NewDocumentNo);
            end;

            JobLedgerEntry.SetRange("Document No.", DocumentNo);
            if JobLedgerEntry.FindSet() then begin
                JobLedgerEntry.ModifyAll("External Document No.", NewExternalDocumentNo);
                JobLedgerEntry.ModifyAll("Document No.", NewDocumentNo);
            end;

            BankAccLgEntry.SetRange("Document No.", DocumentNo);
            if BankAccLgEntry.FindSet() then begin
                BankAccLgEntry.ModifyAll("External Document No.", NewExternalDocumentNo);
                BankAccLgEntry.ModifyAll("Document No.", NewDocumentNo);
            end;

            DtldVendLgEntry.SetRange("Document No.", DocumentNo);
            if DtldVendLgEntry.FindSet() then
                DtldVendLgEntry.ModifyAll("Document No.", NewDocumentNo);

            CostEntry.SetRange("Document No.", DocumentNo);
            if CostEntry.FindSet() then
                CostEntry.ModifyAll("Document No.", NewDocumentNo);

            CUOEntry.SetRange("Document No.", DocumentNo);
            if CUOEntry.FindSet() then
                CUOEntry.ModifyAll("Document No.", NewDocumentNo);
        end;

        OnAfterRenamePurchDocument(DocumentNo, NewDocumentNo, IsOutFlow);
    end;

    //******************************************** End Purchase *****************************************************


    local procedure CheckOpenItemLedgerEntryInDocuments(TableID: Integer; DocumentNo: Code[20]; PostingDate: Date)
    var
        Item: Record Item;
        ItemLedgEntry: Record "Item Ledger Entry";
        ValueEntry: Record "Value Entry";
    begin

        ValueEntry.Reset();
        ValueEntry.SetRange(ValueEntry."Document No.", DocumentNo);
        ValueEntry.SetRange(ValueEntry."Posting Date", PostingDate);
        case TableID of
            112:
                begin
                    ValueEntry.SetRange(ValueEntry."Document Type", ValueEntry."Document Type"::"Sales Invoice");
                    ValueEntry.SetRange(ValueEntry."Item Ledger Entry Type", ValueEntry."Item Ledger Entry Type"::Sale);
                end;
            114:
                begin
                    ValueEntry.SetRange(ValueEntry."Document Type", ValueEntry."Document Type"::"Sales Credit Memo");
                    ValueEntry.SetRange(ValueEntry."Item Ledger Entry Type", ValueEntry."Item Ledger Entry Type"::Sale);
                end;
            122:
                begin
                    ValueEntry.SetRange(ValueEntry."Document Type", ValueEntry."Document Type"::"Purchase Invoice");
                    ValueEntry.SetRange(ValueEntry."Item Ledger Entry Type", ValueEntry."Item Ledger Entry Type"::Purchase);
                end;
            124:
                begin
                    ValueEntry.SetRange(ValueEntry."Document Type", ValueEntry."Document Type"::"Purchase Credit Memo");
                    ValueEntry.SetRange(ValueEntry."Item Ledger Entry Type", ValueEntry."Item Ledger Entry Type"::Purchase);
                end;
        end;

        if ValueEntry.FindSet() then begin
            ItemLedgEntry.Get(ValueEntry."Item Ledger Entry No.");
            Item.Reset();
            Item.SetRange("No.", ItemLedgEntry."Item No.");
            Item.SetRange(Item.Type, Item.Type::Inventory);
            IF Item.FindSet() then begin
                IF (ItemLedgEntry."Remaining Quantity" = 0) or
                    (ItemLedgEntry."Remaining Quantity" <> ItemLedgEntry."Invoiced Quantity") then
                    Error('El producto %1 del documento %2 ya no se encuentra disponible, deberá de anular o corregir el documento de forma manual', ItemLedgEntry."Item No.", ValueEntry."Document No.");
            end;
        end;
    end;


    //******************************************** Begin Subcriptions ***********************************************
    [EventSubscriber(ObjectType::Table, Database::"Cancelled Document", 'OnAfterInsertEvent', '', true, true)]
    procedure RenameCorrectDocumentForInsert(RunTrigger: Boolean; var Rec: Record "Cancelled Document")
    begin
        case Rec."Source ID" of
            112, 114:
                RenameSalesDocument(Rec."Source ID", Rec."Cancelled Doc. No.");
            122, 124:
                RenamePurchDocument(Rec."Source ID", Rec."Cancelled Doc. No.");
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPostPurchaseDoc', '', false, false)]
    local procedure SetOnAfterPostPurchaseDoc(var PurchaseHeader: Record "Purchase Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; PurchRcpHdrNo: Code[20]; RetShptHdrNo: Code[20]; PurchInvHdrNo: Code[20]; PurchCrMemoHdrNo: Code[20]; CommitIsSupressed: Boolean)
    var
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
    begin
        case true of
            (PurchCrMemoHdrNo <> ''):
                begin
                    PurchCrMemoHdr.Get(PurchCrMemoHdrNo);
                    if PurchCrMemoHdr."Legal Status" <> PurchCrMemoHdr."Legal Status"::OutFlow then
                        exit;
                    PurchInvHdrNo := PurchCrMemoHdr."Applies-to Doc. No.";
                    if PurchInvHdrNo <> '' then begin
                        PurchInvHeader.Get(PurchInvHdrNo);
                        PurchInvHeader."Legal Status" := PurchInvHeader."Legal Status"::OutFlow;
                        PurchInvHeader.Modify();
                        RenamePurchDocument(Database::"Purch. Inv. Header", PurchInvHdrNo);
                    end;
                    exit;
                end;
            (PurchInvHdrNo <> ''):
                begin
                    PurchInvHeader.Get(PurchInvHdrNo);
                    if PurchInvHeader."Legal Status" <> PurchInvHeader."Legal Status"::OutFlow then
                        exit;
                    PurchCrMemoHdrNo := PurchInvHeader."Applies-to Doc. No.";
                    if PurchCrMemoHdrNo <> '' then begin
                        PurchCrMemoHdr.Get(PurchCrMemoHdrNo);
                        PurchCrMemoHdr."Legal Status" := PurchCrMemoHdr."Legal Status"::OutFlow;
                        PurchCrMemoHdr.Modify();
                        RenamePurchDocument(Database::"Purch. Cr. Memo Hdr.", PurchCrMemoHdrNo);
                    end;
                    exit;
                end;
        end;
    end;


    //90 OnAfterPostPurchLines
    //90 


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostGLandCustomer', '', false, false)]
    local procedure OnAfterPostGLandCustomer(var SalesHeader: Record "Sales Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; TotalSalesLine: Record "Sales Line"; TotalSalesLineLCY: Record "Sales Line"; CommitIsSuppressed: Boolean)
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesCrMemoHdr: Record "Sales Cr.Memo Header";
        VATEntry: Record "VAT Entry";
        LegalDocument: Code[20];
        AppliedDocumentNo: Code[20];
        PostingDate: Date;
    begin
        if not (SalesHeader."Legal Status" in [SalesHeader."Legal Status"::Anulled, SalesHeader."Legal Status"::OutFlow]) then
            exit;

        AppliedDocumentNo := '';
        if SalesHeader."Applies-to Doc. No." <> '' then begin
            AppliedDocumentNo := SalesHeader."Applies-to Doc. No.";
            if SalesHeader."Applies-to Document Date Ref." <> 0D then
                PostingDate := SalesHeader."Applies-to Document Date Ref.";
            if SalesHeader."Legal Document Ref." <> '' then
                LegalDocument := SalesHeader."Legal Document Ref.";
        end;
        if (SalesHeader."Applies-to Doc. No. Ref." <> '') and (AppliedDocumentNo = '') then begin
            AppliedDocumentNo := SalesHeader."Applies-to Doc. No. Ref.";
            if SalesHeader."Applies-to Document Date Ref." <> 0D then
                PostingDate := SalesHeader."Applies-to Document Date Ref.";
            if SalesHeader."Legal Document Ref." <> '' then
                LegalDocument := SalesHeader."Legal Document Ref.";
        end;
        if (SalesHeader."Applies-to Doc. No." = '') and
            (SalesHeader."Applies-to Doc. No. Ref." = '') and
            (SalesHeader."Legal Status" = SalesHeader."Legal Status"::OutFlow) then
            Error('Tiene que indicar el documento a corregir');

        case SalesHeader."Document Type" of
            SalesHeader."Document Type"::Invoice:
                begin
                    SalesCrMemoHdr.Reset();
                    SalesCrMemoHdr.SetRange("No.", AppliedDocumentNo);
                    SalesCrMemoHdr.SetRange("Bill-to Customer No.", SalesHeader."Bill-to Customer No.");
                    if PostingDate <> 0D then
                        SalesCrMemoHdr.SetRange("Posting Date", PostingDate);
                    if LegalDocument <> '' then
                        SalesCrMemoHdr.SetRange("Legal Document", LegalDocument);
                    if SalesCrMemoHdr.FindSet() then begin
                        SalesCrMemoHdr."Legal Status" := SalesHeader."Legal Status";
                        SalesCrMemoHdr."Ext/Anul. User Id." := SalesHeader."Ext/Anul. User Id.";
                        SalesCrMemoHdr.Modify();
                    end;

                    VATEntry.Reset();
                    VATEntry.SetRange("Document No.", AppliedDocumentNo);
                    VATEntry.SetRange("Bill-to/Pay-to No.", SalesHeader."Bill-to Customer No.");
                    if PostingDate <> 0D then
                        VATEntry.SetRange("Posting Date", PostingDate);
                    if LegalDocument <> '' then
                        VATEntry.SetRange("Legal Document", LegalDocument);
                    if VATEntry.FindSet() then
                        repeat
                            VATEntry."Legal Status" := SalesHeader."Legal Status";
                            VATEntry."Ext/Anul. User Id." := SalesHeader."Ext/Anul. User Id.";
                            VATEntry.Modify();
                        until VATEntry.Next() = 0;

                    if SalesHeader."Legal Status" = SalesHeader."Legal Status"::OutFlow then
                        RenameSalesDocument(Database::"Sales Cr.Memo Header", SalesCrMemoHdr."No.");
                end;
            SalesHeader."Document Type"::"Credit Memo":
                begin
                    SalesInvoiceHeader.Reset();
                    SalesInvoiceHeader.SetRange("No.", AppliedDocumentNo);
                    SalesInvoiceHeader.SetRange("Bill-to Customer No.", SalesHeader."Bill-to Customer No.");
                    if PostingDate <> 0D then
                        SalesInvoiceHeader.SetRange("Posting Date", PostingDate);
                    if LegalDocument <> '' then
                        SalesInvoiceHeader.SetRange("Legal Document", LegalDocument);
                    if SalesInvoiceHeader.FindSet() then begin
                        SalesInvoiceHeader."Legal Status" := SalesHeader."Legal Status";
                        SalesInvoiceHeader."Ext/Anul. User Id." := SalesHeader."Ext/Anul. User Id.";
                        SalesInvoiceHeader.Modify();
                    end;

                    VATEntry.Reset();
                    VATEntry.SetRange("Document No.", AppliedDocumentNo);
                    VATEntry.SetRange("Bill-to/Pay-to No.", SalesHeader."Bill-to Customer No.");
                    if PostingDate <> 0D then VATEntry.SetRange("Posting Date", PostingDate);
                    if LegalDocument <> '' then VATEntry.SetRange("Legal Document", LegalDocument);
                    if VATEntry.FindSet() then
                        repeat
                            VATEntry."Legal Status" := SalesHeader."Legal Status";
                            VATEntry."Ext/Anul. User Id." := SalesHeader."Ext/Anul. User Id.";
                            VATEntry.Modify();
                        until VATEntry.Next() = 0;

                    if SalesHeader."Legal Status" = SalesHeader."Legal Status"::OutFlow then begin
                        RenameSalesDocument(Database::"Sales Invoice Header", SalesInvoiceHeader."No.");
                    end;
                end;
        end;
    end;

    procedure RenameRetentionDocument(pDocumentNo: Code[20]; pEntryNo: Integer)
    var
        RetentionLedgerEntry: Record "Retention Ledger Entry";
        DetailRetentionLedEntry: Record "Detailed Retention Ledg. Entry";
        NewDocumentNo: Code[20];
        ErrorRenameSDoc: Label 'The number of characters has been exceeded to rename document %1.';
    begin
        if StrLen(pDocumentNo) + 1 > 20 then
            Error(StrSubstNo(ErrorRenameSDoc, pDocumentNo));
        NewDocumentNo := GetExtQuantity(pDocumentNo, 3) + pDocumentNo;

        if RetentionLedgerEntry.Get(pEntryNo) then begin
            RetentionLedgerEntry."Retention No." := NewDocumentNo;
            RetentionLedgerEntry.Reversed := true;
            RetentionLedgerEntry.Modify();
            DetailRetentionLedEntry.Reset();
            DetailRetentionLedEntry.SetCurrentKey("Retention No.");
            DetailRetentionLedEntry.SetRange("Retention No.", pDocumentNo);
            if DetailRetentionLedEntry.FindFirst() then
                repeat
                    DetailRetentionLedEntry."Retention No." := NewDocumentNo;
                    DetailRetentionLedEntry.Modify();
                until DetailRetentionLedEntry.Next() = 0;
        end;
        OnAfterRenameRetentionDocument(pDocumentNo, NewDocumentNo);
    end;
    //********************************************* End Subcriptions ************************************************


    // ******************************************* Integrations *****************************************************
    [IntegrationEvent(false, false)]
    local procedure OnAfterCreatePurchInvoiceFromPostedPurchCrMemo(var PurchHeader: Record "Purchase Header"; var PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreatePurchCrMemoFromPostedPurchInvoice(var PurchHeader: Record "Purchase Header"; var PurchInvHeader: Record "Purch. Inv. Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateCreditMemoFromPostedSalesinvoice(var SalesHeader: Record "Sales Header"; var SalesInvoiceHeader: Record "Sales Invoice Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateSalesInvoiceFromPostedSalesCrMemo(var SalesHeader: Record "Sales Header"; var SalesCrMemoHdr: Record "Sales Cr.Memo Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterRenamePurchDocument(SourceDocumentNo: Code[20]; NewDocumentNo: Code[20]; IsOutFlow: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterRenameSalesDocument(SourceDocumentNo: Code[20]; NewDocumentNo: Code[20]; IsOutFlow: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterRenameRetentionDocument(SourceDocumentNo: Code[20]; NewDocumentNo: Code[20])
    begin
    end;

    var
        myInt: Integer;
}