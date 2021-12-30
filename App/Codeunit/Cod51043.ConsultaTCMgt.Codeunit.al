codeunit 51043 "Consulta TC Mgt."
{
    TableNo = "Job Queue Entry";
    trigger OnRun()
    begin
        SetPeruvianLocalization();
        CurrencyCode := Rec."Parameter String";
        CurrencyDate := Today;
        ConsumeService()
    end;

    procedure GetCurrencyAmount()
    begin
        SetPeruvianLocalization();
        ConsumeService()
    end;

    local procedure CreateXmlFile()
    begin
        Clear(XmlFile);
        XmlFile := '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:cur="urn:microsoft-dynamics-schemas/codeunit/CurrencyTypeSunatAndSBS" xmlns:x50="urn:microsoft-dynamics-nav/xmlports/x50001" xmlns:x501="urn:microsoft-dynamics-nav/xmlports/x50000">';
        XmlFile += '   <soapenv:Header/>';
        XmlFile += '   <soapenv:Body>';
        XmlFile += '      <cur:GetCurrencyExchange>';
        XmlFile += '         <cur:xMLRequest>';
        XmlFile += '            <x50:Currency_Code>' + CurrencyCode + '</x50:Currency_Code>';
        XmlFile += '            <x50:Source_Type>' + Format(SLSetup."ST Source TC") + '</x50:Source_Type>';
        XmlFile += '            <x50:Currency_Date>' + Format(CurrencyDate, 10, '<month,2>/<day,2>/<year,2>') + '</x50:Currency_Date>';
        XmlFile += '         </cur:xMLRequest>';
        XmlFile += '         <cur:xMLResponss>';
        XmlFile += '         </cur:xMLResponss>';
        XmlFile += '      </cur:GetCurrencyExchange>';
        XmlFile += '   </soapenv:Body>';
        XmlFile += '</soapenv:Envelope>';
    end;

    /*        XmlFile += '           <x501:ExchangeRate>';
        XmlFile += '             <x501:RequestDate>?</x501:RequestDate>';
        XmlFile += '             <x501:PurchaseAmount>?</x501:PurchaseAmount>';
        XmlFile += '             <x501:SalesAmount>?</x501:SalesAmount>';
        XmlFile += '             <x501:CurrencyCode>?</x501:CurrencyCode>';
        XmlFile += '             <x501:DateSBS>?</x501:DateSBS>';
        XmlFile += '             <x501:DateSUNAT>?</x501:DateSUNAT>';
        XmlFile += '           </x501:ExchangeRate>';*/

    local procedure ConsumeService()
    var
        HttpContent: HttpContent;
        HttpHeadersContent: HttpHeaders;
        HttpClient: HttpClient;
        HttpRequestMessagex: HttpRequestMessage;
        HttpResponse: HttpResponseMessage;
        Lenght: Integer;
    begin
        IsOk := false;
        SetInitParametersServices();
        CreateXmlFile();
        HttpContent.WriteFrom(XmlFile);
        HttpContent.GetHeaders(HttpHeadersContent);
        HttpHeadersContent.Remove('Content-Type');
        HttpHeadersContent.Add('Content-Type', 'text/xml;charset=utf-8');
        HttpHeadersContent.Add('SOAPAction', SOAPAction);
        HttpClient.SetBaseAddress(Url);
        HttpClient.DefaultRequestHeaders.Add('Authorization', StrSubstNo('Basic %1', Base64String));
        HttpClient.Post(Url, HttpContent, HttpResponse);
        if HttpResponse.IsSuccessStatusCode then begin
            HttpContent.Clear();
            HttpContent := HttpResponse.Content();
            HttpContent.ReadAs(ResponseText);
            IsOk := true;
            GetResponse();
        end else begin
            HttpContent.Clear();
            HttpContent := HttpResponse.Content();
            HttpContent.ReadAs(ResponseText);
            IsOk := false;
            GetResponse();
        end;
    end;

    local procedure GetResponse()
    var
        XMLBuffer: Record "XML Buffer" temporary;
        XMLBufferPage: Page "ULN Page Buffer XML";
        CurrExchRate: Record "Currency Exchange Rate";
        CurrencyCode: Code[20];
        DateSunat: Date;
        SalesAmount: Decimal;
        MonthTxt: Text;
        DayTxt: Text;
        YearTxt: Text;
        MonthInt: Integer;
        DayInt: Integer;
        YearInt: Integer;
    begin
        Clear(XMLBuffer);
        XMLBuffer.LoadFromText(ResponseText);

        if IsOk then begin
            XMLBuffer.Reset();
            if XMLBuffer.FindFirst() then
                repeat
                    case XMLBuffer.Path of
                        '/Soap:Envelope/Soap:Body/GetCurrencyExchange_Result/xMLResponss/ExchangeRate/CurrencyCode':
                            CurrencyCode := XMLBuffer.Value;
                        '/Soap:Envelope/Soap:Body/GetCurrencyExchange_Result/xMLResponss/ExchangeRate/DateSUNAT':
                            begin
                                //08/18/19
                                if StrLen(XMLBuffer.Value) = 8 then begin
                                    MonthTxt := CopyStr(XMLBuffer.Value, 1, 2);
                                    DayTxt := CopyStr(XMLBuffer.Value, 4, 2);
                                    YearTxt := CopyStr(XMLBuffer.Value, 7, 2);
                                    YearTxt := '20' + YearTxt;
                                    Evaluate(DayInt, DayTxt);
                                    Evaluate(MonthInt, MonthTxt);
                                    Evaluate(YearInt, YearTxt);
                                    Evaluate(DateSunat, Format(DMY2Date(DayInt, MonthInt, YearInt)));
                                end;
                            end;

                        '/Soap:Envelope/Soap:Body/GetCurrencyExchange_Result/xMLResponss/ExchangeRate/SalesAmount':
                            Evaluate(SalesAmount, XMLBuffer.Value);
                    end;
                until XMLBuffer.Next() = 0;

            if (CurrencyCode = '') or (DateSunat = 0D) or (SalesAmount = 0) then
                exit;

            CurrExchRate.Reset();
            CurrExchRate.SetRange("Currency Code", CurrencyCode);
            CurrExchRate.SetRange("Starting Date", DateSunat);
            if CurrExchRate.IsEmpty then begin
                CurrExchRate.Init();
                CurrExchRate."Currency Code" := CurrencyCode;
                CurrExchRate."Starting Date" := CurrencyDate;
                CurrExchRate."Exchange Rate Amount" := 1.0;
                CurrExchRate."Relational Exch. Rate Amount" := SalesAmount;
                CurrExchRate."Adjustment Exch. Rate Amount" := 1.0;
                CurrExchRate."Relational Adjmt Exch Rate Amt" := SalesAmount;
                CurrExchRate."Fix Exchange Rate Amount" := CurrExchRate."Fix Exchange Rate Amount"::Currency;
                CurrExchRate.Insert();
                if GuiAllowed then
                    Message('El tipo de cambio %1 para la dívisa %2 fue registrado para la fecha %3.', SalesAmount, CurrencyCode, CurrencyDate);
            end else begin
                CurrExchRate.FindFirst();
                CurrExchRate."Exchange Rate Amount" := 1.0;
                CurrExchRate."Relational Exch. Rate Amount" := SalesAmount;
                CurrExchRate."Adjustment Exch. Rate Amount" := 1.0;
                CurrExchRate."Relational Adjmt Exch Rate Amt" := SalesAmount;
                CurrExchRate."Fix Exchange Rate Amount" := CurrExchRate."Fix Exchange Rate Amount"::Currency;
                CurrExchRate.Modify();
                if GuiAllowed then
                    Message('El tipo de cambio %1 para la dívisa %2 fue actualizado para la fecha %3.', SalesAmount, CurrencyCode, CurrencyDate);
            end;
        end else begin
            XMLBuffer.Reset();
            XMLBuffer.SetRange(Path, '/s:Envelope/s:Body/s:Fault/detail/string');
            if XMLBuffer.FindFirst() then
                Message(XMLBuffer.Value)
            else
                Message(ResponseText);
        end;

        // Clear(XMLBufferPage);
        // XMLBufferPage.SetTempRecord(XMLBuffer);
        // XMLBufferPage.RunModal();
    end;

    local procedure SetInitParametersServices()
    var
        Base64Convert: Codeunit "Base64 Convert";
        AuthorizationString: Text;
    begin
        Url := 'http://13.92.233.220:7047/BC130-TAXPAYER/WS/CONSULTA%20RUC/Codeunit/CurrencyTypeSunatAndSBS';
        //SLSetup."ST URL Service Consulta TC";
        SoapAction := 'GetCurrencyExchange';
        AuthorizationString := strsubstNo('%1:%2', 'ULN', 'a123456A');
        Base64String := Base64Convert.ToBase64(AuthorizationString);
    end;

    local procedure SetPeruvianLocalization()
    begin
        SLSetup.Get();
        SLSetup.TestField("ST URL Service Consulta TC");
    end;

    procedure SetParameters(pCurrencyCode: Code[10]; pCurrencyDate: Date)
    begin
        CurrencyCode := pCurrencyCode;
        CurrencyDate := pCurrencyDate;
    end;

    procedure SetStartDate()
    var
        SetDatePage: Page "Analitycs Set Date";
    begin
        Clear(SetDatePage);
        SetDatePage.SetOnlyStartDate();
        SetDatePage.RunModal();
        SetDatePage.GetStartDate(CurrencyDate)
    end;

    procedure SetShowMessage()
    begin
        ShowMessage := true;
    end;

    var
        SLSetup: Record "Setup Localization";
        ResponseText: Text;
        CurrencyCode: Code[10];
        CurrencyDate: Date;
        XmlFile: Text;
        Url: Text;
        Base64String: Text;
        SOAPAction: Text;
        ShowMessage: Boolean;
        IsOk: Boolean;
}