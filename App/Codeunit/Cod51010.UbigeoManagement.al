codeunit 51010 "Ubigeo Management"
{
    trigger OnRun()
    begin

    end;

    procedure ShowUbigeoDescription(CountryCode: Code[10]; PostCode: Code[20]; City: Text; County: Text): Text
    begin
        if CountryCode <> 'PE' then
            exit('');
        if PostCode = '' then
            exit('');
        if City = '' then
            City := '00';
        if County = '' then
            County := '00';
        Ubigeo.Reset();
        Ubigeo.SetRange("Departament Code", PostCode);
        Ubigeo.SetRange("Province Code", City);
        Ubigeo.SetRange("District Code", County);
        if Ubigeo.FindFirst() then
            exit(Ubigeo.Description);
        exit('');
    end;

    procedure Departament(CountryCode: Code[10]; PostCode: Code[20]): Text
    var
        UndefinedDepartement: Label 'Departament undefined for "Country Code" %1.', Comment = 'ESM="Departamento no definido para Cód. País %1"';
    begin
        if CountryCode <> 'PE' then
            exit(StrSubstNo(UndefinedDepartement, CountryCode));
        Ubigeo.Reset();
        Ubigeo.SetRange("Departament Code", PostCode);
        Ubigeo.SetRange("Province Code", '00');
        Ubigeo.SetRange("District Code", '00');
        Ubigeo.FindFirst();
        exit(Ubigeo.Departament);
    end;

    procedure Province(CountryCode: Code[10]; PostCode: Code[20]; City: Text): Text
    var
        UndefinedProvince: Label 'Province undefined for "Country Code" %1.', Comment = 'ESM="Provincia no definida para Cód. País %1"';
    begin
        if CountryCode <> 'PE' then
            exit(StrSubstNo(UndefinedProvince, CountryCode));
        Ubigeo.Reset();
        Ubigeo.SetRange("Departament Code", PostCode);
        Ubigeo.SetRange("Province Code", City);
        Ubigeo.SetRange("District Code", '00');
        Ubigeo.FindFirst();
        exit(Ubigeo.Province);
    end;

    procedure District(CountryCode: Code[10]; PostCode: Code[20]; City: Text; County: Text): Text
    var
        UndefinedDistrict: Label 'District undefined for "Country Code" %1.', Comment = 'ESM="Distrito no definido para Cód. País %1"';
    begin
        if CountryCode <> 'PE' then
            exit(StrSubstNo(UndefinedDistrict, CountryCode));
        Ubigeo.Reset();
        Ubigeo.SetRange("Departament Code", PostCode);
        Ubigeo.SetRange("Province Code", City);
        Ubigeo.SetRange("District Code", County);
        Ubigeo.FindFirst();
        exit(Ubigeo.District);
    end;

    //Integrations
    [EventSubscriber(ObjectType::Table, Database::"Post Code", 'OnBeforeLookupPostCode', '', false, false)]
    local procedure UbigeoLookUpCode(var CityTxt: Text; var PostCode: Code[20]; var CountyTxt: Text; var CountryCode: Code[10]; var IsHandled: Boolean)
    var
        Ubigeo: Record Ubigeo;
        UbigeoList: Page "Ubigeo List";
    begin
        //PosCode = Departamento
        //City = Provincia
        //County = County
        if CountryCode <> 'PE' then
            exit;
        IsHandled := true;
        Clear(UbigeoList);
        Ubigeo.Reset();
        Ubigeo.FilterGroup(2);
        if PostCode = '' then begin
            Ubigeo.SetRange("Province Code", '00');
            Ubigeo.SetRange("District Code", '00');
        end else begin
            Ubigeo.SetRange("Departament Code", PostCode);
            if CityTxt in ['', '00'] then begin
                Ubigeo.SetFilter("Province Code", '<>%1', '00');
                Ubigeo.SetRange("District Code", '00');
            end else begin
                Ubigeo.SetRange("Province Code", CityTxt);
                if CountyTxt in ['', '00'] then
                    Ubigeo.SetFilter("District Code", '<>%1', '00');
            end;
        end;
        Ubigeo.FilterGroup(0);
        UbigeoList.LookupMode(true);
        UbigeoList.SetTableView(Ubigeo);
        UbigeoList.SetShowDepartament();
        UbigeoList.SetRecord(Ubigeo);
        if UbigeoList.RunModal() in [Action::LookupOK, Action::OK, Action::Yes] then begin
            UbigeoList.GetRecord(Ubigeo);
            if PostCode <> Ubigeo."Departament Code" then begin
                PostCode := Ubigeo."Departament Code";
                if Ubigeo."Province Code" <> '00' then
                    CityTxt := Ubigeo."Province Code";
                if Ubigeo."District Code" <> '00' then
                    CountyTxt := Ubigeo."District Code";
                //UbigeoDescription := Ubigeo.Description;
            end;
            if CityTxt <> Ubigeo."Province Code" then begin
                if Ubigeo."Province Code" <> '00' then
                    CityTxt := Ubigeo."Province Code";
                if Ubigeo."District Code" <> '00' then
                    CountyTxt := Ubigeo."District Code";
            end;
            if CountyTxt <> Ubigeo."District Code" then
                if Ubigeo."District Code" <> '00' then
                    CountyTxt := Ubigeo."District Code";
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeLookupCity', '', false, false)]
    local procedure OnBeforeLookupCity_Table_18(var Customer: Record Customer; var PostCodeRec: Record "Post Code")
    begin
        Customer.County := '';
    end;

    var
        Ubigeo: Record Ubigeo;
}