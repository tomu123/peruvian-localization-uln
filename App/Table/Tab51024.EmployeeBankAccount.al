table 51024 "ST Employee Bank Account"
{
    Caption = 'Employee Bank Account', Comment = 'ESM="Bancos empleado"';
    DataCaptionFields = "Employee No.", "Code", Name;
    DrillDownPageID = "ST Employee Bank Account List";
    LookupPageID = "ST Employee Bank Account List";

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            NotBlank = true;
            TableRelation = Employee;
        }
        field(2; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(3; Name; Text[100])
        {
            Caption = 'Name';
        }
        field(5; "Name 2"; Text[50])
        {
            Caption = 'Name 2';
        }
        field(6; Address; Text[100])
        {
            Caption = 'Address';
        }
        field(7; "Address 2"; Text[50])
        {
            Caption = 'Address 2';
        }
        field(8; City; Text[30])
        {
            Caption = 'City';
            TableRelation = IF ("Country/Region Code" = CONST('')) "Post Code".City
            ELSE
            IF ("Country/Region Code" = FILTER(<> '')) "Post Code".City WHERE("Country/Region Code" = FIELD("Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnLookup()
            begin
                PostCode.LookupPostCode(City, "Post Code", County, "Country/Region Code");
            end;

            trigger OnValidate()
            begin
                PostCode.ValidateCity(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(9; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
            TableRelation = IF ("Country/Region Code" = CONST('')) "Post Code"
            ELSE
            IF ("Country/Region Code" = FILTER(<> '')) "Post Code" WHERE("Country/Region Code" = FIELD("Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnLookup()
            begin
                PostCode.LookupPostCode(City, "Post Code", County, "Country/Region Code");
            end;

            trigger OnValidate()
            begin
                PostCode.ValidatePostCode(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(10; Contact; Text[100])
        {
            Caption = 'Contact';
        }
        field(11; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(12; "Telex No."; Text[20])
        {
            Caption = 'Telex No.';
        }
        field(13; "Bank Branch No."; Text[20])
        {
            Caption = 'Bank Branch No.';
        }
        field(14; "Bank Account No."; Text[30])
        {
            Caption = 'Bank Account No.';
        }
        field(15; "Transit No."; Text[20])
        {
            Caption = 'Transit No.';
        }
        field(16; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(17; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";

            trigger OnValidate()
            begin
                PostCode.CheckClearPostCodeCityCounty(City, "Post Code", County, "Country/Region Code", xRec."Country/Region Code");
            end;
        }
        field(18; County; Text[30])
        {
            CaptionClass = '5,1,' + "Country/Region Code";
            Caption = 'County';
        }
        field(19; "Fax No."; Text[30])
        {
            Caption = 'Fax No.';
        }
        field(20; "Telex Answer Back"; Text[20])
        {
            Caption = 'Telex Answer Back';
        }
        field(21; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            TableRelation = Language;
        }
        field(22; "E-Mail"; Text[80])
        {
            Caption = 'Email';
            ExtendedDatatype = EMail;

            trigger OnValidate()
            var
                MailManagement: Codeunit "Mail Management";
            begin
                MailManagement.ValidateEmailAddressField("E-Mail");
            end;
        }
        field(23; "Home Page"; Text[80])
        {
            Caption = 'Home Page';
            ExtendedDatatype = URL;
        }
        field(24; IBAN; Code[50])
        {
            Caption = 'IBAN';

            trigger OnValidate()
            var
                CompanyInfo: Record "Company Information";
            begin
                CompanyInfo.CheckIBAN(IBAN);
            end;
        }
        field(25; "SWIFT Code"; Code[20])
        {
            Caption = 'SWIFT Code';
            TableRelation = "SWIFT Code";
            ValidateTableRelation = false;
        }
        field(1211; "Bank Clearing Code"; Text[50])
        {
            Caption = 'Bank Clearing Code';
        }
        field(1212; "Bank Clearing Standard"; Text[50])
        {
            Caption = 'Bank Clearing Standard';
            TableRelation = "Bank Clearing Standard";
        }
        field(51000; "Bank Account Type"; Enum "ST Bank Account Type")
        {
            DataClassification = ToBeClassified;
            Caption = 'Bank Account Type';
        }
        field(51001; "Check Manager"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Check Manager';
        }
        field(51002; "Reference Bank Acc. No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Reference Bank';
            TableRelation = "Bank Account";
            trigger OnValidate()
            begin
                if "Reference Bank Acc. No." = '' then
                    exit;
                BankAcc.Get("Reference Bank Acc. No.");
                "Currency Code" := BankAcc."Currency Code";
            end;
        }
        field(51003; "Empl. Name/Business Name"; code[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Empl. Name/Business Name';
            Editable = false;
        }
        field(51004; "Bank Account CCI"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Bank Account CCI';
        }
        field(51005; "Payment Bank Account No."; Code[20])
        {
            Caption = 'Payment Bank Account No.';

            trigger OnLookup();
            begin
                SetupLocMgt.ViewRestrictBankAccountList("Payment Bank Account No.", "Currency Code", true);
                BankAcc.Get("Payment Bank Account No.");
                "Currency Code" := BankAcc."Currency Code";

                OnAfterLookUpPaymentAccountNo(Rec, BankAcc);
            end;

            trigger OnValidate();
            begin
                BankAcc.Get("Payment Bank Account No.");
                "Currency Code" := BankAcc."Currency Code";

                OnAfterValidatePaymentAccountNo(Rec, BankAcc);
            end;
        }
        field(51006; "Bank Type Check"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Bank Type Check';
        }
    }

    keys
    {
        key(Key1; "Employee No.", "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(Brick; "Code", Name, "Phone No.", Contact)
        {
        }
    }

    trigger OnDelete()
    var
        EmplLedgerEntry: Record "Employee Ledger Entry";
        Employee: Record Employee;
    begin
        /*EmplLedgerEntry.SetRange("Employee No.", "Employee No.");
        EmplLedgerEntry.SetRange("Recipient Bank Account", Code);
        EmplLedgerEntry.SetRange(Open, true);
        if not EmplLedgerEntry.IsEmpty then
            Error(BankAccDeleteErr);
        if Employee.Get("Employee No.") and (Employee."Preferred Bank Account Code" = Code) then begin
            Employee."Preferred Bank Account Code" := '';
            Employee.Modify();
        end;*/
    end;

    var
        PostCode: Record "Post Code";
        BankAcc: Record "Bank Account";
        SetupLocMgt: Codeunit "Setup Localization";
        BankAccIdentifierIsEmptyErr: Label 'You must specify either a Bank Account No. or an IBAN.';
        BankAccDeleteErr: Label 'You cannot delete this bank account because it is associated with one or more open ledger entries.';

    procedure GetBankAccountNoWithCheck() AccountNo: Text
    begin
        AccountNo := GetBankAccountNo;
        if AccountNo = '' then
            Error(BankAccIdentifierIsEmptyErr);
    end;

    procedure GetBankAccountNo(): Text
    begin
        if IBAN <> '' then
            exit(DelChr(IBAN, '=<>'));

        if "Bank Account No." <> '' then
            exit("Bank Account No.");
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterLookUpPaymentAccountNo(var Rec: Record "ST Employee Bank Account"; var BankAcc: Record "Bank Account")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterValidatePaymentAccountNo(var Rec: Record "ST Employee Bank Account"; var BankAcc: Record "Bank Account")
    begin
    end;
}
