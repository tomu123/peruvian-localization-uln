codeunit 51033 "Internal Consumption Utility"
{

    procedure SetLastSerieNoUsedToBe(VAR SalesHeader: Record "Sales Header"): Code[20]
    var
        NoSeriesManagement: Codeunit NoSeriesManagement;
        re: Record "Sales Header";
    begin
        //003
        IF SalesHeader."Posting No. Series" <> '' THEN
            EXIT(NoSeriesManagement.GetNextNo(SalesHeader."Posting No. Series", WORKDATE, FALSE))
        //003

    end;

    procedure SetLastShipmentSerieNoUsedToBe(VAR SalesHeader: Record "Sales Header"): Code[20]
    var
        NoSeriesManagement: Codeunit NoSeriesManagement;
        re: Record "Sales Header";
    begin
        //003
        IF SalesHeader."Shipping No. Series" <> '' THEN
            EXIT(NoSeriesManagement.GetNextNo(SalesHeader."Shipping No. Series", WORKDATE, FALSE))
        //003

    end;

    [EventSubscriber(ObjectType::Table, 36, 'OnAfterInsertEvent', '', false, false)]
    procedure OnAfterInsertEventPaymentTerms(var rec: Record "Sales Header"; RunTrigger: Boolean)

    var
        lcSetupLocalization: Record "Setup Localization";
    begin
        //ULN::RM.01  BEGIN
        /*lcSetupLocalization.GET;
        IF rec."Internal Consumption" THEN BEGIN
            lcSetupLocalization.TESTFIELD("Customer Int. Cons.");
            rec.VALIDATE("Sell-to Customer No.", lcSetupLocalization."Customer Int. Cons.");
            rec."Gen. Bus. Posting Group" := lcSetupLocalization."Gn. Bus. Pst. Group Int. Cons.";
            rec."Posting No. Series" := lcSetupLocalization."Serial No. Pstd. Int. Cons.";
        END;*/
        //ULN::RM.01  END
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeInitRecord', '', false, false)]
    procedure OnBeforeInitRecord_Table36(var SalesHeader: Record "Sales Header"; var IsHandled: Boolean; xSalesHeader: Record "Sales Header")
    var
        SLSetup: Record "Setup Localization";
        SalesRecSetup: Record "Sales & Receivables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        if IsInternalConsumption(SalesHeader) then
            exit;

        SLSetup.Get();
        case SalesHeader."Document Type" of
            SalesHeader."Document Type"::Invoice:
                begin
                    SLSetup.TestField("Serial No. Int. Cons.");
                    SLSetup.TestField("Serial No. Pstd. Int. Cons.");
                    SLSetup.TestField("Shipment Serial No.");
                    if (SalesHeader."No. Series" <> '') and
                       (SLSetup."Serial No. Int. Cons." = SLSetup."Serial No. Pstd. Int. Cons.")
                    then
                        SalesHeader."Posting No. Series" := SalesHeader."No. Series"
                    else
                        NoSeriesMgt.SetDefaultSeries(SalesHeader."Posting No. Series", SLSetup."Serial No. Pstd. Int. Cons.");
                    if SLSetup."Shipment Serial No." <> '' then
                        NoSeriesMgt.SetDefaultSeries(SalesHeader."Shipping No. Series", SLSetup."Shipment Serial No.");
                end;
            SalesHeader."Document Type"::"Credit Memo":
                begin
                    SalesRecSetup.Get();
                    SalesRecSetup.TestField("Posted Return Receipt Nos.");
                    SLSetup.TestField("Serial No. Int. Cons. Rtn");
                    SLSetup.TestField("Serial No. Pstd. Int.Cons. Rtn");
                    SLSetup.TestField("Return Shipment Serial No.");
                    SalesHeader."Return Receipt No. Series" := SLSetup."Return Shipment Serial No.";
                    if (SalesHeader."No. Series" <> '') and
                       (SLSetup."Serial No. Int. Cons. Rtn" = SLSetup."Serial No. Pstd. Int.Cons. Rtn")
                    then
                        SalesHeader."Posting No. Series" := SalesHeader."No. Series"
                    else
                        NoSeriesMgt.SetDefaultSeries(SalesHeader."Posting No. Series", SLSetup."Serial No. Pstd. Int.Cons. Rtn");
                    if SLSetup."Shipment Serial No." <> '' then
                        NoSeriesMgt.SetDefaultSeries(SalesHeader."Shipping No. Series", SLSetup."Shipment Serial No.");
                end;
        end;
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeInitInsert', '', false, false)]
    procedure OnBeforeInitInsert(var SalesHeader: Record "Sales Header"; xSalesHeader: Record "Sales Header"; var IsHandled: Boolean)
    var
        SLSetup: Record "Setup Localization";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        if IsInternalConsumption(SalesHeader) then
            exit;
        SLSetup.Get();
        SLSetup.TestField("Customer Int. Cons.");
        case SalesHeader."Document Type" of
            SalesHeader."Document Type"::Invoice:
                begin
                    SLSetup.TestField("Serial No. Int. Cons.");

                    SalesHeader."No. Series" := SLSetup."Serial No. Int. Cons.";
                    SalesHeader."No." := NoSeriesMgt.GetNextNo3(SalesHeader."No. Series", Today, true, true);
                end;
            SalesHeader."Document Type"::"Credit Memo":
                begin
                    SLSetup.TestField("Serial No. Int. Cons. Rtn");
                    SalesHeader."No. Series" := SLSetup."Serial No. Int. Cons. Rtn";
                    SalesHeader."No." := NoSeriesMgt.GetNextNo3(SalesHeader."No. Series", Today, true, true);
                end;
        end;
        if (SLSetup."Customer Int. Cons." <> '') and (SalesHeader."Sell-to Customer No." = '') then
            SalesHeader.Validate("Sell-to Customer No.", SLSetup."Customer Int. Cons.");
        IsHandled := true;
    end;

    local procedure IsInternalConsumption(var SalesHeader: Record "Sales Header"): Boolean
    begin
        exit(not (SalesHeader."Document Type" in [SalesHeader."Document Type"::Invoice,
                                            SalesHeader."Document Type"::"Credit Memo"])
            or (not SalesHeader."Internal Consumption"));
    end;
}