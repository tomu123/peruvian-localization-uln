xmlport 51003 "PS Vendor Documents"
{
    // version NAVW19.00

    DefaultNamespace = 'urn:microsoft-dynamics-nav/xmlports/x51003';
    Direction = Both;
    Encoding = UTF8;
    FormatEvaluate = Xml;
    UseDefaultNamespace = true;

    schema
    {
        textelement(VendorDocuments)
        {
            tableelement(PSVendorDocumentBuffer; "PS Vendor Document Buffer")
            {
                MinOccurs = Zero;
                XmlName = 'VendorDocument';
                UseTemporary = true;

                fieldelement(DocumentType; PSVendorDocumentBuffer."Document Type")
                {
                }
                fieldelement(BC_DocumentNo; PSVendorDocumentBuffer."BC Document No.")
                {
                }

                fieldelement(DocumentDate; PSVendorDocumentBuffer."Document Date")
                {
                }
                fieldelement(PostingDate; PSVendorDocumentBuffer."Posting Date")
                {
                }
                fieldelement(VendorNo; PSVendorDocumentBuffer."Vendor No.")
                {
                }
                fieldelement(VendorName; PSVendorDocumentBuffer."Vendor Name")
                {
                }
                fieldelement(LegalDocument; PSVendorDocumentBuffer."Legal Document")
                {
                }
                fieldelement(VendorInvoiceNo; PSVendorDocumentBuffer."Vendor Invoice No.")
                {
                }
                fieldelement(CurrencyCode; PSVendorDocumentBuffer."Currency Code")
                {
                }
                fieldelement(CurrAmtType; PSVendorDocumentBuffer."Currency Amount Type")
                {
                }
                fieldelement(InvoiceAmount; PSVendorDocumentBuffer.Amount)
                {
                }
                fieldelement(InvoiceAmountLCY; PSVendorDocumentBuffer."Amount LCY")
                {
                }
                fieldelement(PostingText; PSVendorDocumentBuffer."Posting text")
                {
                }
                fieldelement(AppliedToDocumentNo; PSVendorDocumentBuffer."Applied Document No.")
                {
                }
                fieldelement(AppliedToPostingDate; PSVendorDocumentBuffer."Applied Posting Date")
                {
                }
                fieldelement(AppliedToCurrencyCode; PSVendorDocumentBuffer."Applied Currency Code")
                {
                }
                fieldelement(AppliedToCurrAmtType; PSVendorDocumentBuffer."Applied Curr. Amt Type")
                {
                }
                fieldelement(AppliedToAmount; PSVendorDocumentBuffer."Applied Amount")
                {
                }
                fieldelement(AppliedToAmountLCY; PSVendorDocumentBuffer."Applied Amount LCY")
                {
                }
                fieldelement(PayScheduleDate; PSVendorDocumentBuffer."Payment Schedule Date")
                {
                }

                trigger OnPreXmlItem();
                var
                    VendorDocEmpty: Label 'Vendor %1 has no documents.', Comment = 'ESM="El proveedor %1 no tiene documentos."';
                begin
                    if not StatusOK then begin
                        PSVendorDocumentBuffer.Reset();
                        PSVendorDocumentBuffer.DeleteAll();
                        PSVendorDocumentBuffer.Reset();
                        LoadVendorDocuments;
                        if not InsertStatus then
                            Error(VendorDocEmpty, VendorNo);
                    end;
                end;
            }
        }
    }

    var
        LineNo: Integer;
        VendorNo: Code[20];
        DocumentTotals: Codeunit "Document Totals";
        StatusOK: Boolean;
        InsertStatus: Boolean;

        ApplyToDocNo_var: Code[20];
        ApplyToPostingDate_var: date;
        ApplyToCurrencyCode_var: Code[10];
        ApplyToCurrAmtType_var: Decimal;
        ApplyToAmount_var: Decimal;
        ApplyToAmountLCY_var: Decimal;
        PaymentScheduleDate_var: Date;


    procedure SetVendor(pVendorNo: Code[20]);
    begin
        VendorNo := pVendorNo;
    end;

    local procedure LoadVendorDocuments();
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        PurchLineTemp: Record "Purchase Line" temporary;
        VendLedgEntry: Record "Vendor Ledger Entry";
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
        PurchInvLine: Record "Purch. Inv. Line";
        PurchCrMemoLine: Record "Purch. Cr. Memo Line";
        VATAmount: Decimal;
        DocType: Enum "Gen. Journal Document Type";
    begin
        LineNo := 1;
        PurchaseHeader.Reset();
        PurchaseHeader.SetFilter("Document Type",
                                   '%1|%2',
                                   PurchaseHeader."Document Type"::Invoice,
                                   PurchaseHeader."Document Type"::"Credit Memo");
        if VendorNo <> '' then
            PurchaseHeader.SetRange("Buy-from Vendor No.", VendorNo);
        if PurchaseHeader.FindSet() then
            repeat
                Clear(DocumentTotals);
                LineNo += 1;
                PurchaseLine.Reset();
                PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");
                PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
                if PurchaseLine.FindSet() then;
                case PurchaseHeader."Document Type" of
                    PurchaseHeader."Document Type"::Invoice:
                        begin
                            DocumentTotals.PurchaseRedistributeInvoiceDiscountAmounts(PurchaseLine, VATAmount, PurchLineTemp);
                            InsertPSVendorDocumentBuffer(LineNo,
                                         PurchaseHeader."No.",
                                         'Pre-Registro',
                                         PurchaseHeader."Document Date",
                                         PurchaseHeader."Posting Date",
                                         PurchaseHeader."Buy-from Vendor No.",
                                         PurchaseHeader."Buy-from Vendor Name",
                                         PurchaseHeader."Legal Document",
                                         PurchaseHeader."Vendor Invoice No.",
                                         PurchaseHeader."Currency Code",
                                         PurchaseHeader."Currency Factor",
                                         PurchLineTemp.Amount,
                                         0,
                                         PurchaseHeader."Posting Text",
                                         '',//ApplyToDocNo
                                         0D,//ApplyToPostingDate
                                         '',//pApplyToCurrencyCode
                                         0,//pApplyToCurrAmtType
                                         0,//pApplyToAmount",
                                         0,//pApplyToAmountLCY,
                                         0D);//pPaymentScheduleDate)
                        end;
                    PurchaseHeader."Document Type"::"Credit Memo":
                        begin
                            DocumentTotals.PurchaseRedistributeInvoiceDiscountAmounts(PurchaseLine, VATAmount, PurchLineTemp);
                            InsertPSVendorDocumentBuffer(LineNo,
                                         PurchaseHeader."No.",
                                         'Pre-Registro',
                                         PurchaseHeader."Document Date",
                                         PurchaseHeader."Posting Date",
                                         PurchaseHeader."Buy-from Vendor No.",
                                         PurchaseHeader."Buy-from Vendor Name",
                                         PurchaseHeader."Legal Document",
                                         PurchaseHeader."Vendor Cr. Memo No.",
                                         PurchaseHeader."Currency Code",
                                         PurchaseHeader."Currency Factor",
                                         PurchLineTemp.Amount,
                                         0,
                                         PurchaseHeader."Posting Text",
                                         '',//ApplyToDocNo
                                         0D,//ApplyToPostingDate
                                         '',//pApplyToCurrencyCode
                                         0,//pApplyToCurrAmtType
                                         0,//pApplyToAmount",
                                         0,//pApplyToAmountLCY,
                                         0D);//pPaymentScheduleDate)
                        end;
                end;
            until PurchaseHeader.NEXT = 0;

        VendLedgEntry.Reset();
        VendLedgEntry.SetFilter("Document Type", '%1|%2',
                                      VendLedgEntry."Document Type"::Invoice,
                                      VendLedgEntry."Document Type"::"Credit Memo");
        VendLedgEntry.SetFilter("Date Filter", '%1..%2', 0D, Today);
        if VendorNo <> '' then
            VendLedgEntry.SetRange("Buy-from Vendor No.", VendorNo);
        if VendLedgEntry.FindSet() then
            repeat
                VendLedgEntry.CALCFIELDS("Remaining Amount");
                LineNo += 1;
                Clear(DocumentTotals);
                if (VendLedgEntry."Remaining Amount" <> 0) or (VendLedgEntry."Remaining Amount" = 0) then begin
                    case VendLedgEntry."Document Type" of
                        VendLedgEntry."Document Type"::Invoice:
                            begin
                                if PurchInvHeader.Get(VendLedgEntry."Document No.") then begin
                                    PurchInvLine.Reset();
                                    PurchInvLine.SetRange("Document No.", PurchInvHeader."No.");
                                    if PurchInvLine.FindSet() then
                                        DocumentTotals.CalculatePostedPurchInvoiceTotals(PurchInvHeader, VATAmount, PurchInvLine);
                                    AppliedVendLedgEntry(VendLedgEntry."Entry No.");
                                    InsertPSVendorDocumentBuffer(LineNo,
                                         PurchInvHeader."No.",
                                         'Facturado',
                                         PurchInvHeader."Document Date",
                                         PurchInvHeader."Posting Date",
                                         PurchInvHeader."Buy-from Vendor No.",
                                         PurchInvHeader."Buy-from Vendor Name",
                                         PurchInvHeader."Legal Document",
                                         PurchInvHeader."Vendor Invoice No.",
                                         VendLedgEntry."Currency Code",
                                         PurchInvHeader."Currency Factor",
                                         VendLedgEntry.Amount,
                                         VendLedgEntry."Amount (LCY)",
                                         PurchaseHeader."Posting Text",
                                         ApplyToDocNo_var,//ApplyToDocNo
                                         ApplyToPostingDate_var,//ApplyToPostingDate
                                         ApplyToCurrencyCode_var,//pApplyToCurrencyCode
                                         ApplyToCurrAmtType_var,//pApplyToCurrAmtType
                                         ApplyToAmount_var,//pApplyToAmount",
                                         ApplyToAmountLCY_var,//pApplyToAmountLCY,
                                         GetPaymentScheduleDate(PurchInvHeader."No."));//pPaymentScheduleDate)
                                end;
                            end;
                        VendLedgEntry."Document Type"::"Credit Memo":
                            begin
                                if PurchCrMemoHdr.GET(VendLedgEntry."Document No.") then begin
                                    PurchCrMemoLine.Reset();
                                    PurchCrMemoLine.SetRange("Document No.", PurchCrMemoHdr."No.");
                                    if PurchCrMemoLine.FindSet() then
                                        DocumentTotals.CalculatePostedPurchCreditMemoTotals(PurchCrMemoHdr, VATAmount, PurchCrMemoLine);
                                    AppliedVendLedgEntry(VendLedgEntry."Entry No.");
                                    InsertPSVendorDocumentBuffer(LineNo,
                                         PurchCrMemoHdr."No.",
                                         'Facturado',
                                         PurchCrMemoHdr."Document Date",
                                         PurchCrMemoHdr."Posting Date",
                                         PurchCrMemoHdr."Buy-from Vendor No.",
                                         PurchCrMemoHdr."Buy-from Vendor Name",
                                         PurchCrMemoHdr."Legal Document",
                                         PurchCrMemoHdr."Vendor Cr. Memo No.",
                                         VendLedgEntry."Currency Code",
                                         PurchCrMemoHdr."Currency Factor",
                                         VendLedgEntry.Amount,
                                         VendLedgEntry."Amount (LCY)",
                                         PurchCrMemoHdr."Posting Text",
                                         ApplyToDocNo_var,//ApplyToDocNo
                                         ApplyToPostingDate_var,//ApplyToPostingDate
                                         ApplyToCurrencyCode_var,//pApplyToCurrencyCode
                                         ApplyToCurrAmtType_var,//pApplyToCurrAmtType
                                         ApplyToAmount_var,//pApplyToAmount",
                                         ApplyToAmountLCY_var,//pApplyToAmountLCY,
                                         GetPaymentScheduleDate(PurchCrMemoHdr."No."));//pPaymentScheduleDate)
                                end;
                            end;
                    end;
                end;
            until VendLedgEntry.Next() = 0;
        StatusOK := true;
        if PSVendorDocumentBuffer.Count = 0 then
            InsertPSVendorDocumentBuffer(1, '', '-', 0D, 0D, VendorNo, '-', '-', '-', '-', 0, 0, 0, '', '', 0D, '', 0, 0, 0, 0D);
    end;

    local procedure InsertPSVendorDocumentBuffer(pEntryNo: Integer;
                                                    pDocumentNo: Code[20];
                                                    pStatusDocument: Text[30];
                                                    pDocumentDate: Date;
                                                    pPostingDate: Date;
                                                    pVendorNo: Code[20];
                                                    pVendorName: Text;
                                                    pLegalDocument: Code[10];
                                                    pVendorInvoiceNo: Code[20];
                                                    pCurrencyCode: Code[10];
                                                    pCurrencyAmtType: Decimal;
                                                    pAmount: Decimal;
                                                    pAmountLCY: Decimal;
                                                    pPostingText: Text;
                                                    pApplyToDocNo: Code[20];
                                                    pApplyToPostingDate: Date;
                                                    pApplyToCurrencyCode: Code[10];
                                                    pApplyToCurrAmtType: Decimal;
                                                    pApplyToAmount: Decimal;
                                                    pApplyToAmountLCY: Decimal;
                                                    pPaymentScheduleDate: Date);
    var
        PaymentTerms: Record "Payment Terms";
    begin
        if pCurrencyCode = '' then
            pCurrencyCode := 'PEN'
        else
            if pCurrencyAmtType <> 0 then
                pCurrencyAmtType := 1 / pCurrencyAmtType;

        if pApplyToCurrencyCode = '' then begin
            pApplyToCurrencyCode := 'PEN';
            pApplyToAmountLCY := pApplyToAmount;
        end else
            if pApplyToCurrAmtType <> 0 then begin
                pApplyToAmountLCY := Round(pApplyToAmount / pApplyToCurrAmtType, 0.01);
                pApplyToCurrAmtType := 1 / pApplyToCurrAmtType;
            end;

        PSVendorDocumentBuffer.Init();
        PSVendorDocumentBuffer."Entry No." := pEntryNo;
        case pLegalDocument of
            '01':
                PSVendorDocumentBuffer."Document Type" := 'Factura';
            '02':
                PSVendorDocumentBuffer."Document Type" := 'Recibo por honorario';
            '03':
                PSVendorDocumentBuffer."Document Type" := 'Boleta';
            '07':
                PSVendorDocumentBuffer."Document Type" := 'Nota de Crédito';
            '08':
                PSVendorDocumentBuffer."Document Type" := 'Nota de Débito';
            '00':
                PSVendorDocumentBuffer."Document Type" := 'Otros Documentos';
        end;
        PSVendorDocumentBuffer."BC Document No." := pDocumentNo;
        PSVendorDocumentBuffer.Status := pStatusDocument;
        PSVendorDocumentBuffer."Document Date" := pDocumentDate;
        PSVendorDocumentBuffer."Posting Date" := pPostingDate;
        PSVendorDocumentBuffer."Vendor No." := pVendorNo;
        PSVendorDocumentBuffer."Vendor Name" := pVendorName;
        PSVendorDocumentBuffer."Legal Document" := pLegalDocument;
        PSVendorDocumentBuffer."Vendor Invoice No." := pVendorInvoiceNo;
        PSVendorDocumentBuffer."Currency Code" := pCurrencyCode;
        PSVendorDocumentBuffer."Currency Amount Type" := pCurrencyAmtType;
        PSVendorDocumentBuffer.Amount := pAmount;
        PSVendorDocumentBuffer."Amount LCY" := pAmountLCY;
        PSVendorDocumentBuffer."Posting text" := pPostingText;
        PSVendorDocumentBuffer."Applied Document No." := pApplyToDocNo;
        PSVendorDocumentBuffer."Applied Posting Date" := pApplyToPostingDate;
        PSVendorDocumentBuffer."Applied Currency Code" := pApplyToCurrencyCode;
        PSVendorDocumentBuffer."Applied Curr. Amt Type" := pApplyToCurrAmtType;
        PSVendorDocumentBuffer."Applied Amount" := pApplyToAmount;
        PSVendorDocumentBuffer."Applied Amount LCY" := pApplyToAmountLCY;
        PSVendorDocumentBuffer."Payment Schedule Date" := pPaymentScheduleDate;
        PSVendorDocumentBuffer.Insert();
        InsertStatus := true;
    end;

    local procedure AppliedVendLedgEntry(EntryNo: Integer): Date;
    var
        DtldVendLedgEntry1: Record "Detailed Vendor Ledg. Entry";
        DtldVendLedgEntry2: Record "Detailed Vendor Ledg. Entry";
        DtldVendLedgEntry3: Record "Detailed Vendor Ledg. Entry";
    begin
        ApplyToDocNo_var := '';
        ApplyToPostingDate_var := 0D;
        ApplyToCurrencyCode_var := '';
        ApplyToCurrAmtType_var := 0;
        ApplyToAmount_var := 0;
        ApplyToAmountLCY_var := 0;

        DtldVendLedgEntry1.SetCurrentKey("Vendor Ledger Entry No.");
        DtldVendLedgEntry1.SetRange("Vendor Ledger Entry No.", EntryNo);
        DtldVendLedgEntry1.SetRange(Unapplied, false);
        if DtldVendLedgEntry1.Find('-') then
            repeat
                if DtldVendLedgEntry1."Vendor Ledger Entry No." =
                   DtldVendLedgEntry1."Applied Vend. Ledger Entry No."
                then begin
                    DtldVendLedgEntry2.Reset();
                    DtldVendLedgEntry2.SetCurrentKey("Applied Vend. Ledger Entry No.", "Entry Type");
                    DtldVendLedgEntry2.SetRange(
                      "Applied Vend. Ledger Entry No.", DtldVendLedgEntry1."Applied Vend. Ledger Entry No.");
                    DtldVendLedgEntry2.SetRange("Entry Type", DtldVendLedgEntry2."Entry Type"::Application);
                    DtldVendLedgEntry2.SetRange(Unapplied, false);
                    if DtldVendLedgEntry2.Find('-') then begin
                        if DtldVendLedgEntry2."Vendor Ledger Entry No." <>
                           DtldVendLedgEntry2."Applied Vend. Ledger Entry No."
                        then begin
                            DtldVendLedgEntry3.SetCurrentKey("Entry No.");
                            DtldVendLedgEntry3.SetRange("Entry No.", DtldVendLedgEntry2."Vendor Ledger Entry No.");
                            if DtldVendLedgEntry3.Find('-') then begin
                                ApplyToDocNo_var := DtldVendLedgEntry3."Document No.";
                                ApplyToPostingDate_var := DtldVendLedgEntry3."Posting Date";
                                ApplyToCurrencyCode_var := DtldVendLedgEntry3."Currency Code";
                                ApplyToCurrAmtType_var := 0;
                                ApplyToAmount_var := DtldVendLedgEntry3.Amount;
                                ApplyToAmountLCY_var := DtldVendLedgEntry3."Amount (LCY)";
                                exit(DtldVendLedgEntry3."Posting Date");
                            end;

                        end;
                    end;
                end else begin
                    DtldVendLedgEntry3.SetCurrentKey("Entry No.");
                    DtldVendLedgEntry3.SetRange("Entry No.", DtldVendLedgEntry1."Applied Vend. Ledger Entry No.");
                    if DtldVendLedgEntry3.Find('-') then begin
                        ApplyToDocNo_var := DtldVendLedgEntry3."Document No.";
                        ApplyToPostingDate_var := DtldVendLedgEntry3."Posting Date";
                        ApplyToCurrencyCode_var := DtldVendLedgEntry3."Currency Code";
                        ApplyToCurrAmtType_var := 0;
                        ApplyToAmount_var := DtldVendLedgEntry3.Amount;
                        ApplyToAmountLCY_var := DtldVendLedgEntry3."Amount (LCY)";
                        exit(DtldVendLedgEntry3."Posting Date");
                    end;
                end;
            until DtldVendLedgEntry1.NEXT = 0;
        exit(0D);
    end;

    local procedure GetPaymentScheduleDate(DocumenNo: Code[20]): Date
    var
        PaymentSchedule: Record "Payment Schedule";
    begin
        PaymentSchedule.Reset();
        PaymentSchedule.SetRange("Document No.", DocumenNo);
        if PaymentSchedule.Find('-') then
            exit(PaymentSchedule."Posting Date");
        exit(0D);
    end;
}

