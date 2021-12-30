tableextension 51205 "ST FA Depreciation Book" extends "FA Depreciation Book"
{
    fields
    {
        field(51000; "ST Equivalence Year %"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Equivalence Year %', Comment = 'ESM="% Equivalente"';
        }
        modify("FA Posting Group")
        {
            trigger OnBeforeValidate()
            var

            begin
                fnValidateBookValue();
            end;
        }
        field(51001; "Current Asset"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Current Asset', Comment = 'ESM="Activo en curso"';
        }
    }

    procedure fnValidateBookValue()
    var
        lclText001: Label 'Grupo Registro A/F ya cuenta con valor neto,no puede ser modificado', Comment = 'Grupo Registro A/F ya cuenta con valor neto,no puede ser modificado', MaxLength = 999, Locked = true;
    begin
        CalcFields("Book Value");

        if xRec."FA Posting Group" <> Rec."FA Posting Group" then
            if Rec."Book Value" <> 0 then
                Error(lclText001);
    end;

    var
        myInt: Integer;
}