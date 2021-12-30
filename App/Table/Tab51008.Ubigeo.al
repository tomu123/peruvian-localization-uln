table 51008 "Ubigeo"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(51000; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Entry No.';
        }
        field(51001; "Departament Code"; Code[2])
        {
            DataClassification = ToBeClassified;
            Caption = 'Departament Code';
        }
        field(51002; "Departament"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Departament';
        }
        field(51003; "Province Code"; Code[2])
        {
            DataClassification = ToBeClassified;
            Caption = 'Province Code';
        }
        field(51004; "Province"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Province';
        }
        field(51005; "District Code"; Code[2])
        {
            DataClassification = ToBeClassified;
            Caption = 'District Code';
        }
        field(51006; "District"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'District';
        }
        field(51007; "Description"; Text[200])
        {
            DataClassification = ToBeClassified;
            Caption = 'Description';
        }
    }

    keys
    {
        key(PK; "Entry No.", "District Code")
        {
            Clustered = true;
        }

    }
    fieldgroups
    {
        fieldgroup(DropDown; "District Code", District, Description)
        {
        }
    }

    procedure LookUpDepartament(var DepartamentNo: Code[2]; var ProvinceNo: Code[2]; var DistrictNo: Code[2]; var UbigeoDescription: Text[200])
    var
        Ubigeo: Record Ubigeo;
        UbigeoList: Page "Ubigeo List";
    begin
        Clear(UbigeoList);
        Ubigeo.Reset();
        Ubigeo.FilterGroup(2);
        Ubigeo.SetRange("Province Code", '00');
        Ubigeo.SetRange("District Code", '00');
        Ubigeo.FilterGroup(0);
        UbigeoList.LookupMode(true);
        UbigeoList.SetTableView(Ubigeo);
        UbigeoList.SetShowDepartament();
        UbigeoList.SetRecord(Ubigeo);
        if UbigeoList.RunModal() in [Action::LookupOK, Action::OK, Action::Yes] then begin
            UbigeoList.GetRecord(Ubigeo);
            if DepartamentNo <> Ubigeo."Departament Code" then begin
                DepartamentNo := Ubigeo."Departament Code";
                ProvinceNo := '';
                DistrictNo := '';
                UbigeoDescription := Ubigeo.Description;
            end;
        end;
    end;

    procedure LookUpProvince(var DepartamentNo: Code[2]; var ProvinceNo: Code[2]; var DistrictNo: Code[2]; var UbigeoDescription: Text[200])
    var
        Ubigeo: Record Ubigeo;
        UbigeoList: Page "Ubigeo List";
    begin
        Clear(UbigeoList);
        if DepartamentNo = '' then
            exit;
        Ubigeo.Reset();
        Ubigeo.FilterGroup(2);
        Ubigeo.SetRange("Departament Code", DepartamentNo);
        Ubigeo.SetRange("District Code", '00');
        Ubigeo.FilterGroup(0);
        UbigeoList.LookupMode(true);
        UbigeoList.SetTableView(Ubigeo);
        UbigeoList.SetShowProvince();
        UbigeoList.SetRecord(Ubigeo);
        if UbigeoList.RunModal() in [Action::LookupOK, Action::OK, Action::Yes] then begin
            UbigeoList.GetRecord(Ubigeo);
            if ProvinceNo <> Ubigeo."Province Code" then begin
                ProvinceNo := Ubigeo."Province Code";
                DistrictNo := '';
                UbigeoDescription := Ubigeo.Description;
            end;
        end;
    end;

    procedure LookUpDistrict(var DepartamentNo: Code[2]; var ProvinceNo: Code[2]; var DistrictNo: Code[2]; var UbigeoDescription: Text[200])
    var
        Ubigeo: Record Ubigeo;
        UbigeoList: Page "Ubigeo List";
    begin
        Clear(UbigeoList);
        if (DepartamentNo = '') or (ProvinceNo = '') then
            exit;
        Ubigeo.Reset();
        Ubigeo.FilterGroup(2);
        Ubigeo.SetRange("Departament Code", DepartamentNo);
        Ubigeo.SetRange("Province Code", ProvinceNo);
        Ubigeo.FilterGroup(0);
        UbigeoList.LookupMode(true);
        UbigeoList.SetTableView(Ubigeo);
        UbigeoList.SetShowDistrict();
        UbigeoList.SetRecord(Ubigeo);
        if UbigeoList.RunModal() in [Action::LookupOK, Action::OK, Action::Yes] then begin
            UbigeoList.GetRecord(Ubigeo);
            if DistrictNo <> Ubigeo."District Code" then begin
                DistrictNo := Ubigeo."District Code";
                UbigeoDescription := Ubigeo.Description;
            end;
        end;
    end;

    procedure ValidateUbigeo(DepartamentNo: Code[2]; ProvinceNo: Code[2]; DistrictNo: Code[2]; var UbigeoDescription: Text[200])
    var
        Ubigeo: Record Ubigeo;
    begin
        Ubigeo.Reset();
        Ubigeo.SetRange("Departament Code", DepartamentNo);
        if ProvinceNo <> '' then
            Ubigeo.SetRange("Province Code", ProvinceNo)
        else
            Ubigeo.SetRange("Province Code", '00');
        if DistrictNo <> '' then
            Ubigeo.SetRange("District Code", DistrictNo)
        else
            Ubigeo.SetRange("District Code", '00');
        if Ubigeo.IsEmpty then
            Error(ShowErrorUbigeo);
        if Ubigeo.FindFirst() then
            UbigeoDescription := Ubigeo.Description;
    end;

    var
        ShowErrorUbigeo: label 'Ubigeo does not exist.', Comment = 'ESM="Ubigeo no existe"';

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}