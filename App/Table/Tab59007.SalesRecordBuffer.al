table 59007 "Sales Record Buffer"
{//ULN::PC    003 New Object
    DataClassification = ToBeClassified;

    fields
    {
        field(59000; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }

        field(59001; "Period"; Text[12])
        {
            DataClassification = ToBeClassified;
        }

        field(59002; "Transaction CUO"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(59003; "Correlative cuo"; Code[20])
        {
            DataClassification = ToBeClassified;
        }

        field(59004; "Document Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(59005; "Payment Due Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(59006; "Legal Document"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(59007; "Serie Document"; Code[10])
        {
            DataClassification = ToBeClassified;
        }

        field(59008; "Number Document"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(59009; "Field 9 Total Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(59010; "VAT Registration Type"; Code[1])
        {
            DataClassification = ToBeClassified;
        }
        field(59011; "VAT Registration No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(59012; "Customer Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(59013; "Amount Export invoiced"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(59014; "Taxed Base"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(59015; "Taxed Base Discount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(59016; "Taxed VAT"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(59017; "Disc. Municipal Promotion Tax"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(59018; "Total Amount Exonerated"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(59019; "Total Amount Unaffected"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(59020; "ISC Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(59021; "Taxed Stacked Rice"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(59022; "Taxed VAT  Stacked Rice"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(59023; "Bag tax"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(59024; "Others Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(59025; "Total Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }

        field(59026; "Currency Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(59027; "Currency Amount"; decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(59028; "Mod. Document Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(59029; "Mod. Legal Document"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(59030; "Mod. Serie"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(59031; "Mod. Document"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(59032; "Contract Identification"; Code[20])
        {
            DataClassification = ToBeClassified;
        }

        field(59033; "Error 1"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(59034; "Payment indicator"; Decimal)
        {
            DataClassification = ToBeClassified;
        }

        field(59035; "Status"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(59036; "Field Free"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(59037; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

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