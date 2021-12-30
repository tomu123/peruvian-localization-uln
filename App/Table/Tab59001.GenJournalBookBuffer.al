table 59001 "Gen. Journal Book Buffer"
{
    DataClassification = ToBeClassified;
    Caption = 'Gen. Journal Book', Comment = 'ESM="Libros Diario & Mayor"';

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
        field(59004; "G/L Account No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'G/L Account No.', Comment = 'ESM="N° Cuenta"';
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting), Blocked = CONST(false));
        }
        field(59005; "Unit Operation Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(59006; "Center Cost Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(59007; "Currency Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(59008; "VAT Registration Type"; Code[1])
        {
            DataClassification = ToBeClassified;
            Caption = 'VAT Registration Type', Comment = 'ESM="Tipo Doc. Identidad"';
            TableRelation = "Legal Document"."Legal No." where("Option Type" = const("SUNAT Table"), "Type Code" = const('02'));
            ValidateTableRelation = false;
        }
        field(59009; "VAT Registration No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'VAT Registration No.', Comment = 'ESM="RUC"';
        }
        field(59010; "Legal Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Legal Document No.', Comment = 'ESM="Documento Legal"';
            TableRelation = "Legal Document"."Legal No." where("Option Type" = const("SUNAT Table"), "Type Code" = const('10'));
            ValidateTableRelation = false;
        }
        field(59011; "Serie Document"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(59012; "Number Document"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(59013; "Account Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(59014; "Due Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(59015; "Operation Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(59016; "Gloss and description"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(59017; "Gloss an description ref."; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(59018; "Debit Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(59019; "Credit Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(59020; "Estructure Data"; Text[92])
        {
            DataClassification = ToBeClassified;
        }
        field(59021; "Operation Status"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(59022; "Free Field"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(59023; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(59024; "Field Additional"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(59025; "G/L Account Name"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(59026; "Book Code Ref"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(59027; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(59028; "Transaction No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(59029; "Source Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(59030; "Legal Document"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(59031; "Posting Date Filter"; Date)
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
        key(PK2; "G/L Account No.", "Posting Date")
        {

        }
        key(PK3; "Posting Date", "Transaction No.")
        {

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