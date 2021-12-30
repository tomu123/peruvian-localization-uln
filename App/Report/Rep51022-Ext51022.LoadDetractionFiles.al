report 51022 "Detrac. Load Detraction File"
{
    Caption = 'Load Detraction File', Comment = 'ESM="Cargar archivo detracción"';
    Permissions = TableData "Purch. Inv. Header" = rimd;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Integer"; "Integer")
        {

            trigger OnAfterGetRecord();
            begin

                Count_ += 1;

                fnInitValues;

                for DataInt := 1 to 16 do begin
                    DataTxt_[DataInt] := '';
                    if CSVBuffer.Get(Number, DataInt) then begin
                        DataTxt_[DataInt] := UpperCase(CSVBuffer.Value);
                        DataTxt_[DataInt] := DelChr(DataTxt_[DataInt], '<>');
                    end;
                end;

                DataTxt_[5] := CopyStr(DataTxt_[5], 1, 20);

                PurchInvHeader.Reset();
                PurchInvHeader.SetRange("Buy-from Vendor No.", DataTxt_[5]);
                PurchInvHeader.SetRange("Legal Status", PurchInvHeader."Legal Status"::Success);
                if ((StrPos(DataTxt_[15], 'F') > 0) or (StrPos(DataTxt_[15], 'E') > 0)) then
                    PurchInvHeader.SetFilter("Vendor Invoice No.", DataTxt_[15] + '*-*' + DataTxt_[16])
                else
                    PurchInvHeader.SetFilter("Vendor Invoice No.", '*' + DataTxt_[15] + '*-*' + DataTxt_[16]);
                if PurchInvHeader.FindSet() then begin
                    Evaluate(PurchInvHeader."Purch Date Detraction", DataTxt_[10]);
                    PurchInvHeader."Purch. Detraction Operation" := DataTxt_[3];
                    PurchInvHeader.Modify();
                    Count_Modify += 1;
                end;
            end;

            trigger OnPreDataItem();
            begin
                FirstLine := 2;
                if CSVBuffer.Find('+') then
                    SetRange(Number, FirstLine, CSVBuffer."Line No.");

                Count_Row := CSVBuffer."Line No.";
                Count_Modify := 0;
                Count_ := 0;
            end;
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
                    Caption = 'Options', comment = 'ESM="Opciones"';
                    field(FileName; FileName)
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Caption = 'File name', Comment = 'ESM="Nombre de archivo"';
                        trigger OnAssistEdit()
                        var
                            CSVInStream: InStream;
                            TempBloblocal: Codeunit "Temp Blob";
                        begin
                            FileName := FileMgt.BLOBImportWithFilter(
                            TempBlob, ImportTxt, FileName, StrSubstNo(FileDialogTxt, FilterTxt), FilterTxt);
                            TempBlob.CreateInStream(CSVInStream);
                            CSVBuffer.Reset();
                            CSVBuffer.DeleteAll();
                            CSVBuffer.LoadDataFromStream(CSVInStream, ',');
                        end;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport();
    begin

    end;

    trigger OnPostReport()
    begin
        if Count_Row <> 0 then
            Message('Se han Actualizado Correctamente ' + Format(Count_Modify) + ' de ' + Format(Count_Row) + ' Registros');
        Clear(CSVBuffer);
    end;

    var
        CSVBuffer: Record "CSV Buffer" temporary;
        UploadResult: Boolean;
        FileName: Text[250];
        FileMgt: Codeunit "File Management";
        TempBlob: Codeunit "Temp Blob";
        FirstLine: Integer;
        DataTxt_: array[17] of Text;
        DataInt: Integer;
        FileDialogTxt: Label 'Attachments (%1)|%1', Comment = 'ESM="Archivos adjuntos (%1)|%1"';
        FilterTxt: Label '*.csv', Locked = true;
        ImportTxt: Label 'Attach a document.', Comment = 'ESM="Adjuntar un archivo"';
        PurchInvHeader: Record "Purch. Inv. Header";
        Count_Row: Integer;
        Count_: Integer;
        Count_Modify: Integer;

    procedure fnInitValues();
    begin
        CLEAR(DataTxt_);
    end;
}

