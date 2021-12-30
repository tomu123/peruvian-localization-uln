tableextension 51164 "ST Document Attachment" extends "Document Attachment"
{
    fields
    {
        // Add changes to table fields here 51000..51005
        field(51000; "ST Reference Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Reference Document No.', Comment = 'ESM="N° Documento Referencia"';
        }
    }
}