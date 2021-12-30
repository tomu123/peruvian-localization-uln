xmlport 51001 "Import Rgtr. Perception Agent"
{
    Format = VariableText;
    FieldDelimiter = '<>';
    FieldSeparator = '|';
    //RecordSeparator = '<NewLine>';
    TableSeparator = '<NewLine>';
    Direction = Import;
    TextEncoding = UTF8;

    schema
    {
        textelement(CollectionAgent)
        {
            tableelement(PerceptionAgent; Vendor)
            {
                UseTemporary = true;
                fieldattribute(VatRegistration; PerceptionAgent."No.") { }
                fieldattribute(Name; PerceptionAgent."Business Name") { }
                fieldattribute(FromTheDate; PerceptionAgent."Name 2") { }

                fieldattribute(ResolutionNo; PerceptionAgent."Perception Agent Resolution")
                {
                    trigger OnAfterAssignField()
                    var
                        TimeElapsedMsg: Label '%1 minutes : %2 seconds';
                    begin
                        Vendor.Reset();
                        Vendor.SetRange("VAT Registration No.", PerceptionAgent."No.");
                        if Vendor.Find('-') then begin
                            Vendor."Perception Agent" := true;
                            if Evaluate(StartDate, PerceptionAgent."Name 2") then;
                            Vendor."Perception Agent Start Date" := StartDate;
                            Vendor."Perception Agent End Date" := 0D;
                            Vendor."Perception Agent Resolution" := PerceptionAgent."Perception Agent Resolution";
                            Vendor."Perception File Date" := CurrentDateTime();
                            Vendor."Date of last Perception load" := LastUpdateDate;
                            Vendor.Modify();
                            _Count += 1;
                            TimeElapsed := Round(((Time - InitialTime) / 1000), 1);
                            Window.Update(1, StrSubstNo(TimeElapsedMsg, Format(Round(TimeElapsed / 60, 1, '<')), Format(Round(TimeElapsed MOD 60, 1, '<'))));
                        end;

                    end;
                }
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
                        Caption = 'Last date update SUNAT';
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
        Vendor.SETRANGE("Perception Agent", TRUE);
        Vendor.MODIFYALL("Perception Agent End Date", CALCDATE('<-1D>', LastUpdateDate));
        Vendor.MODIFYALL("Perception Agent Start Date", 0D);
        Vendor.MODIFYALL("Perception Agent", FALSE);

        Window.OPEN(InfoCurrentTimeMsg);
        InitialTime := Time;
    end;

    trigger OnPostXmlPort()
    begin
        Window.Close();
        Message(InfoUpdatedRecordsMsg, _Count);
    end;

    var
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