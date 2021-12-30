codeunit 51006 "Retention RH Management"
{
    trigger OnRun()
    begin

    end;

    procedure ApplyRetention(pPurchaseHeader: Record "Purchase Header")
    var
        PurchaseLine: record "Purchase Line";
        table81: Record 81;
        DimSetEntry: Record "Dimension Set Entry";
        RetentionBaseAmt: Decimal;
        RetentionBaseAmtLCY: Decimal;
        NextLineNo: Integer;
        Flag: Boolean;
        ConfirUnLimintAmt: Label 'The limit amount of %1 was not exceeded. Do you want to apply retention to the document?', Comment = 'ESM="No se superó la cantidad límite de %1. ¿Quieres aplicar la retención al documento?"';
    begin
        SetConfiguration();
        CheckRetentionRH(pPurchaseHeader);
        RetentionBaseAmt := 0;
        RetentionBaseAmtLCY := 0;
        if pPurchaseHeader."Legal Document" = '02' then begin
            PurchaseLine.Reset();
            PurchaseLine.SetRange("Document Type", pPurchaseHeader."Document Type");
            PurchaseLine.SetRange("Document No.", pPurchaseHeader."No.");
            PurchaseLine.SetFilter(Type, '%1|%2', PurchaseLine.Type::"G/L Account", PurchaseLine.Type::"Fixed Asset");
            if PurchaseLine.FindLast() then
                NextLineNo := PurchaseLine."Line No." + 1000;
            if PurchaseLine.FindFirst() then begin
                repeat
                    RetentionBaseAmt += PurchaseLine."Direct Unit Cost" * PurchaseLine.Quantity;
                    RetentionBaseAmtLCY += PurchaseLine."Direct Unit Cost" * PurchaseLine.Quantity;
                until PurchaseLine.Next() = 0;
                if pPurchaseHeader."Currency Code" <> '' then
                    RetentionBaseAmtLCY := Round(RetentionBaseAmt * (1 / pPurchaseHeader."Currency Factor"), 0.01);
                Flag := true;
                if RetentionBaseAmtLCY < SLSetup."Retention RH Limit Amount" then
                    if not Confirm(ConfirUnLimintAmt, false, SLSetup."Retention RH Limit Amount") then
                        Flag := false;
                if Flag then begin
                    PurchaseLine.Init();
                    PurchaseLine."Document Type" := pPurchaseHeader."Document Type";
                    PurchaseLine."Document No." := pPurchaseHeader."No.";
                    PurchaseLine."Line No." := NextLineNo;
                    PurchaseLine."Buy-from Vendor No." := pPurchaseHeader."Buy-from Vendor No.";
                    PurchaseLine.Type := PurchaseLine.Type::"G/L Account";
                    PurchaseLine.VALIDATE("No.", SLSetup."Retention RH GLAcc. No.");
                    PurchaseLine."Location Code" := pPurchaseHeader."Location Code";
                    PurchaseLine.VALIDATE(Quantity, -1);
                    PurchaseLine.VALIDATE("Direct Unit Cost", RetentionBaseAmt * SLSetup."Retention RH %" / 100);
                    PurchaseLine.VALIDATE("VAT Prod. Posting Group", SLSetup."Ret. RH VAT Prod Pstg. Gr. Ex.");
                    PurchaseLine.Validate("Shortcut Dimension 1 Code", pPurchaseHeader."Shortcut Dimension 1 Code");
                    PurchaseLine.Validate("Shortcut Dimension 2 Code", pPurchaseHeader."Shortcut Dimension 2 Code");
                    SetDimensionIDFromPurchHdr(PurchaseLine, pPurchaseHeader);
                    PurchaseLine.Insert(true);
                end;
            end;
        end;
    end;

    local procedure CheckRetentionRH(var pPurchaseHeader: Record "Purchase Header")
    var
        PurchaseLine: Record "Purchase Line";
        ExistsLinesMessage: Label 'It already generated retention. If you want to calculate delete the line and re-process!', Comment = 'ESM="Ya generó retención. Si desea calcular, elimine la línea y vuelva a procesar."';
    begin
        SLSetup.TestField("Retention RH Nos");
        SLSetup.TestField("Retention RH Posted Nos");
        SLSetup.TestField("Retention RH GLAcc. No.");
        SLSetup.TestField("Ret. RH VAT Prod Pstg. Gr. Ex.");
        SLSetup.TestField("Retention RH %");
        SLSetup.TestField("Retention RH Limit Amount");
        PurchaseLine.Reset();
        PurchaseLine.SetRange("Document Type", pPurchaseHeader."Document Type");
        PurchaseLine.SetRange("Document No.", pPurchaseHeader."No.");
        PurchaseLine.SetRange(Type, PurchaseLine.Type::"G/L Account");
        PurchaseLine.SetRange("No.", SLSetup."Retention RH GLAcc. No.");
        if PurchaseLine.FindFirst() then
            Error(ExistsLinesMessage);
    end;

    local procedure SetConfiguration()
    begin
        SLSetup.Get();
    end;

    local procedure SetDimensionIDFromPurchHdr(var PurchaseLine: Record "Purchase Line"; var PurchaseHeader: Record "Purchase Header")
    var
        DimSetEntry: Record "Dimension Set Entry";
        DimValue: Record "Dimension Value";
    begin
        DimSetEntry.Reset();
        DimSetEntry.SetRange("Dimension Set ID", PurchaseHeader."Dimension Set ID");
        if DimSetEntry.FindSet() then
            repeat
                DimValue.Reset();
                DimValue.SetRange("Dimension Code", DimSetEntry."Dimension Code");
                DimValue.SetRange(Code, DimSetEntry."Dimension Value Code");
                DimValue.SetFilter("Global Dimension No.", '>%1', 2);
                if DimValue.FindFirst() then
                    PurchaseLine.ValidateShortcutDimCode(DimValue."Global Dimension No.", DimValue.Code);
            until DimSetEntry.Next() = 0;
    end;

    procedure GetNextPreassingNo(var SerieNo: Code[20]): Code[20]
    var
        NoSerie: Record "No. Series";
        NoSerieMgt: Codeunit NoSeriesManagement;
    begin
        SetConfiguration();
        SLSetup.TestField("Retention RH Nos");
        SerieNo := SLSetup."Retention RH Nos";
        exit(NoSerieMgt.GetNextNo3(SLSetup."Retention RH Nos", Today, true, false))
    end;

    procedure CalculateRHAmount(var pPurchaseHeader: Record "Purchase Header")
    var
        PurchaseLine: Record "Purchase Line";
        GrossAmount: Decimal;
        FourthAmt: Decimal;
    begin
        if pPurchaseHeader.IsEmpty then
            exit;
        SetConfiguration();
        PurchaseLine.Reset();
        PurchaseLine.SetRange("Document Type", pPurchaseHeader."Document Type");
        PurchaseLine.SetRange("Document No.", pPurchaseHeader."No.");
        PurchaseLine.SetRange("VAT Prod. Posting Group", SLSetup."Ret. RH VAT Prod Pstg. Gr. Ex.");
        PurchaseLine.SetRange(Type, PurchaseLine.Type::"G/L Account");
        PurchaseLine.SetRange("No.", SLSetup."Retention RH GLAcc. No.");
        if PurchaseLine.FindFirst() then begin
            repeat
                FourthAmt += PurchaseLine.Amount;
            until PurchaseLine.Next() = 0;
            pPurchaseHeader.CalcFields(Amount);
            GrossAmount := pPurchaseHeader.Amount + ABS(FourthAmt);
        end else begin
            PurchaseLine.Reset();
            PurchaseLine.SetRange("Document Type", pPurchaseHeader."Document Type");
            PurchaseLine.SetRange("Document No.", pPurchaseHeader."No.");
            if PurchaseLine.FindFirst() then
                repeat
                    GrossAmount += PurchaseLine."Amount Including VAT";
                until PurchaseLine.Next() = 0;
            FourthAmt := 0;
            //GrossAmount := 0;
        end;
        pPurchaseHeader."Retention RH Fourth Amount" := FourthAmt;
        pPurchaseHeader."Retention RH Gross amount" := GrossAmount;
        //pPurchaseHeader.Modify(false);
    end;

    procedure GetPostingNo(): Code[20]
    begin
        SetConfiguration();
        SLSetup.TestField("Retention RH Posted Nos");
        exit(SLSetup."Retention RH Posted Nos")
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterInitRecord', '', false, false)]
    local procedure SetOnAfterInitRecord(var PurchHeader: Record "Purchase Header")
    begin
        if PurchHeader."Legal Document" = '02' then
            PurchHeader."Posting No. Series" := GetPostingNo();
    end;

    var
        SLSetup: Record "Setup Localization";
}