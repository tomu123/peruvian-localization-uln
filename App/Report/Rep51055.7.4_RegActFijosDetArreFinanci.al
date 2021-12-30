report 51055 "Reg.Act.Fijos-Det.Arre.Financi"
{
    //LIBRO 7.4
    // Identify  Nro.  yyyy.MM.dd  Version   Description
    // -----------------------------------------------------
    // ULN::PC   001   2021.07.05    V.1     Peruvian Books (Copy From MT )
    DefaultLayout = RDLC;
    RDLCLayout = './App/Report/RDLC/Reg.Act.Fijos-Det.Arre.Financi.rdl';
    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = WHERE(Number = CONST(1));
            column(RazonSocial; recCompanyInfo.Name)
            {
            }
            column(RUC; recCompanyInfo."VAT Registration No.")
            {
            }
            column(FechaInicio; gStartDate)
            {
            }
            column(Year; gYear)
            {
            }
            column(FechaFinnal; gEndDate)
            {
            }
        }
        dataitem("Fixed Asset"; "Fixed Asset")
        {
            DataItemTableView = WHERE("ST AF Leasing" = CONST(true));
            column(FechaContrato; "Fixed Asset"."ST Contract Date")
            {
            }
            column(NoContrato; "Fixed Asset"."ST Contract No.")
            {
            }
            column(FecInicioArrendamiento; "Fixed Asset"."ST Lease Start Date")
            {
            }
            column(NumeroCuotas; "Fixed Asset"."ST Number of Quotas")
            {
            }
            column(Importe; "Fixed Asset"."ST Amount")
            {
            }

            trigger OnAfterGetRecord()
            var
                FAClass: Record "FA Class";
            begin
                FAClass.Reset();
                FAClass.SetRange(Code, "Fixed Asset"."FA Class Code");
                FAClass.SetRange(Leasing, true);
                if not FAClass.FindSet() then
                    CurrReport.Skip();
                /*
                glRecDepBook.RESET;
                glRecDepBook.SETRANGE("FA No.","FA Ledger Entry"."FA No.");
                IF glRecDepBook.FINDSET THEN BEGIN
                    IF glPostingGroup.GET(glRecDepBook."FA Posting Group") THEN BEGIN
                        glAdqGroup := COPYSTR(glPostingGroup."Acquisition Cost Account",1,2);
                    END;
                END;
                gMonto := 0;
                IF (glAdqGroup = '32') AND ("FA Ledger Entry"."Source Code"='GENJNL') AND (FORMAT("FA Ledger Entry"."G/L Entry No.") <> '') AND ("FA Ledger Entry"."FA No." <> '') THEN BEGIN
                   gVendorLedgerEntry.RESET;
                   gVendorLedgerEntry.SETRANGE("Document No.","FA Ledger Entry"."Document No.");
                   gVendorLedgerEntry.SETRANGE("Posting Date","Posting Date");
                   IF gVendorLedgerEntry.FINDSET THEN BEGIN
                      gVendorLedgerEntry.CALCFIELDS(Amount);
                      gMonto := gVendorLedgerEntry.Amount;
                   END;
                END ELSE BEGIN
                  CurrReport.SKIP;
                END;
                */

            end;

            trigger OnPreDataItem()
            begin
                gYear := DATE2DMY(gStartDate, 3);

                SETRANGE("ST Lease Start Date", gStartDate, gEndDate);
                //SETCURRENTKEY("Transaction No.","G/L Entry No.");
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Fecha Inicio"; gStartDate)
                {
                }
                field("Fecha Fin"; gEndDate)
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
        recCompanyInfo.GET;
    end;

    var
        recCompanyInfo: Record "Company Information";
        gStartDate: Date;
        gEndDate: Date;
        glRecDepBook: Record "FA Depreciation Book";
        glAdqGroup: Text;
        glPostingGroup: Record "FA Posting Group";
        gYear: Integer;
        gVendorLedgerEntry: Record "Vendor Ledger Entry";
        gMonto: Decimal;
}

