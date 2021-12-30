tableextension 51145 "ST Employee" extends Employee
{
    fields
    {
        // Add changes to table fields here 51005..51015
        //Legal Document Begin
        field(51000; "VAT Registration Type"; Code[2])
        {
            DataClassification = ToBeClassified;
            Caption = 'VAT Registration Type', Comment = 'ESM="Tipo Doc. Identidad"';
            TableRelation = "Legal Document"."Legal No." where("Option Type" = const("SUNAT Table"), "Type Code" = const('02'));
            ValidateTableRelation = false;
            trigger OnValidate()
            begin
                ValidateVATRegistration();
            end;
        }
        field(51001; "VAT Registration No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'VAT Registration No.', Comment = 'ESM="N° Doc. Identidad"';
            trigger OnValidate()
            begin
                ValidateVATRegistration();
            end;
        }
        //Legal Document End
        field(51005; "Preferred Bank Account Code MN"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Preferred Bank Account Code MN', Comment = 'ESM="Cód. Banco. Preferencia MN"';
            TableRelation = "ST Employee Bank Account".Code where("Employee No." = field("No."));
        }
        field(51006; "Preferred Bank Account Code ME"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Preferred Bank Account Code ME', Comment = 'ESM="Cód. Banco. Preferencia ME"';
            TableRelation = "ST Employee Bank Account".Code where("Employee No." = field("No."));
        }
        //Ubigeo
        modify(County)
        {
            TableRelation = Ubigeo."District Code" where("Province Code" = field(City), "Departament Code" = field("Post Code"));
        }
    }

    local procedure GetEncriptedPassword()
    var
        EncryptedPassword: Text;
    begin
        EncryptedPassword := Encrypt('Renatto');
    end;

    var
        ErrorVatRegistrationNo: Label 'The length of the document does not meet the required length and format.', Comment = 'ESM="El numero de documento no cumple con el formato requerido."';

    local procedure ValidateVATRegistration()
    begin
        if "VAT Registration No." <> '' then
            if (("VAT Registration Type" <> '') and ("VAT Registration Type" = '1') and (StrLen("VAT Registration No.") <> 8)) or
                (("VAT Registration Type" <> '') and ("VAT Registration Type" = '6') and (StrLen("VAT Registration No.") <> 11)) then
                Error(ErrorVatRegistrationNo);
    end;

}