xmlport 51002 "Import Rgtr. Good Contributor "
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
        textelement(GoodTaxpayer)
        {
            tableelement(GoodContributor; Vendor)
            {
                UseTemporary = true;
                fieldattribute(VatRegistration; GoodContributor."No.") { }
                fieldattribute(Name; GoodContributor."Business Name") { }
                fieldattribute(FromTheDate; GoodContributor."Name 2") { }
                fieldattribute(ResolutionNo; GoodContributor."Good Contributor Resolution")
                {
                    trigger OnAfterAssignField()
                    var
                        TimeElapsedMsg: Label '%1 minutes : %2 seconds';
                    begin
                        Vendor.Reset();
                        Vendor.SetRange("VAT Registration No.", GoodContributor."No.");
                        if Vendor.Find('-') then begin
                            Vendor."Good Contributor" := true;
                            if Evaluate(StartDate, GoodContributor."Name 2") then;
                            Vendor."Good Contributor Start Date" := StartDate;
                            Vendor."Good Contributor End Date" := 0D;
                            Vendor."Good Contributor Resolution" := GoodContributor."Good Contributor Resolution";
                            Vendor."Good contrib. File Date" := CurrentDateTime();
                            Vendor."Date last Good contrib. load" := LastUpdateDate;
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
        Vendor.SETRANGE("Good Contributor", TRUE);
        Vendor.MODIFYALL("Good Contributor End Date", CALCDATE('<-1D>', LastUpdateDate));
        Vendor.MODIFYALL("Good Contributor Start Date", 0D);
        Vendor.MODIFYALL("Good Contributor", FALSE);

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