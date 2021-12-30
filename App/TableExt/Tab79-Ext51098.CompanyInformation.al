tableextension 51098 "LD Company Information" extends "Company Information"
{
    fields
    {
        // Add changes to table fields here
        field(51002; "VAT Registration Type"; Code[2])
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

        //Ubigeo
        modify(County)
        {
            TableRelation = Ubigeo."District Code" where("Province Code" = field(City), "Departament Code" = field("Post Code"));
        }
    }

    local procedure ValidateVATRegistration()
    begin
        if "VAT Registration No." <> '' then
            if (("VAT Registration Type" <> '') and ("VAT Registration Type" = '1') and (StrLen("VAT Registration No.") <> 8)) or
                (("VAT Registration Type" <> '') and ("VAT Registration Type" = '6') and (StrLen("VAT Registration No.") <> 11)) then
                Error(ErrorVatRegistrationNo);
    end;

    var
        ErrorVatRegistrationNo: Label 'The length of the document does not meet the required length and format.', Comment = 'ESM="El numero de documento no cumple con el formato requerido."';
}