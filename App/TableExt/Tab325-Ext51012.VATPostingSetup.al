tableextension 51012 "Acc. Book VAT Posting Setup" extends "VAT Posting Setup"
{
    fields
    {
        // Add changes to table fields here
        field(51000; "Purchase Record Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "TAXED AND / OR EXPORTED","TAXED AND / OR EXPORTED AND TO OPERATIONS NOT TAXED","NOT TAXED","ISC","OTHER TAXES AND CHARGES","TAX REFUND";
            OptionCaption = 'TAXED AND / OR EXPORTED,TAXED AND / OR EXPORTED AND TO OPERATIONS NOT TAXED,NOT TAXED,ISC,OTHER TAXES AND CHARGES,TAX REFUND';
        }
        field(51001; "Sales Record Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "TAXES","EXPORTS","EXONERATED","INAFFECTS","ISC","OTHER TAXES AND CHARGES","STACKED RICE";
            OptionCaption = 'TAXES,EXPORTS,EXONERATED,INAFFECTS,ISC,OTHER TAXES AND CHARGES,STACKED RICE';
        }
    }

    var
        myInt: Integer;
}