report 51064 "ST Chart of Accounts"
{
    // version NAVW17.10

    // No. yyyy.mm.dd  Developer Company    DocNo.       Version     Description
    // -----------------------------------------------------------------------------------------------------
    // 001 2016 05 24  LOF       ULN                     V.001       Add condition for Cierre Anual
    DefaultLayout = RDLC;
    RDLCLayout = './App/Report/RDLC/Chart of Accounts.rdl';
    Caption = 'Chart of Accounts', Comment = 'ESM="Atria - Asiento de Cierre y Apertura"';
    UsageCategory = Administration;
    ApplicationArea = All;
    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "Date Filter";
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO; CurrReport.PAGENO)
            {
            }
            column(G_L_Account__TABLECAPTION__________GLFilter; TABLECAPTION + ': ' + GLFilter)
            {
            }
            column(GLFilter; GLFilter)
            {
            }
            column(Chart_of_AccountsCaption; Chart_of_AccountsCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(G_L_Account___No__Caption; FIELDCAPTION("No."))
            {
            }
            column(PADSTR_____G_L_Account__Indentation___2___G_L_Account__NameCaption; PADSTR_____G_L_Account__Indentation___2___G_L_Account__NameCaptionLbl)
            {
            }
            column(G_L_Account___Income_Balance_Caption; G_L_Account___Income_Balance_CaptionLbl)
            {
            }
            column(G_L_Account___Account_Type_Caption; G_L_Account___Account_Type_CaptionLbl)
            {
            }
            column(G_L_Account__TotalingCaption; G_L_Account__TotalingCaptionLbl)
            {
            }
            column(G_L_Account___Gen__Posting_Type_Caption; G_L_Account___Gen__Posting_Type_CaptionLbl)
            {
            }
            column(G_L_Account___Gen__Bus__Posting_Group_Caption; G_L_Account___Gen__Bus__Posting_Group_CaptionLbl)
            {
            }
            column(G_L_Account___Gen__Prod__Posting_Group_Caption; G_L_Account___Gen__Prod__Posting_Group_CaptionLbl)
            {
            }
            column(G_L_Account___Direct_Posting_Caption; G_L_Account___Direct_Posting_CaptionLbl)
            {
            }
            column(G_L_Account___Consol__Translation_Method_Caption; G_L_Account___Consol__Translation_Method_CaptionLbl)
            {
            }
            dataitem(BlankLineCounter; Integer)
            {
                DataItemTableView = SORTING(Number);

                trigger OnPreDataItem()
                begin
                    SETRANGE(Number, 1, "G/L Account"."No. of Blank Lines");
                end;
            }
            dataitem(DataItem5444; Integer)
            {
                DataItemTableView = SORTING(Number)
                                    WHERE(Number = CONST(1));
                column(G_L_Account___No__; "G/L Account"."No.")
                {
                }
                column(PADSTR_____G_L_Account__Indentation___2___G_L_Account__Name; PADSTR('', "G/L Account".Indentation * 2) + "G/L Account".Name)
                {
                }
                column(G_L_Account___Income_Balance_; "G/L Account"."Income/Balance")
                {
                }
                column(G_L_Account___Account_Type_; "G/L Account"."Account Type")
                {
                }
                column(G_L_Account__Totaling; "G/L Account".Totaling)
                {
                }
                column(G_L_Account___Gen__Posting_Type_; "G/L Account"."Gen. Posting Type")
                {
                }
                column(G_L_Account___Gen__Bus__Posting_Group_; "G/L Account"."Gen. Bus. Posting Group")
                {
                }
                column(G_L_Account___Gen__Prod__Posting_Group_; "G/L Account"."Gen. Prod. Posting Group")
                {
                }
                column(G_L_Account___Direct_Posting_; "G/L Account"."Direct Posting")
                {
                }
                column(G_L_Account___Consol__Translation_Method_; "G/L Account"."Consol. Translation Method")
                {
                }
                column(G_L_Account___No__of_Blank_Lines_; "G/L Account"."No. of Blank Lines")
                {
                }
                column(PageGroupNo; PageGroupNo)
                {
                }
                column(DirectPostingTxt; DirectPostingTxt)
                {
                }
                column(CheckAccType; CheckAccType)
                {
                }
                column(AccountType; AccountType)
                {
                }
                column(ConsTransMethod; ConsTransMethod)
                {
                }
                column(IncomeBalance; IncomeBalance)
                {
                }
                column(GenPostingType; GenPostingType)
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                PageGroupNo := NextPageGroupNo;
                IF "New Page" THEN
                    NextPageGroupNo := PageGroupNo + 1;
                DirectPostingTxt := FORMAT("Direct Posting");
                AccountType := FORMAT("Account Type");
                ConsTransMethod := FORMAT("Consol. Translation Method");
                CheckAccType := "Account Type" = "Account Type"::Posting;
                IncomeBalance := FORMAT("Income/Balance");
                GenPostingType := FORMAT("Gen. Posting Type");

                //uln aperture ---------------------------------------------------------
                IF (Aperture = TRUE) AND ("Account Type" = "Account Type"::Posting) THEN BEGIN
                    d.UPDATE(); // Update the fields
                    Num := Num + 10000;
                    "G/L Account".CalcFields("Balance at Date");
                    if "G/L Account"."Balance at Date" = 0 then
                        CurrReport.Skip();
                    j_line.INIT;
                    j_line."Skip Dimensions" := true;
                    j_line."Journal Template Name" := 'GENERAL';

                    j_line."Line No." := Num;
                    j_line."Account Type" := j_line."Account Type"::"G/L Account";
                    j_line.VALIDATE("Account No.", "No.");

                    CASE Tipo of
                        tipo::Apertura:
                            BEGIN
                                j_line."Source Code" := SourceCodeSetup."Code Open";
                                j_line.Description := 'APERTURA-' + "No.";
                                j_line."Posting Text" := 'APERTURA PERIODO' + Format(DATE2DMY(FECHA_REGISTRO, 3));
                                j_line."Journal Batch Name" := SetupLocalization."Journal Batch Name Open";
                            END;
                        tipo::Cierre:
                            BEGIN
                                j_line."Source Code" := SourceCodeSetup."Code Close";
                                j_line.Description := 'CIERRE---' + "No.";
                                j_line."Posting Text" := 'CIERRE PERIODO' + Format(DATE2DMY(FECHA_REGISTRO, 3));
                                j_line."Journal Batch Name" := SetupLocalization."Journal Batch Name Closed";
                            END;
                    END;

                    //j_line.Description:=Name;
                    j_line.Opening := TRUE;
                    //---------------------------------------------------------16042014
                    j_line."System-Created Entry" := TRUE;
                    //---------------------------------------------------------16042014
                    CALCFIELDS("Debit Amount", "Credit Amount", "Balance at Date");
                    //001
                    IF Tipo = Tipo::Cierre THEN
                        j_line."Posting Date" := CLOSINGDATE(FECHA_REGISTRO)
                    ELSE
                        j_line."Posting Date" := FECHA_REGISTRO;
                    //001
                    j_line."Document No." := DOC;
                    IF Tipo = Tipo::Cierre THEN BEGIN
                        IF "Balance at Date" > 0 THEN
                            j_line.VALIDATE("Credit Amount", ABS("Balance at Date")) ELSE
                            j_line.VALIDATE("Debit Amount", ABS("Balance at Date"));
                    END ELSE BEGIN
                        IF "Balance at Date" < 0 THEN
                            j_line.VALIDATE("Credit Amount", ABS("Balance at Date")) ELSE
                            j_line.VALIDATE("Debit Amount", ABS("Balance at Date"));
                    END;



                    IF Tipo = Tipo::Apertura THEN
                        j_line."Source Code" := 'APERTURA' ELSE
                        j_line."Source Code" := 'CIERRE';
                    IF j_line.Amount <> 0 THEN
                        j_line.INSERT;


                END;
                //uln aperture ---------------------------------------------------------
            end;

            trigger OnPreDataItem()
            begin
                PageGroupNo := 1;
                NextPageGroupNo := 1;
                d.OPEN(TEXT3);

                SourceCodeSetup.GET;
                SourceCodeSetup.TestField("Code Open");
                SourceCodeSetup.TestField("Code Close");

                if "G/L Account".GetFilter("Date Filter") = '' then
                    Error('Por favor Ingresar Filtro Fecha');

                SetupLocalization.Get();
                SetupLocalization.TestField("Journal Batch Name Closed");
                SetupLocalization.TestField("Journal Batch Name Open");
                //uln Aperture  START                *************************************

                //IF Aperture = TRUE THEN
                //BEGIN
                IF NOT CONFIRM('Crear asientos de Apertura') THEN EXIT;
                //IF Tipo =Tipo ::Cierre THEN
                //BEGIN
                j_line.SETFILTER("Journal Template Name", 'GENERAL');

                CASE Tipo of
                    tipo::Apertura:
                        BEGIN
                            j_line.SETFILTER("Journal Batch Name", SetupLocalization."Journal Batch Name Open");
                        END;
                    tipo::Cierre:
                        BEGIN
                            j_line.SETFILTER("Journal Batch Name", SetupLocalization."Journal Batch Name Closed");
                        END;
                END;
                IF j_line.FINDLAST THEN
                    Num := j_line."Line No." + 10000;

                j_line.RESET;
                d.OPEN(TEXT3);
                //END;
                //END;
                //uln Aperture  FIN                   *************************************
                SETRANGE("G/L Account"."Income/Balance", "G/L Account"."Income/Balance"::"Balance Sheet");
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(Aerture; Aperture)
                {
                    Caption = 'Crear asiento de apertura';
                }
                field(Tipo; Tipo)
                {
                }
                field("N° de documento"; DOC)
                {
                }
                field("Fecha registro"; FECHA_REGISTRO)
                {
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        GLFilter := "G/L Account".GETFILTERS;
    end;

    var
        SetupLocalization: Record "Setup Localization";
        SourceCodeSetup: Record "Source Code Setup";
        GLFilter: Text;
        PageGroupNo: Integer;
        NextPageGroupNo: Integer;
        DirectPostingTxt: Text[30];
        CheckAccType: Boolean;
        AccountType: Text[30];
        ConsTransMethod: Text[30];
        IncomeBalance: Text[30];
        GenPostingType: Text[30];
        Chart_of_AccountsCaptionLbl: Label 'Chart of Accounts';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        PADSTR_____G_L_Account__Indentation___2___G_L_Account__NameCaptionLbl: Label 'Name';
        G_L_Account___Income_Balance_CaptionLbl: Label 'Income/Balance';
        G_L_Account___Account_Type_CaptionLbl: Label 'Account Type';
        G_L_Account__TotalingCaptionLbl: Label 'Totaling';
        G_L_Account___Gen__Posting_Type_CaptionLbl: Label 'Gen. Posting Type';
        G_L_Account___Gen__Bus__Posting_Group_CaptionLbl: Label 'Gen. Bus. Posting Group';
        G_L_Account___Gen__Prod__Posting_Group_CaptionLbl: Label 'Gen. Prod. Posting Group';
        G_L_Account___Direct_Posting_CaptionLbl: Label 'Direct Posting';
        G_L_Account___Consol__Translation_Method_CaptionLbl: Label 'Consol. Translation Method';
        j_line: Record "Gen. Journal Line";
        Num: Integer;
        GL: Record "G/L Entry";
        Account: Record "G/L Account";
        d: Dialog;
        des: Codeunit "Gen. Jnl.-Post Line";
        GeneralLedgerSetup: Record "General Ledger Setup";
        Aperture: Boolean;
        FECHA_REGISTRO: Date;
        DOC: Code[20];
        Tipo: Option Apertura,Cierre;
        TL: Integer;
        Analytic: Label 'Analytic no active to account';
        TEXT2: Label 'No hay datos a registrar !';
        TEXT3: Label 'Location Peru, Apertura Process...';
}

