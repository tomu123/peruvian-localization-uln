xmlport 51000 "Import Rgtr. Retention Agent"
{
    Direction = Import;
    //FieldDelimiter = '<>';
    FieldSeparator = '|';
    //RecordSeparator = '<NewLine>';
    TableSeparator = '<NewLine>';
    Format = VariableText;
    TextEncoding = UTF8;

    schema
    {
        textelement(WithholdingAgent)
        {
            tableelement(RetentionAgent; Vendor)
            {
                UseTemporary = true;
                XmlName = 'RetentionAgent';
                fieldelement(VatRegistration; RetentionAgent."No.") { }
                fieldelement(Name; RetentionAgent."Business Name") { }
                fieldelement(FromTheDate; RetentionAgent."Name 2") { }
                fieldelement(ResolutionNo; RetentionAgent."Retention Agent Resolution")
                {
                    trigger OnAfterAssignField()
                    var
                        TimeElapsedMsg: Label '%1 minutes : %2 seconds';
                    begin
                        // Vendor.Reset();
                        // Vendor.SetRange("VAT Registration No.", RetentionAgent."No.");
                        // if Vendor.Find('-') then begin
                        //     Vendor."Retention Agent" := true;
                        //     if Evaluate(StartDate, RetentionAgent."Name 2") then;
                        //     Vendor."Retention Agent Start Date" := StartDate;
                        //     Vendor."Retention Agent End Date" := LastUpdateDate;
                        //     Vendor."Retention Agent Resolution" := RetentionAgent."Retention Agent Resolution";
                        //     Vendor."withholding File Date" := CurrentDateTime();
                        //     Vendor."Date of last withholding load" := LastUpdateDate;
                        //     Vendor.Modify();
                        //     _Count += 1;
                        //     TimeElapsed := Round(((Time - InitialTime) / 1000), 1);
                        //     Window.Update(1, StrSubstNo(TimeElapsedMsg, Format(Round(TimeElapsed / 60, 1, '<')), Format(Round(TimeElapsed MOD 60, 1, '<'))));
                        // end;
                        //VendorBuffer := RetentionAgent;
                        //if VendorBuffer.Insert() then;
                    end;
                }

                trigger OnBeforeInsertRecord()
                var
                    myInt: Integer;
                begin

                end;

                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    VendorBuffer.Reset();
                    VendorBuffer := RetentionAgent;
                    if VendorBuffer.Insert() then;
                end;

                trigger OnAfterInsertRecord()
                begin
                    VendorBuffer.Reset();
                    VendorBuffer := RetentionAgent;
                    if VendorBuffer.Insert() then;
                end;
            }
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    field("Last SUNAT Update Date"; LastUpdateDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Last date update SUNAT', Comment = 'ESM="Ult. fecha actualización SUNAT"';
                        trigger OnValidate()
                        var
                            LastUpdateDateErr: label 'Please enter the last SUNAT update date';
                        begin
                            if LastUpdateDate = 0D then
                                Error(LastUpdateDateErr);
                        end;
                    }
                }
            }
        }

    }

    trigger OnPreXmlPort()
    begin
        Vendor.Reset();
        Vendor.SETFILTER("No.", '<>%1', '');
        Vendor.SETRANGE("Retention Agent", TRUE);
        if Vendor.FindSet() then begin
            Vendor.MODIFYALL("Retention Agent End Date", CALCDATE('<-1D>', LastUpdateDate));
            Vendor.MODIFYALL("Retention Agent Start Date", 0D);
            Vendor.MODIFYALL("Retention Agent", FALSE);
        end;


        VendorBuffer.Reset();
        VendorBuffer.DeleteAll();

        Window.OPEN(InfoCurrentTimeMsg);
        InitialTime := Time;
    end;

    trigger OnPostXmlPort()
    var
        TimeElapsedMsg: Label '%1 minutes : %2 seconds';
    begin
        VendorBuffer.Reset();
        if VendorBuffer.FindFirst() then
            repeat
                Vendor.Reset();
                if Vendor.Get(VendorBuffer."No.") then begin
                    Vendor."Retention Agent" := true;
                    if Evaluate(StartDate, VendorBuffer."Name 2") then;
                    Vendor."Retention Agent Start Date" := StartDate;
                    Vendor."Retention Agent End Date" := 0D;
                    Vendor."Retention Agent Resolution" := VendorBuffer."Retention Agent Resolution";
                    Vendor."withholding File Date" := CurrentDateTime();
                    Vendor."Date of last withholding load" := LastUpdateDate;
                    Vendor.Modify();
                    _Count += 1;
                    TimeElapsed := Round(((Time - InitialTime) / 1000), 1);
                    Window.Update(1, StrSubstNo(TimeElapsedMsg, Format(Round(TimeElapsed / 60, 1, '<')), Format(Round(TimeElapsed MOD 60, 1, '<'))));
                end;
            until VendorBuffer.Next() = 0;

        Window.Close();
        Message(InfoUpdatedRecordsMsg, _Count);
    end;

    var
        VendorBuffer: Record Vendor temporary;
        Window: Dialog;
        InitialTime: Time;
        TimeElapsed: Integer;
        InfoCurrentTimeMsg: label 'Current Time      #1######';
        _Count: Integer;
        InfoUpdatedRecordsMsg: label 'Updated %1 record(s)';
        LastUpdateDate: Date;
        StartDate: Date;
        Vendor: Record Vendor;

}