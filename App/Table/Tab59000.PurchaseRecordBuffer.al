table 59000 "Purchase Record Buffer"
{
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
        field(59008; "DUA Document Year"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(59009; "Number Document"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(59010; "Field 10 Total Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(59011; "VAT Registration Type"; Code[1])
        {
            DataClassification = ToBeClassified;
        }
        field(59012; "VAT Registration No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(59013; "Vendor Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(59014; "Taxed Base"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(59015; "Taxed VAT"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(59016; "Untaxed Base"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(59017; "Untaxed VAT"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(59018; "Refund Base"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(59019; "Refund VAT"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(59020; "NOT Taxed VAT"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(59021; "ISC Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(59022; "Others Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(59023; "Total Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(59024; "Currency Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(51025; "Currency Amount"; decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(51026; "Mod. Document Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(59027; "Mod. Legal Document"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(59028; "Mod. Serie"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(59029; "DUA Code"; Text[10])
        {
            DataClassification = ToBeClassified;
        }
        field(59030; "Mod. Document"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(59031; "Detraction Emision Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(59032; "Detraction Operation No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(59033; "Retention Mark"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(59034; "Clas. Property and Services"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(59035; "Contract No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(59036; "Error 1"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(59037; "Error 2"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(59038; "Error 3"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(59039; "Error 4"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(59040; "Payment Cancelled"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(59041; "Status"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(59042; "Field Free"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(59043; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(59044; "Cancelled"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(59045; "Ref. Number Not Address."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(59046; "Country Residence Not Address"; code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(59047; "Foreing Residence Not Address"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(59048; "Link between taxpayer"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(59049; "Payment indicator"; Decimal)
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