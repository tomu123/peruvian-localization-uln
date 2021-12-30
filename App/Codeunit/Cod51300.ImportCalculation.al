codeunit 51300 "Importation Calculation"
{
    trigger OnRun()
    begin

    end;

    procedure Nacionalizar(pImportation: Record Importation)
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        //001
        if Confirm(ULN0001) then begin
            ItemLedgerEntry.SetFilter("Importation No.", pImportation."No.");
            if pImportation.Nationalization = pImportation.Nationalization::Yes then begin
                if ItemLedgerEntry.Find('-') then
                    repeat
                        ItemLedgerEntry.Nationalization := ItemLedgerEntry.Nationalization::Yes;
                        ItemLedgerEntry.Modify();
                    until ItemLedgerEntry.Next() = 0;
            END;
            if pImportation.Nationalization = pImportation.Nationalization::No then begin
                if ItemLedgerEntry.Find('-') then
                    repeat
                        ItemLedgerEntry.Nationalization := ItemLedgerEntry.Nationalization::No;
                        ItemLedgerEntry.Modify();
                    until ItemLedgerEntry.Next() = 0;
            END;
            Importation(pImportation."No.");
        END;
        //001
    end;

    procedure Importation(ImportFilter: Code[20])
    var
        PurchRcpHeader: Record "Purch. Rcpt. Header";
        ItemLedgerEntry: Record "Item Ledger Entry";
        GLEntries: Record "G/L Entry";
        PurchInvHeader2: Record "Purch. Inv. Header";
        PurchCrMemoHdr2: Record "Purch. Cr. Memo Hdr.";
        ReturnShipmentHeader: Record "Return Shipment Header";
        ValueEntry: Record "Value Entry";
        Vat: Record "VAT Entry";
        PurchRcpLine: Record "Purch. Rcpt. Line";
        PurchInvLine2: Record "Purch. Inv. Line";
        PurchCrMemoLine: Record "Purch. Cr. Memo Line";
        ReturnShipmentLine: Record "Return Shipment Line";
        Importation: Record Importation;
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
    begin
        Window.Open(ULN0002 + ULN0003);
        Importation.Get(ImportFilter);
        PurchRcpLine.SetRange("Importation No.", ImportFilter);
        if PurchRcpLine.Find('-') then
            repeat
                ItemLedgerEntry.SetFilter("Document No.", PurchRcpLine."Document No.");
                if ItemLedgerEntry.Find('-') then
                    repeat
                        ItemLedgerEntry."Importation No." := PurchRcpLine."Importation No.";
                        ItemLedgerEntry.CalcFields("Cost Amount (Actual)");
                        Window.UPDATE(1, ItemLedgerEntry."Item No.");
                        Window.UPDATE(2, ItemLedgerEntry."Document No.");
                        if Importation.Status = Importation.Status::Closed then
                            ItemLedgerEntry."Closed Import" := true
                        else
                            ItemLedgerEntry."Closed Import" := false;
                        ItemLedgerEntry.Modify();
                    until ItemLedgerEntry.Next() = 0;
                GLEntries.SetFilter("Document No.", PurchRcpLine."Document No.");
                if GLEntries.Find('-') then
                    repeat
                        GLEntries."Importation No." := PurchRcpLine."Importation No.";
                        GLEntries.Modify();
                    until GLEntries.Next() = 0;
                ValueEntry.SetFilter("Document No.", PurchRcpLine."Document No.");
                if ValueEntry.Find('-') then
                    repeat
                        ValueEntry."Importation No." := PurchRcpLine."Importation No.";
                        ValueEntry.Modify();
                    until ValueEntry.Next() = 0;
                Vat.SetFilter("Document No.", PurchRcpLine."Document No.");
                if Vat.Find('-') then
                    repeat
                        Vat."Importation No." := PurchRcpLine."Importation No.";
                        Vat.Modify();
                    until Vat.Next() = 0;
                if Importation.Status = Importation.Status::Closed then
                    PurchRcpLine."Closed Import" := true
                else
                    PurchRcpLine."Closed Import" := false;
                PurchRcpLine.Modify();
            until PurchRcpLine.Next() = 0;
        //**********************************************************
        PurchInvLine2.SetRange("Importation No.", ImportFilter);
        if PurchInvLine2.Find('-') then
            repeat
                ItemLedgerEntry.SetFilter("Document No.", PurchInvLine2."Document No.");
                if ItemLedgerEntry.Find('-') then
                    repeat
                        ItemLedgerEntry."Importation No." := PurchInvLine2."Importation No.";
                        ItemLedgerEntry.CalcFields("Cost Amount (Actual)");
                        ItemLedgerEntry.Modify();
                    until ItemLedgerEntry.Next() = 0;
                GLEntries.SetFilter("Document No.", PurchInvLine2."Document No.");
                if GLEntries.Find('-') then
                    repeat
                        GLEntries."Importation No." := PurchInvLine2."Importation No.";
                        GLEntries.Modify();
                    until GLEntries.Next() = 0;
                ValueEntry.SetFilter("Document No.", PurchInvLine2."Document No.");
                if ValueEntry.Find('-') then
                    repeat
                        ValueEntry."Importation No." := PurchInvLine2."Importation No.";
                        ValueEntry.Modify();
                    until ValueEntry.Next() = 0;
                Vat.SetFilter("Document No.", PurchInvLine2."Document No.");
                if Vat.Find('-') then
                    repeat
                        Vat."Importation No." := PurchInvLine2."Importation No.";
                        Vat.Modify();
                    until Vat.Next() = 0;
            until PurchInvLine2.Next() = 0;
        //PurchCrMemo Hdr
        //*************************************************************
        PurchCrMemoLine.SetRange("Importation No.", ImportFilter);
        if PurchCrMemoLine.Find('-') then
            repeat
                ItemLedgerEntry.SetFilter("Document No.", PurchCrMemoLine."Document No.");
                if ItemLedgerEntry.Find('-') then
                    repeat
                        ItemLedgerEntry."Importation No." := PurchCrMemoLine."Importation No.";
                        ItemLedgerEntry.Modify();
                    until ItemLedgerEntry.Next() = 0;
                GLEntries.SetFilter("Document No.", PurchCrMemoLine."Document No.");
                if GLEntries.Find('-') then
                    repeat
                        GLEntries."Importation No." := PurchCrMemoLine."Importation No.";
                        GLEntries.Modify();
                    until GLEntries.Next() = 0;
                ValueEntry.SetFilter("Document No.", PurchCrMemoLine."Document No.");
                if ValueEntry.Find('-') then
                    repeat
                        ValueEntry."Importation No." := PurchCrMemoLine."Importation No.";
                        ValueEntry.Modify();
                    until ValueEntry.Next() = 0;
                Vat.SetFilter("Document No.", PurchCrMemoLine."Document No.");
                if Vat.Find('-') then
                    repeat
                        Vat."Importation No." := PurchCrMemoLine."Importation No.";
                        Vat.Modify();
                    until Vat.Next() = 0;
            until PurchCrMemoLine.Next() = 0;
        //**********************************************************************
        //ReturnShipmentHeader
        ReturnShipmentLine.SetRange("Importation No.", ImportFilter);
        if ReturnShipmentLine.Find('-') then
            repeat
                ItemLedgerEntry.SetFilter("Document No.", ReturnShipmentLine."Document No.");
                if ItemLedgerEntry.Find('-') then
                    repeat
                        ItemLedgerEntry."Importation No." := ReturnShipmentLine."Importation No.";
                        ItemLedgerEntry.Modify();
                    until ItemLedgerEntry.Next() = 0;
                GLEntries.SetFilter("Document No.", ReturnShipmentLine."Document No.");
                if GLEntries.Find('-') then
                    repeat
                        GLEntries."Importation No." := ReturnShipmentLine."Importation No.";
                        GLEntries.Modify();
                    until GLEntries.Next() = 0;
                ValueEntry.SetFilter("Document No.", ReturnShipmentLine."Document No.");
                if ValueEntry.Find('-') then
                    repeat
                        ValueEntry."Importation No." := ReturnShipmentLine."Importation No.";
                        ValueEntry.Modify();
                    until ValueEntry.Next() = 0;
                Vat.SetFilter("Document No.", ReturnShipmentLine."Document No.");
                if Vat.Find('-') then
                    repeat
                        Vat."Importation No." := ReturnShipmentLine."Importation No.";
                        Vat.Modify();
                    until Vat.Next() = 0;
            until ReturnShipmentLine.Next() = 0;
        Window.Close();
        //002
    end;

    procedure ValidateChangeinVPG(VAR pPurchHeader: Record "Purchase Header")
    var
        VendPostingGr: Record "Vendor Posting Group";
    begin
        //---
        VendPostingGr.Get(pPurchHeader."Vendor Posting Group");
        pPurchHeader.VALIDATE("Currency Code", VendPostingGr."Currency Code");
        //---
    end;

    var //Globals
        Window: Dialog;
        ULN0001: Label 'Esta seguro de cambiar todo el estado?% se modificara el estado de todos los productos% por esta importacion.', Comment = 'ESM="Esta seguro de cambiar todo el estado?% se modificara el estado de todos los productos% por esta importacion."';
        ULN0002: Label 'No de producto. 1\', Comment = 'ESM="N° Producto 1"';
        ULN0003: Label 'Documento No.. 2', Comment = 'ESM="N° Documento 2"';
}