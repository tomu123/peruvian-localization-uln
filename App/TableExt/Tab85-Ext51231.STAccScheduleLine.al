tableextension 51231 "ST Acc. Schedule Line" extends "Acc. Schedule Line"
{
    fields
    {
        //Fields ids permission 51004..51005,51030..51039,,51045..51049,51050..51061
        //Legal Document Begin
        field(51000; "Orientation"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Orientation', Comment = 'ESM="Orientación"';
            OptionMembers = ,Izquierda,Derecha;
        }
        field(51001; "Cod Financial Status"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Cod Financial Status', Comment = 'ESM="Cod Rubro Estado Financiero Sunat"';
        }


    }


    var




}