tableextension 51235 "ST  CountryRegion" extends "Country/Region"
{
    fields
    {
        field(51000; "Cod. Sunat"; Code[20])
        {
            TableRelation = "Legal Document"."Legal No." where("Option Type" = const("SUNAT Table"), "Type Code" = const('35'));
            DataClassification = ToBeClassified;
        }

    }
    var


    var
}