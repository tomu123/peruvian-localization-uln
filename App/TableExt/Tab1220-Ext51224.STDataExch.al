tableextension 51224 "ST Data Exch" extends "Data Exch."
{
    fields
    {

    }
    procedure ImportFileContentConciliation(DataExchDef: Record "Data Exch. Def"): Boolean
    var
        DataExchLineDef: Record "Data Exch. Line Def";
        RelatedRecord: RecordID;
    begin
        //ULN::PC    002 Begin Conciliación ++++
        RelatedRecord := "Related Record";
        DataExchLineDef.SetRange("Data Exch. Def Code", DataExchDef.Code);
        if DataExchLineDef.FindFirst then;

        Init;
        "Data Exch. Def Code" := DataExchDef.Code;
        "Data Exch. Line Def Code" := DataExchLineDef.Code;
        "Related Record" := RelatedRecord;

        DataExchDef.TestField("Ext. Data Handling Codeunit");
        CODEUNIT.Run(DataExchDef."Ext. Data Handling Codeunit", Rec);

        if not "File Content".HasValue then
            exit(false);

        MgtmConciliation.fnFormatConciliation(REC, DataExchDef);
        Insert;
        exit(true);
        //ULN::PC    002 Begin Conciliación ----
    end;

    procedure ImportToDataExchConciliation(DataExchDef: Record "Data Exch. Def"): Boolean
    var
        Source: InStream;
        ProgressWindow: Dialog;
    begin
        //ULN::PC    002 Begin Conciliación ++++
        if not "File Content".HasValue then
            if not ImportFileContentConciliation(DataExchDef) then
                exit(false);

        ProgressWindow.Open(ProgressWindowMsg);

        "File Content".CreateInStream(Source);
        SetRange("Entry No.", "Entry No.");
        if DataExchDef."Reading/Writing Codeunit" > 0 then
            CODEUNIT.Run(DataExchDef."Reading/Writing Codeunit", Rec)
        else begin
            DataExchDef.TestField("Reading/Writing XMLport");
            XMLPORT.Import(DataExchDef."Reading/Writing XMLport", Source, Rec);
        end;

        ProgressWindow.Close;

        exit(true);
        //ULN::PC    002 Begin Conciliación ----
    end;

    var
        ProgressWindowMsg: Label 'Please wait while the operation is being completed.', Comment = 'ESM="Espere mientras se completa la operación."';
        MgtmConciliation: Codeunit "Mgtm Conciliation";
}