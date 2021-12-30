tableextension 51188 "LU Source Code" extends "Source Code"
{
    fields
    {
        // Add changes to table fields here 51000..51010
        field(51000; "Input / output"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Input / Output', Comment = 'ESM="Ingreso/Salida"';
            OptionMembers = " ","Input","Output";
            OptionCaption = ' ,Ingreso,Salida';
        }
    }

    var
        myInt: Integer;
}