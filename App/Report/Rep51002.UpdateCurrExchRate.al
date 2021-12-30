report 51002 "AER Update Curr. Exch. Rate"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;
    Caption = 'Currency Update - SUNAT', Comment = 'ESM="Obtener tipo cambio SUNAT"';
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    Caption = 'Information Date', Comment = 'ESM="Información fecha"';
                    /*field(Day; Day)
                    {
                        ApplicationArea = All;
                    }
                    field(Month; Month)
                    {
                        ApplicationArea = All;
                    }
                    field(Year; Year)
                    {
                        ApplicationArea = All;
                    }*/
                    field(PostingDate; PostingDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Posting Date', Comment = 'ESM="Fecha tipo cambio"';
                    }
                }
            }
        }
    }
    trigger OnInitReport()
    var
        myInt: Integer;
    begin
        Day := Date2DMY(TODAY, 1);
        Month := Date2DMY(TODAY, 2);
        Year := Date2DMY(TODAY, 3);
        PostingDate := Today;
    end;

    trigger OnPostReport()
    begin
        CallUpdateCurrency();
    end;

    procedure CallUpdateCurrency()
    var
        UnExistsDate: Label 'Posting date undefined.', Comment = 'ESM="Fecha de tipo de cambio no definido"';
    begin
        if (HideDialog) and (PostingDate = 0D) then
            exit
        else
            if (PostingDate = 0D) then
                Error('Fecha de registro no definida.');

        Day := Date2DMY(PostingDate, 1);
        Month := Date2DMY(PostingDate, 2);
        Year := Date2DMY(PostingDate, 3);
        Day2 := Day;
        Month2 := Month;
        Year2 := Year;
        WHILE NOT Flag DO BEGIN
            UpdateCurrency;
            IF NOT Flag THEN BEGIN
                IF Day > 1 THEN BEGIN
                    Day += -1;
                END ELSE
                    IF Month > 1 THEN BEGIN
                        Month += -1;
                        Day := Date2DMY(CALCDATE('<CM>', DMY2DATE(Day, Month, Year)), 1);
                    END ELSE BEGIN
                        Day := 31;
                        Month := 12;
                        Year += -1;
                    END;
            END;
        END;
        if not HideDialog then
            Message(Currency);
    end;

    procedure UpdateCurrency()
    begin
        Clear(HttpResponseMessage1);
        Clear(BigText1);
        Clear(Result);
        HttpClient1.Clear();
        HttpClient1.SetBaseAddress('https://e-consulta.sunat.gob.pe/cl-at-ittipcam/tcS01Alias');
        //e-consulta.sunat.gob.pe
        //www.sunat.gob.pe
        HttpClient1.Get('https://e-consulta.sunat.gob.pe/cl-at-ittipcam/tcS01Alias' + FORMAT(PostingDate, 0, '?mes=<Month,2>&anho=<Year4>'), HttpResponseMessage1);

        if HttpResponseMessage1.Content.ReadAs(Result) then begin
            BigText1.AddText(Result);
            TempBlob.CreateOutStream(OutsStream, TextEncoding::UTF8);
            BigText1.Write(OutsStream);
            TempBlob.CreateInStream(InsStream);
            Numerador := 0;
            TempBlob.CreateOutStream(OutStream2, TextEncoding::UTF8);
            TempBlob.CreateInStream(InStream2);
            WHILE NOT InsStream.EOS DO BEGIN
                InsStream.READTEXT(String);
                String := DELCHR(String, '=', DelChr(String, '=', '=/"<>.1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'));
                OutStream2.WriteText(String);
                OutStream2.WriteText;
                //gFile.WRITE(gString);
            END;
            Numerador := 0;
            Counter := 0;
            Inserted := TRUE;
            repeat
                /*                 if (Counter = 1) then
                                    Numerador := 1; */
                InStream2.ReadText(String);
                if STRPOS(String, '</html>') <> 0 then
                    Inserted := FALSE;
                if STRPOS(String, '<strong>' + FORMAT(Day) + '</strong>') <> 0 then begin
                    Numerador := 1;
                end;
                if Numerador = 2 then begin
                    IF STRPOS(String, 'class="tne10">') <> 0 THEN
                        Numerador := 3;
                end;
                if Numerador = 1 then begin
                    IF STRPOS(String, 'class="tne10">') <> 0 THEN
                        Numerador := 2;
                end;

                if Numerador = 3 then begin
                    if STRPOS(String, 'class="tne10">') = 0 then begin
                        texValor := COPYSTR(String, 1, 25);
                    end;
                    TCFIN := TRUE;
                    Counter += 1;
                end;
                if (texValor <> '') AND (TCFIN) AND (Inserted) then begin
                    Texto := texValor;
                    CurrencyExchangeRate.RESET;
                    CurrencyExchangeRate.SETRANGE("Currency Code", 'USD');
                    CurrencyExchangeRate.SETRANGE("Starting Date", DMY2DATE(Day2, Month2, Year2));
                    if CurrencyExchangeRate.FINDSET then begin
                        EVALUATE(CurrencyExchangeRate."Relational Exch. Rate Amount", texValor);
                        EVALUATE(CurrencyExchangeRate."Relational Adjmt Exch Rate Amt", texValor);
                        CurrencyExchangeRate.MODIFY;
                        Flag := TRUE;
                        Currency := texValor;
                    end else begin
                        CurrencyExchangeRate.INIT;
                        CurrencyExchangeRate.VALIDATE("Currency Code", 'USD');
                        CurrencyExchangeRate."Starting Date" := DMY2DATE(Day2, Month2, Year2);
                        CurrencyExchangeRate.VALIDATE(CurrencyExchangeRate."Exchange Rate Amount", 1);
                        EVALUATE(CurrencyExchangeRate."Relational Exch. Rate Amount", texValor);
                        CurrencyExchangeRate.VALIDATE("Adjustment Exch. Rate Amount", 1);
                        EVALUATE(CurrencyExchangeRate."Relational Adjmt Exch Rate Amt", texValor);
                        CurrencyExchangeRate.INSERT;
                        Flag := TRUE;
                        Currency := texValor;
                    end;
                    texValor := '';
                    //Writing in Journal
                    NumPos := 1;
                    CLEAR(TextArray);
                    for I := 1 to STRLEN(Texto) do begin
                        if COPYSTR(Texto, I, 1) = '|' then
                            NumPos += 1
                        else
                            TextArray[NumPos] := TextArray[NumPos] + COPYSTR(Texto, I, 1);
                    end;
                    TCFIN := FALSE;
                    Numerador := 0;
                end;
            until (Flag = true) or (InStream2.EOS = true);
        end;
    end;

    var
        PostingDate: Date;
        Day: Integer;
        Month: Integer;
        Year: Integer;
        Day2: Integer;
        Month2: Integer;
        Year2: Integer;

        BigText1: BigText;
        HttpResponseMessage1: HttpResponseMessage;
        Result: Text;
        HttpClient1: HttpClient;
        StringDate: Text;
        TempBlob: Codeunit "Temp Blob";
        OutsStream: OutStream;
        OutStream2: OutStream;
        InsStream: InStream;
        InStream2: InStream;
        String: Text;
        Numerador: Integer;
        Counter: Integer;
        Inserted: Boolean;
        HideDialog: Boolean;
        texValor: Text;
        TCFIN: Boolean;
        Texto: Text;
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        Flag: Boolean;
        Currency: Text;
        NumPos: Integer;
        I: Integer;
        TextArray: array[15] of Text;

    procedure SetHideDialog()
    begin
        HideDialog := true;
    end;

    procedure SetPostingDate()
    begin
        PostingDate := Today;
    end;
}