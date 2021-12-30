report 51056 "10.1 Registro Costos"
{
    //LIBRO 10.1
    // Identify  Nro.  yyyy.MM.dd  Version   Description
    // -----------------------------------------------------
    // ULN::PC   001   2021.07.05    V.1     Peruvian Books (Copy From MT )
    DefaultLayout = RDLC;
    RDLCLayout = './App/Report/RDLC/10.1 Registro Costos.rdl';

    dataset
    {
        dataitem(Integer; Integer)
        {
            column(CompanyName; CompanyInformation.Name)
            {
            }
            column(RucCompany; CompanyInformation."VAT Registration No.")
            {
            }
            column(Periodo; MesPeriodo)
            {
            }
            column(Costo_Inventario_Inicial_Producto_Terminado; importeInicial)
            {
            }
            column(Costo_Inventario_Final_Producto_Terminado; importeActual)
            {
            }
            column(AjusteDiverso; gImporteAjusteDiverso)
            {
            }
            column(ImpProductoCostoTerminado; gImpProdCostTerminado)
            {
            }

            trigger OnAfterGetRecord()
            begin
                GLEntry.RESET;
                GLEntry.SETCURRENTKEY("Document No.", "G/L Account No.", "Posting Date");
                GLEntry.SETFILTER("Document No.", '<>%1&<>%2', 'CIERRE*', 'APERTURA*');
                GLEntry.SETFILTER("G/L Account No.", '20*|21*|22*|23*|24*|25*|26*');
                GLEntry.SETRANGE("Posting Date", 0D, CALCDATE('<-1D>', gFechaInicio));
                GLEntry.CALCSUMS(Amount);
                importeInicial := GLEntry.Amount;

                gItemLedgerEntry.RESET;
                gItemLedgerEntry.SETRANGE("Posting Date", gFechaInicio, gFechaFin);
                gItemLedgerEntry.SETFILTER("Entry Type", '%1', gItemLedgerEntry."Entry Type"::Purchase);
                gItemLedgerEntry.SETAUTOCALCFIELDS("Cost Amount (Actual)");
                IF gItemLedgerEntry.FINDSET THEN
                    REPEAT
                        gImpProdCostTerminado += gItemLedgerEntry."Cost Amount (Actual)";
                    UNTIL gItemLedgerEntry.NEXT = 0;


                gImporteAjusteDiverso := 0;
                importeActual := 0;
                gItemLedgerEntry.RESET;
                gItemLedgerEntry.SETRANGE("Posting Date", gFechaInicio, gFechaFin);
                gItemLedgerEntry.SETFILTER("Entry Type", '%1|%2|%3', gItemLedgerEntry."Entry Type"::Sale, gItemLedgerEntry."Entry Type"::"Negative Adjmt.", gItemLedgerEntry."Entry Type"::"Positive Adjmt.");
                gItemLedgerEntry.SETAUTOCALCFIELDS("Cost Amount (Actual)");
                IF gItemLedgerEntry.FINDSET THEN
                    REPEAT
                        gValueEntry.RESET;
                        gValueEntry.SETRANGE("Item Ledger Entry No.", gItemLedgerEntry."Entry No.");
                        gValueEntry.SETRANGE("Gen. Bus. Posting Group", 'GRATUITO');
                        IF (gValueEntry.FINDSET) AND (gItemLedgerEntry."Entry Type" = gItemLedgerEntry."Entry Type"::Sale) THEN BEGIN
                            gImporteAjusteDiverso += gItemLedgerEntry."Cost Amount (Actual)"
                        END ELSE
                            IF (gItemLedgerEntry."Entry Type" IN [gItemLedgerEntry."Entry Type"::"Negative Adjmt.", gItemLedgerEntry."Entry Type"::"Positive Adjmt."]) THEN BEGIN
                                gValueEntry.RESET;
                                gValueEntry.SETRANGE("Item Ledger Entry No.", gItemLedgerEntry."Entry No.");
                                gValueEntry.SETFILTER("Gen. Bus. Posting Group", '<>%1&<>%2', '', 'REVALU');
                                IF gValueEntry.FINDSET THEN
                                    gImporteAjusteDiverso += gItemLedgerEntry."Cost Amount (Actual)";
                            END;
                    UNTIL gItemLedgerEntry.NEXT = 0;


                gItemLedgerEntry.RESET;
                gItemLedgerEntry.SETRANGE("Posting Date", gFechaInicio, gFechaFin);
                gItemLedgerEntry.SETAUTOCALCFIELDS("Cost Amount (Actual)");
                IF gItemLedgerEntry.FINDSET THEN
                    REPEAT
                        importeActual += gItemLedgerEntry."Cost Amount (Actual)";
                    UNTIL gItemLedgerEntry.NEXT = 0;
            end;

            trigger OnPreDataItem()
            begin
                SETRANGE(Number, 1, 1);
                CLEAR(importeInicial);
                CLEAR(importeActual);
                CompanyInformation.GET;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group("Filtro Fecha")
                {
                    field("<Control1000000001>"; mosfr)
                    {
                        Caption = 'Habilitar año de Referencial', Comment = 'ESM="Habilitar año de Referencial"';
                        Enabled = true;

                        trigger OnValidate()
                        begin

                            IF mosfr = TRUE THEN BEGIN
                                //RequestOptionsPage.ARef.ENABLED(TRUE);
                                mescab := DATE2DMY(TODAY, 3)
                            END ELSE BEGIN
                                //RequestOptionsPage.ARef.ENABLED:=FALSE;
                                mescab := 0;
                            END;
                        end;
                    }
                    field(mescab; mescab)
                    {
                        Caption = 'Año Referencial', Comment = 'ESM="Año Referencial"';
                    }
                    field(verperiodo; verperiodo)
                    {
                        Caption = 'Fecha de Referencia', Comment = 'ESM="Fecha de Referencia"';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            LookUpPeriodo;
                        end;
                    }
                    field(gFechaInicio; gFechaInicio)
                    {
                        Caption = 'Start Date', Comment = 'ESM="Fecha Inicio"';
                    }
                    field(gFechaFin; gFechaFin)
                    {
                        Caption = 'End Date', Comment = 'ESM="Fecha Fin"';
                    }
                    field(MesPeriodo; MesPeriodo)
                    {
                        Caption = 'Periodo', Comment = 'ESM="Periodo"';
                    }
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

    var
        gFechaInicio: Date;
        gFechaFin: Date;
        GLEntry: Record "G/L Entry";
        CompanyInformation: Record "Company Information";
        importeActual: Decimal;
        importeInicial: Decimal;
        MesPeriodo: Text;
        mosfr: Boolean;
        mescab: Integer;
        verperiodo: Text;
        gItemLedgerEntry: Record "Item Ledger Entry";
        gImporteAjusteDiverso: Decimal;
        gValueEntry: Record "Value Entry";
        gImpProdCostTerminado: Decimal;
        gGLItemLedgerRelation: Record "G/L - Item Ledger Relation";
        gGLEntry: Record "G/L Entry";

    procedure LookUpPeriodo()
    var
        recAccountingPeriod: Record "Accounting Period";
        fini: Date;
        ffin: Date;
    begin
        fini := DMY2DATE(1, 1, DATE2DMY(WORKDATE, 3));
        ffin := DMY2DATE(31, 12, DATE2DMY(WORKDATE, 3));
        IF mosfr = TRUE THEN BEGIN
            fini := DMY2DATE(1, 1, mescab);
            ffin := DMY2DATE(31, 12, mescab);
        END;
        recAccountingPeriod.SETFILTER(recAccountingPeriod."Starting Date", '>=%1&<=%2', fini, ffin);
        IF PAGE.RUNMODAL(PAGE::"Accounting Periods", recAccountingPeriod) = ACTION::LookupOK THEN
            verperiodo := '';
        gFechaInicio := 0D;
        gFechaFin := 0D;
        MesPeriodo := '';
        verperiodo := recAccountingPeriod.Name;
        gFechaInicio := recAccountingPeriod."Starting Date";
        EVALUATE(gFechaFin, FunctionFechaFin(recAccountingPeriod."Starting Date"));
        MesPeriodo := recAccountingPeriod.Name + ' del ' + FORMAT(DATE2DMY(recAccountingPeriod."Starting Date", 3));
    end;

    procedure FunctionFechaFin(fechaing: Date): Text[30]
    var
        calmes: Integer;
        "calaño": Integer;
        refmes: Integer;
    begin
        calmes := DATE2DMY(fechaing, 2);
        calaño := DATE2DMY(fechaing, 3);
        IF calaño MOD 4 = 0 THEN
            refmes := 29
        ELSE
            refmes := 28;
        CASE calmes OF
            1:
                EXIT('31/' + FORMAT(calmes) + '/' + FORMAT(calaño));
            2:
                EXIT(FORMAT(refmes) + '/' + FORMAT(calmes) + '/' + FORMAT(calaño));
            3:
                EXIT('31/' + FORMAT(calmes) + '/' + FORMAT(calaño));
            4:
                EXIT('30/' + FORMAT(calmes) + '/' + FORMAT(calaño));
            5:
                EXIT('31/' + FORMAT(calmes) + '/' + FORMAT(calaño));
            6:
                EXIT('30/' + FORMAT(calmes) + '/' + FORMAT(calaño));
            7:
                EXIT('31/' + FORMAT(calmes) + '/' + FORMAT(calaño));
            8:
                EXIT('31/' + FORMAT(calmes) + '/' + FORMAT(calaño));
            9:
                EXIT('30/' + FORMAT(calmes) + '/' + FORMAT(calaño));
            10:
                EXIT('31/' + FORMAT(calmes) + '/' + FORMAT(calaño));
            11:
                EXIT('30/' + FORMAT(calmes) + '/' + FORMAT(calaño));
            12:
                EXIT('31/' + FORMAT(calmes) + '/' + FORMAT(calaño));
        END;
    end;
}

