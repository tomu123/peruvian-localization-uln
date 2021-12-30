page 51121 "Format FDC Setup"
{
    Caption = 'Format FDC Setup', Comment = 'ESM="Configuración Formato FDC"';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    Editable = true;
    SourceTable = "Format FDC Setup";
    InsertAllowed = true;
    layout
    {
        area(Content)
        {
            repeater(control1)
            {
                //IndentationColumn = Indentation;
                //IndentationControls = Description;
                // ShowAsTree = true;
                field(Orden; Orden)
                {
                    ApplicationArea = all;
                }
                field("Primary Category"; "Primary Category")
                {
                    ApplicationArea = all;
                }
                field("Secondary category"; "Secondary category")
                {
                    ApplicationArea = all;
                }
                field("Filter Account"; "Filter Account")
                {
                    ApplicationArea = all;
                }

                field("Filter Dimension FE"; "Filter Dimension FE")
                {
                    ApplicationArea = all;
                }
                field("Filter Dimension FCT"; "Filter Dimension FCT")
                {
                    ApplicationArea = all;
                }
                field("Filter Cod.Origen"; "Filter Cod.Origen")
                {
                    ApplicationArea = all;
                }
                field("Source Type"; "Source Type")
                {
                    ApplicationArea = all;
                }
                field("Source No."; "Source No.")
                {
                    ApplicationArea = all;
                }
                field("Document Type"; "Document Type")
                {
                    ApplicationArea = all;
                }
                field("Filter Posting Group"; "Filter Posting Group")
                {
                    ApplicationArea = all;
                }
                field(Ingreso; Ingreso)
                {
                    ApplicationArea = all;
                }
                field(Egreso; Egreso)
                {
                    ApplicationArea = all;
                }
            }
        }

    }

    actions
    {
        area(Processing)
        {
            action("Crear Plantilla")
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                    fnCreateTemplate();
                end;
            }
        }
    }
    local procedure fnCreateTemplate()
    var
        FormatFDCSetup: Record "Format FDC Setup";
    begin
        //INGRESOS POR CLIENTES-------------------
        //1
        FormatFDCSetup.DeleteAll();
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 1;
        FormatFDCSetup."Sub Orden" := 1;
        FormatFDCSetup."Primary Category" := 'INGRESOS POR CLIENTES';
        FormatFDCSetup."Secondary category" := 'Ingresos Comerciales';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Dimension FE" := 'AO.001';
        FormatFDCSetup.Ingreso := true;
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup.Insert();
        //2
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 1;
        FormatFDCSetup."Sub Orden" := 2;
        FormatFDCSetup."Primary Category" := 'INGRESOS POR CLIENTES';
        FormatFDCSetup."Secondary category" := 'Otros';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Dimension FE" := 'AO.002|AO.003|AO.004';
        FormatFDCSetup."Filter Cod.Origen" := 'DIACOBROS|CON. PAGOS';
        FormatFDCSetup.Ingreso := true;
        FormatFDCSetup.Insert();
        //PAGO A PROVEEDORES
        //1
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 2;
        FormatFDCSetup."Sub Orden" := 1;
        FormatFDCSetup."Primary Category" := 'PAGO A PROVEEDORES';
        FormatFDCSetup."Secondary category" := 'Cobertura + Peaje (ANDEAN POWER)';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := 'DIAPAGOS';
        FormatFDCSetup."Document Type" := FormatFDCSetup."Document Type"::Payment;
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::Vendor;
        FormatFDCSetup."Source No." := '20503684242';
        FormatFDCSetup."Filter Dimension FCT" := 'P.COBERTURA';
        FormatFDCSetup."Filter Dimension FE" := 'AO.005';
        FormatFDCSetup.Egreso := true;
        FormatFDCSetup."Calcular Retencion" := true;
        FormatFDCSetup.Insert();
        //2
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 2;
        FormatFDCSetup."Sub Orden" := 2;
        FormatFDCSetup."Primary Category" := 'PAGO A PROVEEDORES';
        FormatFDCSetup."Secondary category" := 'Cobertura + Peaje (EGEMSA)';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := 'DIAPAGOS';
        FormatFDCSetup."Document Type" := FormatFDCSetup."Document Type"::Payment;
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::Vendor;
        FormatFDCSetup."Source No." := '20218339167';
        FormatFDCSetup."Filter Dimension FCT" := 'P.COBERTURA';
        FormatFDCSetup."Filter Dimension FE" := 'AO.005';
        FormatFDCSetup."Calcular Retencion" := true;
        FormatFDCSetup.Egreso := true;
        FormatFDCSetup.Insert();
        //3
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 2;
        FormatFDCSetup."Sub Orden" := 3;
        FormatFDCSetup."Primary Category" := 'PAGO A PROVEEDORES';
        FormatFDCSetup."Secondary category" := 'Cobertura + Peaje (SANTA ANA / H1)';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := 'DIAPAGOS';
        FormatFDCSetup."Document Type" := FormatFDCSetup."Document Type"::Payment;
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::Vendor;
        FormatFDCSetup."Source No." := '20543136591';
        FormatFDCSetup."Filter Dimension FCT" := 'P.COBERTURA';
        FormatFDCSetup."Filter Dimension FE" := 'AO.005';
        FormatFDCSetup."Calcular Retencion" := true;
        FormatFDCSetup.Egreso := true;
        FormatFDCSetup.Insert();
        //4
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 2;
        FormatFDCSetup."Sub Orden" := 4;
        FormatFDCSetup."Primary Category" := 'PAGO A PROVEEDORES';
        FormatFDCSetup."Secondary category" := 'Cobertura + Peaje (FENIX)';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := 'DIAPAGOS';
        FormatFDCSetup."Document Type" := FormatFDCSetup."Document Type"::Payment;
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::Vendor;
        FormatFDCSetup."Source No." := '20509514641';
        FormatFDCSetup."Filter Dimension FCT" := 'P.COBERTURA';
        FormatFDCSetup."Filter Dimension FE" := 'AO.005';
        FormatFDCSetup."Calcular Retencion" := true;
        FormatFDCSetup.Egreso := true;
        FormatFDCSetup.Insert();
        //5
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 2;
        FormatFDCSetup."Sub Orden" := 5;
        FormatFDCSetup."Primary Category" := 'PAGO A PROVEEDORES';
        FormatFDCSetup."Secondary category" := 'Cobertura + Peaje (KALLPA)';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := 'DIAPAGOS';
        FormatFDCSetup."Document Type" := FormatFDCSetup."Document Type"::Payment;
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::Vendor;
        FormatFDCSetup."Source No." := '20538810682';
        FormatFDCSetup."Filter Dimension FCT" := 'P.COBERTURA';
        FormatFDCSetup."Filter Dimension FE" := 'AO.005';
        FormatFDCSetup."Calcular Retencion" := true;
        FormatFDCSetup.Egreso := true;
        FormatFDCSetup.Insert();
        //6
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 2;
        FormatFDCSetup."Sub Orden" := 6;
        FormatFDCSetup."Primary Category" := 'PAGO A PROVEEDORES';
        FormatFDCSetup."Secondary category" := 'COES/Trading';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := 'DIAPAGOS';
        FormatFDCSetup."Document Type" := FormatFDCSetup."Document Type"::Payment;
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::Vendor;
        FormatFDCSetup."Source No." := '';
        FormatFDCSetup."Filter Dimension FCT" := 'P.SPOT';
        FormatFDCSetup."Filter Dimension FE" := 'AO.005';
        FormatFDCSetup."Calcular Retencion" := true;
        FormatFDCSetup.Egreso := true;
        FormatFDCSetup.Insert();
        //7
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 2;
        FormatFDCSetup."Sub Orden" := 7;
        FormatFDCSetup."Primary Category" := 'PAGO A PROVEEDORES';
        FormatFDCSetup."Secondary category" := 'Peaje';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := 'DIAPAGOS';
        FormatFDCSetup."Document Type" := FormatFDCSetup."Document Type"::Payment;
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::Vendor;
        FormatFDCSetup."Source No." := '';
        FormatFDCSetup."Filter Dimension FCT" := 'P.PEAJE';
        FormatFDCSetup."Filter Dimension FE" := 'AO.005';
        FormatFDCSetup."Calcular Retencion" := true;
        FormatFDCSetup.Egreso := true;
        FormatFDCSetup.Insert();
        //Pagos a Entidades Regulatorias-----------------
        //1
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 3;
        FormatFDCSetup."Sub Orden" := 1;
        FormatFDCSetup."Primary Category" := 'Pagos a Entidades Regulatorias';
        FormatFDCSetup."Secondary category" := 'APORTE ANA';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Document Type" := FormatFDCSetup."Document Type"::Payment;
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::Vendor;
        FormatFDCSetup."Source No." := '20520711865';
        FormatFDCSetup."Filter Dimension FCT" := '';
        FormatFDCSetup."Filter Dimension FE" := 'AO.005';
        FormatFDCSetup.Egreso := true;
        FormatFDCSetup."Calcular Retencion" := true;
        FormatFDCSetup.Insert();
        //2
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 3;
        FormatFDCSetup."Sub Orden" := 2;
        FormatFDCSetup."Primary Category" := 'Pagos a Entidades Regulatorias';
        FormatFDCSetup."Secondary category" := 'APORTE OSINERGMIN';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Document Type" := FormatFDCSetup."Document Type"::Payment;
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::Vendor;
        FormatFDCSetup."Source No." := '20376082114';
        FormatFDCSetup."Filter Dimension FCT" := '';
        FormatFDCSetup."Filter Dimension FE" := 'AO.005';
        FormatFDCSetup.Egreso := true;
        FormatFDCSetup."Calcular Retencion" := true;
        FormatFDCSetup.Insert();
        //3
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 3;
        FormatFDCSetup."Sub Orden" := 3;
        FormatFDCSetup."Primary Category" := 'Pagos a Entidades Regulatorias';
        FormatFDCSetup."Secondary category" := 'APORTE MEM';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Document Type" := FormatFDCSetup."Document Type"::Payment;
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::Vendor;
        FormatFDCSetup."Source No." := '20131368829';
        FormatFDCSetup."Filter Dimension FCT" := 'NULL';
        FormatFDCSetup."Filter Dimension FE" := 'AO.005';
        FormatFDCSetup.Egreso := true;
        FormatFDCSetup."Calcular Retencion" := true;
        FormatFDCSetup.Insert();
        //4
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 3;
        FormatFDCSetup."Sub Orden" := 4;
        FormatFDCSetup."Primary Category" := 'Pagos a Entidades Regulatorias';
        FormatFDCSetup."Secondary category" := 'APORTE OEFA';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Document Type" := FormatFDCSetup."Document Type"::Payment;
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::Vendor;
        FormatFDCSetup."Source No." := '20521286769';
        FormatFDCSetup."Filter Dimension FCT" := '';
        FormatFDCSetup."Filter Dimension FE" := 'AO.005';
        FormatFDCSetup."Calcular Retencion" := true;
        FormatFDCSetup.Egreso := true;
        //FormatFDCSetup.Insert();
        //5
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 3;
        FormatFDCSetup."Sub Orden" := 5;
        FormatFDCSetup."Primary Category" := 'Pagos a Entidades Regulatorias';
        FormatFDCSetup."Secondary category" := 'ELECTRIFICACION RURAL';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Document Type" := FormatFDCSetup."Document Type"::Payment;
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::"Bank Account";
        FormatFDCSetup."Source No." := '';
        FormatFDCSetup."Filter Dimension FCT" := 'P.ELECRURA';
        FormatFDCSetup."Filter Dimension FE" := 'AO.005';
        FormatFDCSetup."Calcular Retencion" := true;
        FormatFDCSetup.Egreso := true;
        //FormatFDCSetup.Insert();
        //5.1
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 3;
        FormatFDCSetup."Sub Orden" := 5;
        FormatFDCSetup."Primary Category" := 'Pagos a Entidades Regulatorias';
        FormatFDCSetup."Secondary category" := 'ELECTRIFICACION RURAL';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Document Type" := FormatFDCSetup."Document Type"::Payment;
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::Vendor;
        FormatFDCSetup."Source No." := '20131368829';
        FormatFDCSetup."Filter Dimension FCT" := 'P.ELECRURA';
        FormatFDCSetup."Filter Dimension FE" := 'AO.005';
        FormatFDCSetup.Egreso := true;
        FormatFDCSetup."Review Bank" := true;
        FormatFDCSetup."Calcular Retencion" := true;
        FormatFDCSetup.Insert();
        //6
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 3;
        FormatFDCSetup."Sub Orden" := 6;
        FormatFDCSetup."Primary Category" := 'Pagos a Entidades Regulatorias';
        FormatFDCSetup."Secondary category" := 'FISE';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Document Type" := FormatFDCSetup."Document Type"::Payment;
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::"Bank Account";
        FormatFDCSetup."Source No." := '';
        FormatFDCSetup."Filter Dimension FCT" := 'P.FISE';
        FormatFDCSetup."Filter Dimension FE" := 'AO.005';
        FormatFDCSetup.Egreso := true;
        FormatFDCSetup."Calcular Retencion" := true;
        FormatFDCSetup.Insert();
        //6.1
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 3;
        FormatFDCSetup."Sub Orden" := 6;
        FormatFDCSetup."Primary Category" := 'Pagos a Entidades Regulatorias';
        FormatFDCSetup."Secondary category" := 'FISE';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Document Type" := FormatFDCSetup."Document Type"::Payment;
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::Vendor;
        FormatFDCSetup."Source No." := '20131368829';
        FormatFDCSetup."Filter Dimension FCT" := 'P.FISE';
        FormatFDCSetup."Filter Dimension FE" := 'AO.005';
        FormatFDCSetup.Egreso := true;
        FormatFDCSetup."Review Bank" := true;
        FormatFDCSetup."Calcular Retencion" := true;
        FormatFDCSetup.Insert();
        //Otros
        //1
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 4;
        FormatFDCSetup."Sub Orden" := 1;
        FormatFDCSetup."Primary Category" := 'Otros';
        FormatFDCSetup."Secondary category" := 'Pago SAVA';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Document Type" := FormatFDCSetup."Document Type"::Payment;
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::Vendor;
        FormatFDCSetup."Filter Dimension FCT" := 'P.PROYECTOS';
        FormatFDCSetup."Filter Dimension FE" := 'AO.005';
        FormatFDCSetup.Egreso := true;
        FormatFDCSetup."Calcular Retencion" := true;
        FormatFDCSetup.Insert();
        //2
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 4;
        FormatFDCSetup."Sub Orden" := 2;
        FormatFDCSetup."Primary Category" := 'Otros';
        FormatFDCSetup."Secondary category" := 'Otros Proveedores';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Document Type" := FormatFDCSetup."Document Type"::Payment;
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::Vendor;
        FormatFDCSetup."Filter Dimension FCT" := 'P.OTROS';
        FormatFDCSetup."Filter Dimension FE" := 'AO.005';
        FormatFDCSetup."Calcular Retencion" := true;
        FormatFDCSetup.Egreso := true;
        FormatFDCSetup.Insert();
        //Remuneraciones y Cargas Sociales
        //1
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 5;
        FormatFDCSetup."Sub Orden" := 1;
        FormatFDCSetup."Primary Category" := 'Remuneraciones y Cargas Sociales';
        FormatFDCSetup."Secondary category" := 'Planilla-RRHH';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Document Type" := FormatFDCSetup."Document Type"::Payment;
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::Employee;
        FormatFDCSetup."Filter Posting Group" := 'SUELDOS|SUELDOSRJ|SUBJUVEN';
        FormatFDCSetup."Filter Dimension FCT" := '';
        FormatFDCSetup."Filter Dimension FE" := 'AO.006';
        FormatFDCSetup.Egreso := true;
        FormatFDCSetup.Insert();
        //2
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 5;
        FormatFDCSetup."Sub Orden" := 2;
        FormatFDCSetup."Primary Category" := 'Remuneraciones y Cargas Sociales';
        FormatFDCSetup."Secondary category" := 'Dietas';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Document Type" := FormatFDCSetup."Document Type"::Payment;
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::Vendor;
        FormatFDCSetup."Filter Posting Group" := 'DIETAS-MN|DIETAS-ME';
        FormatFDCSetup."Filter Dimension FE" := 'AO.006';
        FormatFDCSetup.Egreso := true;
        FormatFDCSetup.Insert();
        //3
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 5;
        FormatFDCSetup."Sub Orden" := 3;
        FormatFDCSetup."Primary Category" := 'Remuneraciones y Cargas Sociales';
        FormatFDCSetup."Secondary category" := 'Gratificaciones';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Document Type" := FormatFDCSetup."Document Type"::Payment;
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::Employee;
        FormatFDCSetup."Filter Posting Group" := 'GRATPAG';
        FormatFDCSetup."Filter Dimension FCT" := '';
        FormatFDCSetup."Filter Dimension FE" := 'AO.006';
        FormatFDCSetup.Egreso := true;
        FormatFDCSetup.Insert();
        //4
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 5;
        FormatFDCSetup."Sub Orden" := 4;
        FormatFDCSetup."Primary Category" := 'Remuneraciones y Cargas Sociales';
        FormatFDCSetup."Secondary category" := 'CTS';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Document Type" := FormatFDCSetup."Document Type"::Payment;
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::Employee;
        FormatFDCSetup."Filter Posting Group" := 'CTS';
        FormatFDCSetup."Filter Dimension FCT" := '';
        FormatFDCSetup."Filter Dimension FE" := 'AO.006';
        FormatFDCSetup.Egreso := true;
        FormatFDCSetup.Insert();
        //5
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 5;
        FormatFDCSetup."Sub Orden" := 5;
        FormatFDCSetup."Primary Category" := 'Remuneraciones y Cargas Sociales';
        FormatFDCSetup."Secondary category" := 'Otros (AFP, BBSS)';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Document Type" := FormatFDCSetup."Document Type"::Payment;
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::Employee;
        FormatFDCSetup."Filter Posting Group" := 'AFPPRIMA|AFPHABITAT|AFPPROFU|AFPINTEG|OTREMPAG';
        FormatFDCSetup."Filter Dimension FCT" := '';
        FormatFDCSetup."Filter Dimension FE" := 'AO.006';
        FormatFDCSetup.Egreso := true;
        FormatFDCSetup.Insert();
        //Pagos de Impuestos
        //1
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 6;
        FormatFDCSetup."Sub Orden" := 1;
        FormatFDCSetup."Primary Category" := 'Pagos de Impuestos';
        FormatFDCSetup."Secondary category" := 'Detracciones';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Document Type" := FormatFDCSetup."Document Type"::Payment;
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::Vendor;
        FormatFDCSetup."Filter Posting Group" := 'DETAC-PP';
        FormatFDCSetup."Filter Dimension FE" := 'AO.007';
        FormatFDCSetup.Egreso := true;
        FormatFDCSetup.Insert();
        //2
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 6;
        FormatFDCSetup."Sub Orden" := 2;
        FormatFDCSetup."Primary Category" := 'Pagos de Impuestos';
        FormatFDCSetup."Secondary category" := 'Pago de IGV';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Document Type" := FormatFDCSetup."Document Type"::Payment;
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::" ";
        FormatFDCSetup."Filter Posting Group" := '';
        FormatFDCSetup."Filter Dimension FE" := 'AO.007';
        FormatFDCSetup."Filter Dimension FCT" := 'P.IGV';
        FormatFDCSetup.Egreso := true;
        FormatFDCSetup.Insert();
        //3
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 6;
        FormatFDCSetup."Sub Orden" := 3;
        FormatFDCSetup."Primary Category" := 'Pagos de Impuestos';
        FormatFDCSetup."Secondary category" := 'Impuesto a la Renta (Tercera/Dividendos)';
        FormatFDCSetup."Filter Account" := '10*';//'401701|401705|401805';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Document Type" := FormatFDCSetup."Document Type"::Payment;
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::" ";
        FormatFDCSetup."Filter Posting Group" := '';
        FormatFDCSetup."Filter Dimension FE" := 'AO.007';
        FormatFDCSetup."Filter Dimension FCT" := 'P.RENTA';
        FormatFDCSetup.Egreso := true;
        FormatFDCSetup.Insert();
        //4
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 6;
        FormatFDCSetup."Sub Orden" := 4;
        FormatFDCSetup."Primary Category" := 'Pagos de Impuestos';
        FormatFDCSetup."Secondary category" := 'ITAN';
        FormatFDCSetup."Filter Account" := '10*';//'401806';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Document Type" := FormatFDCSetup."Document Type"::Payment;
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::" ";
        FormatFDCSetup."Filter Posting Group" := '';
        FormatFDCSetup."Filter Dimension FE" := 'AO.007';
        FormatFDCSetup."Filter Dimension FCT" := 'P.ITAN';
        FormatFDCSetup.Egreso := true;
        FormatFDCSetup.Insert();
        //5
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 6;
        FormatFDCSetup."Sub Orden" := 5;
        FormatFDCSetup."Primary Category" := 'Pagos de Impuestos';
        FormatFDCSetup."Secondary category" := 'PLAME';
        FormatFDCSetup."Filter Account" := '10*';//'4031*|403201|401702|401703';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Document Type" := FormatFDCSetup."Document Type"::Payment;
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::" ";
        FormatFDCSetup."Filter Posting Group" := '';
        FormatFDCSetup."Filter Dimension FE" := 'AO.007';
        FormatFDCSetup."Filter Dimension FCT" := 'P.PLAME';
        FormatFDCSetup.Egreso := true;
        FormatFDCSetup.Insert();
        //6
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 6;
        FormatFDCSetup."Sub Orden" := 6;
        FormatFDCSetup."Primary Category" := 'Pagos de Impuestos';
        FormatFDCSetup."Secondary category" := 'Otros';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        //FormatFDCSetup."Document Type" := FormatFDCSetup."Document Type"::Payment;
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::" ";
        FormatFDCSetup."Filter Posting Group" := '';
        FormatFDCSetup."Filter Dimension FCT" := '';
        FormatFDCSetup."Filter Dimension FE" := 'AO.008|AO.009';
        FormatFDCSetup.Egreso := true;
        FormatFDCSetup.Insert();
        //INGRESOS POR INVERSION
        //1
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 7;
        FormatFDCSetup."Sub Orden" := 1;
        FormatFDCSetup."Primary Category" := 'INGRESOS POR INVERSION';
        FormatFDCSetup."Secondary category" := 'Cobranzas de venta de activo fijo';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::" ";
        FormatFDCSetup."Filter Posting Group" := '';
        FormatFDCSetup."Filter Dimension FE" := 'AI.002';
        FormatFDCSetup."Filter Dimension FCT" := '';
        FormatFDCSetup.Ingreso := true;
        FormatFDCSetup.Insert();
        //2
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 7;
        FormatFDCSetup."Sub Orden" := 2;
        FormatFDCSetup."Primary Category" := 'INGRESOS POR INVERSION';
        FormatFDCSetup."Secondary category" := 'Cobranzas de venta de intangible';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::" ";
        FormatFDCSetup."Filter Posting Group" := '';
        FormatFDCSetup."Filter Dimension FE" := 'AI.003';
        FormatFDCSetup."Filter Dimension FCT" := '';
        FormatFDCSetup.Ingreso := true;
        FormatFDCSetup.Insert();
        //3
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 7;
        FormatFDCSetup."Sub Orden" := 3;
        FormatFDCSetup."Primary Category" := 'INGRESOS POR INVERSION';
        FormatFDCSetup."Secondary category" := 'Cobranzas de préstamos a clientes';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::" ";
        FormatFDCSetup."Filter Posting Group" := '';
        FormatFDCSetup."Filter Dimension FE" := 'AI.004';
        FormatFDCSetup.Ingreso := true;
        FormatFDCSetup."Filter Dimension FCT" := '';
        FormatFDCSetup.Insert();
        //4
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 7;
        FormatFDCSetup."Sub Orden" := 4;
        FormatFDCSetup."Primary Category" := 'INGRESOS POR INVERSION';
        FormatFDCSetup."Secondary category" := 'Otros pagos relacionados';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::" ";
        FormatFDCSetup."Filter Posting Group" := '';
        FormatFDCSetup."Filter Dimension FE" := 'AI.001|AI.005';
        FormatFDCSetup.Ingreso := true;
        FormatFDCSetup."Filter Dimension FCT" := '';
        FormatFDCSetup.Insert();
        //EGRESOS POR INVERSION
        //1
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 8;
        FormatFDCSetup."Sub Orden" := 1;
        FormatFDCSetup."Primary Category" := 'EGRESOS POR INVERSION';
        FormatFDCSetup."Secondary category" := 'Pagos de compra de activo fijo';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::" ";
        FormatFDCSetup."Filter Posting Group" := '';
        FormatFDCSetup."Filter Dimension FE" := 'AI.007';
        FormatFDCSetup."Document Type" := FormatFDCSetup."Document Type"::Payment;
        FormatFDCSetup.Egreso := true;
        FormatFDCSetup.Insert();
        //2
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 8;
        FormatFDCSetup."Sub Orden" := 2;
        FormatFDCSetup."Primary Category" := 'EGRESOS POR INVERSION';
        FormatFDCSetup."Secondary category" := 'pagos de compra de intangible';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::" ";
        FormatFDCSetup."Filter Posting Group" := '';
        FormatFDCSetup."Filter Dimension FE" := 'AI.008';
        FormatFDCSetup."Document Type" := FormatFDCSetup."Document Type"::Payment;
        FormatFDCSetup.Egreso := true;
        FormatFDCSetup.Insert();
        //3
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 8;
        FormatFDCSetup."Sub Orden" := 3;
        FormatFDCSetup."Primary Category" := 'EGRESOS POR INVERSION';
        FormatFDCSetup."Secondary category" := 'Pagos por préstamos de clientes';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::" ";
        FormatFDCSetup."Filter Posting Group" := '';
        FormatFDCSetup."Filter Dimension FE" := 'AI.010';
        FormatFDCSetup."Document Type" := FormatFDCSetup."Document Type"::Payment;
        FormatFDCSetup.Egreso := true;
        FormatFDCSetup.Insert();
        //4
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 8;
        FormatFDCSetup."Sub Orden" := 4;
        FormatFDCSetup."Primary Category" := 'EGRESOS POR INVERSION';
        FormatFDCSetup."Secondary category" := 'Otros pagos relacionados';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::" ";
        FormatFDCSetup."Filter Posting Group" := '';
        FormatFDCSetup."Filter Dimension FE" := 'AI.006|AI.009';
        FormatFDCSetup."Document Type" := FormatFDCSetup."Document Type"::Payment;
        FormatFDCSetup.Egreso := true;
        FormatFDCSetup.Insert();
        //INGRESOS FINANCIAMIENTO
        //1
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 9;
        FormatFDCSetup."Sub Orden" := 1;
        FormatFDCSetup."Primary Category" := 'INGRESOS FINANCIAMIENTO';
        FormatFDCSetup."Secondary category" := 'Banco Financiero';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Source No." := '20100105862';
        FormatFDCSetup."Filter Posting Group" := '';
        FormatFDCSetup."Filter Dimension FCT" := 'I.BANCOS';
        FormatFDCSetup."Filter Dimension FE" := 'AF.008';
        //FormatFDCSetup."Document Type" := FormatFDCSetup."Document Type"::Payment;
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::Vendor;
        FormatFDCSetup."Review Bank" := true;
        FormatFDCSetup.Ingreso := true;
        FormatFDCSetup.Insert();
        //2
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 9;
        FormatFDCSetup."Sub Orden" := 2;
        FormatFDCSetup."Primary Category" := 'INGRESOS FINANCIAMIENTO';
        FormatFDCSetup."Secondary category" := 'Ban Bif';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Source No." := '20101036813';
        FormatFDCSetup."Filter Posting Group" := '';
        FormatFDCSetup."Filter Dimension FCT" := 'I.BANCOS';
        FormatFDCSetup."Filter Dimension FE" := 'AF.008';
        //FormatFDCSetup."Document Type" := FormatFDCSetup."Document Type"::Payment;
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::Vendor;
        FormatFDCSetup."Review Bank" := true;
        FormatFDCSetup.Ingreso := true;
        FormatFDCSetup.Insert();
        //3
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 9;
        FormatFDCSetup."Sub Orden" := 3;
        FormatFDCSetup."Primary Category" := 'INGRESOS FINANCIAMIENTO';
        FormatFDCSetup."Secondary category" := 'Banco de Crédito';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Source No." := '20100047218';
        FormatFDCSetup."Filter Posting Group" := '';
        FormatFDCSetup."Filter Dimension FCT" := 'I.BANCOS';
        FormatFDCSetup."Filter Dimension FE" := 'AF.008';
        //FormatFDCSetup."Document Type" := FormatFDCSetup."Document Type"::Payment;
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::Vendor;
        FormatFDCSetup."Review Bank" := true;
        FormatFDCSetup.Ingreso := true;
        FormatFDCSetup.Insert();
        //4
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 9;
        FormatFDCSetup."Sub Orden" := 4;
        FormatFDCSetup."Primary Category" := 'INGRESOS FINANCIAMIENTO';
        FormatFDCSetup."Secondary category" := 'BBVA Continental';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Source No." := '20100130204';
        FormatFDCSetup."Filter Posting Group" := '';
        FormatFDCSetup."Filter Dimension FCT" := 'I.BANCOS';
        FormatFDCSetup."Filter Dimension FE" := 'AF.008';
        //FormatFDCSetup."Document Type" := FormatFDCSetup."Document Type"::Payment;
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::Vendor;
        FormatFDCSetup."Review Bank" := true;
        FormatFDCSetup.Ingreso := true;
        FormatFDCSetup.Insert();
        //5
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 9;
        FormatFDCSetup."Sub Orden" := 5;
        FormatFDCSetup."Primary Category" := 'INGRESOS FINANCIAMIENTO';
        FormatFDCSetup."Secondary category" := 'Scotiabank';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Source No." := '20100043140';
        FormatFDCSetup."Filter Posting Group" := '';
        FormatFDCSetup."Filter Dimension FCT" := 'I.BANCOS';
        FormatFDCSetup."Filter Dimension FE" := 'AF.008';
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::Vendor;
        FormatFDCSetup."Review Bank" := true;
        FormatFDCSetup.Ingreso := true;
        FormatFDCSetup.Insert();
        //6
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 9;
        FormatFDCSetup."Sub Orden" := 6;
        FormatFDCSetup."Primary Category" := 'INGRESOS FINANCIAMIENTO';
        FormatFDCSetup."Secondary category" := 'Santander';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Source No." := '20516711559';
        FormatFDCSetup."Filter Posting Group" := '';
        FormatFDCSetup."Filter Dimension FCT" := 'I.BANCOS';
        FormatFDCSetup."Filter Dimension FE" := 'AF.008';
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::Vendor;
        FormatFDCSetup."Review Bank" := true;
        FormatFDCSetup.Ingreso := true;
        FormatFDCSetup.Insert();
        //7
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 9;
        FormatFDCSetup."Sub Orden" := 7;
        FormatFDCSetup."Primary Category" := 'INGRESOS FINANCIAMIENTO';
        FormatFDCSetup."Secondary category" := 'GNB';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Source No." := '20513074370';
        FormatFDCSetup."Filter Posting Group" := '';
        FormatFDCSetup."Filter Dimension FCT" := 'I.BANCOS';
        FormatFDCSetup."Filter Dimension FE" := 'AF.008';
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::Vendor;
        FormatFDCSetup."Review Bank" := true;
        FormatFDCSetup.Ingreso := true;
        FormatFDCSetup.Insert();
        //8
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 9;
        FormatFDCSetup."Sub Orden" := 8;
        FormatFDCSetup."Primary Category" := 'INGRESOS FINANCIAMIENTO';
        FormatFDCSetup."Secondary category" := 'Banco del Comercio';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Source No." := '20509507199';
        FormatFDCSetup."Filter Posting Group" := '';
        FormatFDCSetup."Filter Dimension FCT" := 'I.BANCOS';
        FormatFDCSetup."Filter Dimension FE" := 'AF.008';
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::Vendor;
        FormatFDCSetup."Review Bank" := true;
        FormatFDCSetup.Ingreso := true;
        FormatFDCSetup.Insert();
        //9
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 9;
        FormatFDCSetup."Sub Orden" := 9;
        FormatFDCSetup."Primary Category" := 'INGRESOS FINANCIAMIENTO';
        FormatFDCSetup."Secondary category" := 'Citibank';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Source No." := '20100116635';
        FormatFDCSetup."Filter Posting Group" := '';
        FormatFDCSetup."Filter Dimension FCT" := 'I.BANCOS';
        FormatFDCSetup."Filter Dimension FE" := 'AF.008';
        //FormatFDCSetup."Document Type" := FormatFDCSetup."Document Type"::Payment;
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::Vendor;
        FormatFDCSetup."Review Bank" := true;
        FormatFDCSetup.Ingreso := true;
        FormatFDCSetup.Insert();
        //10
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 9;
        FormatFDCSetup."Sub Orden" := 10;
        FormatFDCSetup."Primary Category" := 'INGRESOS FINANCIAMIENTO';
        FormatFDCSetup."Secondary category" := 'Banco Interbank';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Source No." := '20100053455';
        FormatFDCSetup."Filter Posting Group" := '';
        FormatFDCSetup."Filter Dimension FCT" := 'I.BANCOS';
        FormatFDCSetup."Filter Dimension FE" := 'AF.008';
        //FormatFDCSetup."Document Type" := FormatFDCSetup."Document Type"::Payment;
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::Vendor;
        FormatFDCSetup."Review Bank" := true;
        FormatFDCSetup.Ingreso := true;
        FormatFDCSetup.Insert();
        //11
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 9;
        FormatFDCSetup."Sub Orden" := 11;
        FormatFDCSetup."Primary Category" := 'INGRESOS FINANCIAMIENTO';
        FormatFDCSetup."Secondary category" := 'Banco ICBC PERU';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Source No." := '20546892175';
        FormatFDCSetup."Filter Posting Group" := '';
        FormatFDCSetup."Filter Dimension FCT" := 'I.BANCOS';
        FormatFDCSetup."Filter Dimension FE" := 'AF.008';
        //FormatFDCSetup."Document Type" := FormatFDCSetup."Document Type"::Payment;
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::Vendor;
        FormatFDCSetup."Review Bank" := true;
        FormatFDCSetup.Ingreso := true;
        FormatFDCSetup.Insert();
        //12
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 9;
        FormatFDCSetup."Sub Orden" := 12;
        FormatFDCSetup."Primary Category" := 'INGRESOS FINANCIAMIENTO';
        FormatFDCSetup."Secondary category" := 'Descuento de Facturas';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Source No." := '';
        FormatFDCSetup."Filter Posting Group" := '';
        FormatFDCSetup."Filter Dimension FCT" := 'I.DSCTO FACT';
        FormatFDCSetup."Filter Dimension FE" := 'AF.008';
        //FormatFDCSetup."Document Type" := FormatFDCSetup."Document Type"::Payment;
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::"Bank Account";
        FormatFDCSetup.Ingreso := true;
        FormatFDCSetup.Insert();
        //13
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 9;
        FormatFDCSetup."Sub Orden" := 13;
        FormatFDCSetup."Primary Category" := 'INGRESOS FINANCIAMIENTO';
        FormatFDCSetup."Secondary category" := 'Desintermediación';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Source No." := '';
        FormatFDCSetup."Filter Posting Group" := '';
        FormatFDCSetup."Filter Dimension FCT" := 'I.TITULIZADO';
        FormatFDCSetup."Filter Dimension FE" := 'AF.003';
        FormatFDCSetup.Ingreso := true;
        FormatFDCSetup.Insert();
        //14
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 9;
        FormatFDCSetup."Sub Orden" := 14;
        FormatFDCSetup."Primary Category" := 'INGRESOS FINANCIAMIENTO';
        FormatFDCSetup."Secondary category" := 'Desembolsos por Leasing / MP / Papeles Comerciales';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Source No." := '';
        FormatFDCSetup."Filter Posting Group" := '';
        FormatFDCSetup."Filter Dimension FCT" := '';
        FormatFDCSetup."Filter Dimension FE" := 'AF.002';
        FormatFDCSetup.Ingreso := true;
        FormatFDCSetup.Insert();
        //15
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 9;
        FormatFDCSetup."Sub Orden" := 15;
        FormatFDCSetup."Primary Category" := 'INGRESOS FINANCIAMIENTO';
        FormatFDCSetup."Secondary category" := 'Aporte de Capital';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Source No." := '';
        FormatFDCSetup."Filter Posting Group" := '';
        FormatFDCSetup."Filter Dimension FCT" := '';
        FormatFDCSetup."Filter Dimension FE" := 'AF.001';
        FormatFDCSetup.Ingreso := true;
        FormatFDCSetup.Insert();
        //16
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 9;
        FormatFDCSetup."Sub Orden" := 16;
        FormatFDCSetup."Primary Category" := 'INGRESOS FINANCIAMIENTO';
        FormatFDCSetup."Secondary category" := 'GCZ ENERGIA';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::Vendor;
        FormatFDCSetup."Source No." := '';
        FormatFDCSetup."Filter Posting Group" := '';
        FormatFDCSetup."Filter Dimension FCT" := 'GCZ ENERGIA';
        FormatFDCSetup."Filter Dimension FE" := 'AF.009';
        FormatFDCSetup.Ingreso := true;
        //FormatFDCSetup.Insert();
        //17
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 9;
        FormatFDCSetup."Sub Orden" := 17;
        FormatFDCSetup."Primary Category" := 'INGRESOS FINANCIAMIENTO';
        FormatFDCSetup."Secondary category" := 'GCZ INGENIEROS';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::Customer;
        FormatFDCSetup."Source No." := '20135072797';
        FormatFDCSetup."Filter Posting Group" := '';
        FormatFDCSetup."Filter Dimension FCT" := '';
        FormatFDCSetup."Filter Dimension FE" := 'AF.009';
        FormatFDCSetup."Review Bank" := true;
        FormatFDCSetup.Ingreso := true;
        FormatFDCSetup.Insert();
        //18
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 9;
        FormatFDCSetup."Sub Orden" := 18;
        FormatFDCSetup."Primary Category" := 'INGRESOS FINANCIAMIENTO';
        FormatFDCSetup."Secondary category" := 'GCZ SAC';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::Customer;
        FormatFDCSetup."Document Type" := FormatFDCSetup."Document Type"::" ";
        FormatFDCSetup."Source No." := '20546236740';
        FormatFDCSetup."Filter Posting Group" := '';
        FormatFDCSetup."Filter Dimension FCT" := '';
        FormatFDCSetup."Filter Dimension FE" := 'AF.009';
        FormatFDCSetup.Ingreso := true;
        FormatFDCSetup."Review Bank" := true;
        FormatFDCSetup.Insert();
        //19
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 9;
        FormatFDCSetup."Sub Orden" := 19;
        FormatFDCSetup."Primary Category" := 'INGRESOS FINANCIAMIENTO';
        FormatFDCSetup."Secondary category" := 'ATRIA ENERGIA S.P.A.';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::Customer;
        FormatFDCSetup."Source No." := '76.827.288-3';
        FormatFDCSetup."Filter Posting Group" := '';
        FormatFDCSetup."Filter Dimension FCT" := '';
        FormatFDCSetup."Filter Dimension FE" := 'AF.009';
        FormatFDCSetup.Ingreso := true;
        FormatFDCSetup."Review Bank" := true;
        FormatFDCSetup.Insert();
        //20
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 9;
        FormatFDCSetup."Sub Orden" := 20;
        FormatFDCSetup."Primary Category" := 'INGRESOS FINANCIAMIENTO';
        FormatFDCSetup."Secondary category" := 'ATRIA ENERGIA S.A.S. E.S.P.';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::Customer;
        FormatFDCSetup."Source No." := '901.444.905-4';
        FormatFDCSetup."Filter Posting Group" := '';
        FormatFDCSetup."Filter Dimension FCT" := '';
        FormatFDCSetup."Filter Dimension FE" := 'AF.009';
        FormatFDCSetup.Ingreso := true;
        FormatFDCSetup."Review Bank" := true;
        FormatFDCSetup.Insert();
        //21
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 9;
        FormatFDCSetup."Sub Orden" := 21;
        FormatFDCSetup."Primary Category" := 'INGRESOS FINANCIAMIENTO';
        FormatFDCSetup."Secondary category" := 'ATRIA INVESTMENTS S.A.C.';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::Customer;
        FormatFDCSetup."Source No." := '20606487674';
        FormatFDCSetup."Filter Posting Group" := '';
        FormatFDCSetup."Filter Dimension FCT" := '';
        FormatFDCSetup."Filter Dimension FE" := 'AF.009';
        FormatFDCSetup.Ingreso := true;
        FormatFDCSetup."Review Bank" := true;
        FormatFDCSetup.Insert();
        //22
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 9;
        FormatFDCSetup."Sub Orden" := 22;
        FormatFDCSetup."Primary Category" := 'INGRESOS FINANCIAMIENTO';
        FormatFDCSetup."Secondary category" := 'ATRIA INVESTMENTS  II S.A.C.';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::Customer;
        FormatFDCSetup."Source No." := '20608584421';
        FormatFDCSetup."Filter Posting Group" := '';
        FormatFDCSetup."Filter Dimension FCT" := '';
        FormatFDCSetup."Filter Dimension FE" := 'AF.009';
        FormatFDCSetup.Ingreso := true;
        FormatFDCSetup."Review Bank" := true;
        FormatFDCSetup.Insert();
        //23
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 9;
        FormatFDCSetup."Sub Orden" := 23;
        FormatFDCSetup."Primary Category" := 'INGRESOS FINANCIAMIENTO';
        FormatFDCSetup."Secondary category" := 'ACTIVA FINANCE S.A.C.';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::Customer;
        FormatFDCSetup."Source No." := 'PROV00010';
        FormatFDCSetup."Filter Posting Group" := '';
        FormatFDCSetup."Filter Dimension FCT" := '';
        FormatFDCSetup."Filter Dimension FE" := 'AF.009';
        FormatFDCSetup.Ingreso := true;
        FormatFDCSetup."Review Bank" := true;
        FormatFDCSetup.Insert();
        //24
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 9;
        FormatFDCSetup."Sub Orden" := 24;
        FormatFDCSetup."Primary Category" := 'INGRESOS FINANCIAMIENTO';
        FormatFDCSetup."Secondary category" := 'EGE JUNIN TULUMAYO IV S.A.C.';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::Customer;
        FormatFDCSetup."Source No." := '20546151167';
        FormatFDCSetup."Filter Posting Group" := '';
        FormatFDCSetup."Filter Dimension FCT" := '';
        FormatFDCSetup."Filter Dimension FE" := 'AF.009';
        FormatFDCSetup.Ingreso := true;
        FormatFDCSetup."Review Bank" := true;
        FormatFDCSetup.Insert();
        //25
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 9;
        FormatFDCSetup."Sub Orden" := 25;
        FormatFDCSetup."Primary Category" := 'INGRESOS FINANCIAMIENTO';
        FormatFDCSetup."Secondary category" := 'EGE JUNIN TULUMAYO V S.A.C.';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::Customer;
        FormatFDCSetup."Source No." := '20546360912';
        FormatFDCSetup."Filter Posting Group" := '';
        FormatFDCSetup."Filter Dimension FCT" := '';
        FormatFDCSetup."Filter Dimension FE" := 'AF.009';
        FormatFDCSetup.Ingreso := true;
        FormatFDCSetup."Review Bank" := true;
        FormatFDCSetup.Insert();
        //26
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 9;
        FormatFDCSetup."Sub Orden" := 26;
        FormatFDCSetup."Primary Category" := 'INGRESOS FINANCIAMIENTO';
        FormatFDCSetup."Secondary category" := 'HIDROELECTRICAS LIMA S.A.C.';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::Customer;
        FormatFDCSetup."Source No." := '20544531591';
        FormatFDCSetup."Filter Posting Group" := '';
        FormatFDCSetup."Filter Dimension FCT" := '';
        FormatFDCSetup."Filter Dimension FE" := 'AF.009';
        FormatFDCSetup.Ingreso := true;
        FormatFDCSetup."Review Bank" := true;
        FormatFDCSetup.Insert();
        //27
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 9;
        FormatFDCSetup."Sub Orden" := 27;
        FormatFDCSetup."Primary Category" := 'INGRESOS FINANCIAMIENTO';
        FormatFDCSetup."Secondary category" := 'Otros Ingresos Financieros';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::Customer;
        FormatFDCSetup."Filter Posting Group" := '';
        FormatFDCSetup."Filter Dimension FCT" := '<>I.TITULIZADO';
        FormatFDCSetup."Filter Dimension FE" := 'AF.003';
        FormatFDCSetup.Ingreso := true;
        FormatFDCSetup."Review Bank" := true;
        FormatFDCSetup.Insert();

        //EGRESOS FINANCIAMIENTO
        //1
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 10;
        FormatFDCSetup."Sub Orden" := 1;
        FormatFDCSetup."Primary Category" := 'EGRESOS FINANCIAMIENTO';
        FormatFDCSetup."Secondary category" := 'Banco Financiero';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Filter Posting Group" := '';
        FormatFDCSetup."Source No." := '20100105862';
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::Vendor;
        //FormatFDCSetup."Document Type" := FormatFDCSetup."Document Type"::Payment;
        FormatFDCSetup."Filter Dimension FCT" := 'I.BANCOS';
        FormatFDCSetup."Filter Dimension FE" := 'AF.007';
        FormatFDCSetup.Egreso := true;
        FormatFDCSetup."Review Bank" := true;
        FormatFDCSetup.Insert();
        //2
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 10;
        FormatFDCSetup."Sub Orden" := 2;
        FormatFDCSetup."Primary Category" := 'EGRESOS FINANCIAMIENTO';
        FormatFDCSetup."Secondary category" := 'Ban Bif';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Filter Posting Group" := '';
        FormatFDCSetup."Source No." := '20101036813';
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::Vendor;
        //FormatFDCSetup."Document Type" := FormatFDCSetup."Document Type"::Payment;
        FormatFDCSetup."Filter Dimension FCT" := 'I.BANCOS';
        FormatFDCSetup."Filter Dimension FE" := 'AF.007';
        FormatFDCSetup.Egreso := true;
        FormatFDCSetup."Review Bank" := true;
        FormatFDCSetup.Insert();
        //3
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 10;
        FormatFDCSetup."Sub Orden" := 3;
        FormatFDCSetup."Primary Category" := 'EGRESOS FINANCIAMIENTO';
        FormatFDCSetup."Secondary category" := 'Banco de Crédito';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Filter Posting Group" := '';
        FormatFDCSetup."Source No." := '20100047218';
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::Vendor;
        //FormatFDCSetup."Document Type" := FormatFDCSetup."Document Type"::Payment;
        FormatFDCSetup."Filter Dimension FCT" := 'I.BANCOS';
        FormatFDCSetup."Filter Dimension FE" := 'AF.007';
        FormatFDCSetup.Egreso := true;
        FormatFDCSetup."Review Bank" := true;
        FormatFDCSetup.Insert();
        //4
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 10;
        FormatFDCSetup."Sub Orden" := 4;
        FormatFDCSetup."Primary Category" := 'EGRESOS FINANCIAMIENTO';
        FormatFDCSetup."Secondary category" := 'BBVA Continental';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Filter Posting Group" := '';
        FormatFDCSetup."Source No." := '20100130204';
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::Vendor;
        //FormatFDCSetup."Document Type" := FormatFDCSetup."Document Type"::Payment;
        FormatFDCSetup."Filter Dimension FCT" := 'I.BANCOS';
        FormatFDCSetup."Filter Dimension FE" := 'AF.007';
        FormatFDCSetup.Egreso := true;
        FormatFDCSetup."Review Bank" := true;
        FormatFDCSetup.Insert();
        //5
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 10;
        FormatFDCSetup."Sub Orden" := 5;
        FormatFDCSetup."Primary Category" := 'EGRESOS FINANCIAMIENTO';
        FormatFDCSetup."Secondary category" := 'Scotiabank';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Filter Posting Group" := '';
        FormatFDCSetup."Source No." := '20100043140';
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::Vendor;
        //FormatFDCSetup."Document Type" := FormatFDCSetup."Document Type"::Payment;
        FormatFDCSetup."Filter Dimension FCT" := 'I.BANCOS';
        FormatFDCSetup."Filter Dimension FE" := 'AF.007';
        FormatFDCSetup.Egreso := true;
        FormatFDCSetup."Review Bank" := true;
        FormatFDCSetup.Insert();
        //6
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 10;
        FormatFDCSetup."Sub Orden" := 6;
        FormatFDCSetup."Primary Category" := 'EGRESOS FINANCIAMIENTO';
        FormatFDCSetup."Secondary category" := 'Santander';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Filter Posting Group" := '';
        FormatFDCSetup."Source No." := '20516711559';
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::Vendor;
        //FormatFDCSetup."Document Type" := FormatFDCSetup."Document Type"::Payment;
        FormatFDCSetup."Filter Dimension FCT" := 'I.BANCOS';
        FormatFDCSetup."Filter Dimension FE" := 'AF.007';
        FormatFDCSetup.Egreso := true;
        FormatFDCSetup."Review Bank" := true;
        FormatFDCSetup.Insert();
        //7
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 10;
        FormatFDCSetup."Sub Orden" := 7;
        FormatFDCSetup."Primary Category" := 'EGRESOS FINANCIAMIENTO';
        FormatFDCSetup."Secondary category" := 'GNB';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Filter Posting Group" := '';
        FormatFDCSetup."Source No." := '20513074370';
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::Vendor;
        //FormatFDCSetup."Document Type" := FormatFDCSetup."Document Type"::Payment;
        FormatFDCSetup."Filter Dimension FCT" := 'I.BANCOS';
        FormatFDCSetup."Filter Dimension FE" := 'AF.007';
        FormatFDCSetup.Egreso := true;
        FormatFDCSetup."Review Bank" := true;
        FormatFDCSetup.Insert();
        //8
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 10;
        FormatFDCSetup."Sub Orden" := 8;
        FormatFDCSetup."Primary Category" := 'EGRESOS FINANCIAMIENTO';
        FormatFDCSetup."Secondary category" := 'Banco del Comercio';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Filter Posting Group" := '';
        FormatFDCSetup."Source No." := '20509507199';
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::Vendor;
        //FormatFDCSetup."Document Type" := FormatFDCSetup."Document Type"::Payment;
        FormatFDCSetup."Filter Dimension FCT" := 'I.BANCOS';
        FormatFDCSetup."Filter Dimension FE" := 'AF.007';
        FormatFDCSetup.Egreso := true;
        FormatFDCSetup."Review Bank" := true;
        FormatFDCSetup.Insert();
        //9
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 10;
        FormatFDCSetup."Sub Orden" := 9;
        FormatFDCSetup."Primary Category" := 'EGRESOS FINANCIAMIENTO';
        FormatFDCSetup."Secondary category" := 'Citibank';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Filter Posting Group" := '';
        FormatFDCSetup."Source No." := '20100116635';
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::Vendor;
        //FormatFDCSetup."Document Type" := FormatFDCSetup."Document Type"::Payment;
        FormatFDCSetup."Filter Dimension FCT" := 'I.BANCOS';
        FormatFDCSetup."Filter Dimension FE" := 'AF.007';
        FormatFDCSetup.Egreso := true;
        FormatFDCSetup."Review Bank" := true;
        FormatFDCSetup.Insert();
        //10
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 10;
        FormatFDCSetup."Sub Orden" := 10;
        FormatFDCSetup."Primary Category" := 'EGRESOS FINANCIAMIENTO';
        FormatFDCSetup."Secondary category" := 'Banco Interbank';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Filter Posting Group" := '';
        FormatFDCSetup."Source No." := '20100053455';
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::Vendor;
        // FormatFDCSetup."Document Type" := FormatFDCSetup."Document Type"::Payment;
        FormatFDCSetup."Filter Dimension FCT" := 'I.BANCOS';
        FormatFDCSetup."Filter Dimension FE" := 'AF.007';
        FormatFDCSetup.Egreso := true;
        FormatFDCSetup."Review Bank" := true;
        FormatFDCSetup.Insert();
        //11
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 10;
        FormatFDCSetup."Sub Orden" := 11;
        FormatFDCSetup."Primary Category" := 'EGRESOS FINANCIAMIENTO';
        FormatFDCSetup."Secondary category" := 'Banco ICBC PERU';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Filter Posting Group" := '';
        FormatFDCSetup."Source No." := '20546892175';
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::Vendor;
        //FormatFDCSetup."Document Type" := FormatFDCSetup."Document Type"::Payment;
        FormatFDCSetup."Filter Dimension FCT" := 'I.BANCOS';
        FormatFDCSetup."Filter Dimension FE" := 'AF.007';
        FormatFDCSetup.Egreso := true;
        FormatFDCSetup."Review Bank" := true;
        FormatFDCSetup.Insert();
        //12
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 10;
        FormatFDCSetup."Sub Orden" := 12;
        FormatFDCSetup."Primary Category" := 'EGRESOS FINANCIAMIENTO';
        FormatFDCSetup."Secondary category" := 'Facturas descontadas';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Filter Posting Group" := '';
        FormatFDCSetup."Source No." := '';
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::"Bank Account";
        //FormatFDCSetup."Document Type" := FormatFDCSetup."Document Type"::Payment;
        FormatFDCSetup."Filter Dimension FCT" := 'I.DSCTO FACT';
        FormatFDCSetup."Filter Dimension FE" := 'AF.006';
        FormatFDCSetup.Egreso := true;
        FormatFDCSetup."Review Bank" := true;
        FormatFDCSetup.Insert();
        //13
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 10;
        FormatFDCSetup."Sub Orden" := 13;
        FormatFDCSetup."Primary Category" := 'EGRESOS FINANCIAMIENTO';
        FormatFDCSetup."Secondary category" := 'Pago de Leasing / MP / Papeles Comerciales';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Filter Posting Group" := '';
        FormatFDCSetup."Source No." := '';
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::"Bank Account";
        //FormatFDCSetup."Document Type" := FormatFDCSetup."Document Type"::Payment;
        FormatFDCSetup."Filter Dimension FCT" := '';
        FormatFDCSetup."Filter Dimension FE" := 'AF.004';
        FormatFDCSetup.Egreso := true;
        //FormatFDCSetup."Review Bank" := true;
        FormatFDCSetup.Insert();
        //14
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 10;
        FormatFDCSetup."Sub Orden" := 14;
        FormatFDCSetup."Primary Category" := 'EGRESOS FINANCIAMIENTO';
        FormatFDCSetup."Secondary category" := 'Comisiones Avales/Dividendos';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Filter Posting Group" := '';
        FormatFDCSetup."Source No." := '';
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::"Bank Account";
        //FormatFDCSetup."Document Type" := FormatFDCSetup."Document Type"::Payment;
        FormatFDCSetup."Filter Dimension FCT" := '';
        FormatFDCSetup."Filter Dimension FE" := 'AF.005';
        FormatFDCSetup.Egreso := true;
        //FormatFDCSetup."Review Bank" := true;
        FormatFDCSetup.Insert();
        //15
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 10;
        FormatFDCSetup."Sub Orden" := 15;
        FormatFDCSetup."Primary Category" := 'EGRESOS FINANCIAMIENTO';
        FormatFDCSetup."Secondary category" := 'GCZ INGENIEROS';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Filter Posting Group" := '';
        FormatFDCSetup."Source No." := '20135072797';
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::Vendor;
        // FormatFDCSetup."Document Type" := FormatFDCSetup."Document Type"::Payment;
        FormatFDCSetup."Filter Dimension FCT" := '';
        FormatFDCSetup."Filter Dimension FE" := 'AF.010';
        FormatFDCSetup.Egreso := true;
        FormatFDCSetup."Review Bank" := true;
        FormatFDCSetup.Insert();
        //16
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 10;
        FormatFDCSetup."Sub Orden" := 16;
        FormatFDCSetup."Primary Category" := 'EGRESOS FINANCIAMIENTO';
        FormatFDCSetup."Secondary category" := 'GCZ SAC';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Filter Posting Group" := '';
        FormatFDCSetup."Source No." := '20546236740';
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::Vendor;
        //FormatFDCSetup."Document Type" := FormatFDCSetup."Document Type"::Payment;
        FormatFDCSetup."Filter Dimension FCT" := '';
        FormatFDCSetup."Filter Dimension FE" := 'AF.010';
        FormatFDCSetup.Egreso := true;
        FormatFDCSetup."Review Bank" := true;
        FormatFDCSetup.Insert();
        //17
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 10;
        FormatFDCSetup."Sub Orden" := 17;
        FormatFDCSetup."Primary Category" := 'EGRESOS FINANCIAMIENTO';
        FormatFDCSetup."Secondary category" := 'ATRIA ENERGIA S.P.A.';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Filter Posting Group" := '';
        FormatFDCSetup."Source No." := '76.827.288-3';
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::Vendor;
        //FormatFDCSetup."Document Type" := FormatFDCSetup."Document Type"::Payment;
        FormatFDCSetup."Filter Dimension FCT" := '';
        FormatFDCSetup."Filter Dimension FE" := 'AF.010';
        FormatFDCSetup.Egreso := true;
        FormatFDCSetup."Review Bank" := true;
        FormatFDCSetup.Insert();
        //18
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 10;
        FormatFDCSetup."Sub Orden" := 18;
        FormatFDCSetup."Primary Category" := 'EGRESOS FINANCIAMIENTO';
        FormatFDCSetup."Secondary category" := 'ATRIA ENERGIA S.A.S. E.S.P.';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Filter Posting Group" := '';
        FormatFDCSetup."Source No." := '901.444.905-4';
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::Vendor;
        //FormatFDCSetup."Document Type" := FormatFDCSetup."Document Type"::Payment;
        FormatFDCSetup."Filter Dimension FCT" := '';
        FormatFDCSetup."Filter Dimension FE" := 'AF.010';
        FormatFDCSetup.Egreso := true;
        FormatFDCSetup."Review Bank" := true;
        FormatFDCSetup.Insert();
        //19
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 10;
        FormatFDCSetup."Sub Orden" := 19;
        FormatFDCSetup."Primary Category" := 'EGRESOS FINANCIAMIENTO';
        FormatFDCSetup."Secondary category" := 'ATRIA INVESTMENTS S.A.C.';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Filter Posting Group" := '';
        FormatFDCSetup."Source No." := '20606487674';
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::Vendor;
        //FormatFDCSetup."Document Type" := FormatFDCSetup."Document Type"::Payment;
        FormatFDCSetup."Filter Dimension FCT" := '';
        FormatFDCSetup."Filter Dimension FE" := 'AF.010';
        FormatFDCSetup.Egreso := true;
        FormatFDCSetup."Review Bank" := true;
        FormatFDCSetup.Insert();
        //20
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 10;
        FormatFDCSetup."Sub Orden" := 20;
        FormatFDCSetup."Primary Category" := 'EGRESOS FINANCIAMIENTO';
        FormatFDCSetup."Secondary category" := 'ATRIA INVESTMENTS  II S.A.C.';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Filter Posting Group" := '';
        FormatFDCSetup."Source No." := '20608584421';
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::Vendor;
        //FormatFDCSetup."Document Type" := FormatFDCSetup."Document Type"::Payment;
        FormatFDCSetup."Filter Dimension FCT" := '';
        FormatFDCSetup."Filter Dimension FE" := 'AF.010';
        FormatFDCSetup.Egreso := true;
        FormatFDCSetup."Review Bank" := true;
        FormatFDCSetup.Insert();
        //21
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 10;
        FormatFDCSetup."Sub Orden" := 21;
        FormatFDCSetup."Primary Category" := 'EGRESOS FINANCIAMIENTO';
        FormatFDCSetup."Secondary category" := 'ACTIVA FINANCE S.A.C.';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Filter Posting Group" := '';
        FormatFDCSetup."Source No." := 'PROV00010';
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::Vendor;
        //FormatFDCSetup."Document Type" := FormatFDCSetup."Document Type"::Payment;
        FormatFDCSetup."Filter Dimension FCT" := '';
        FormatFDCSetup."Filter Dimension FE" := 'AF.010';
        FormatFDCSetup.Egreso := true;
        FormatFDCSetup."Review Bank" := true;
        FormatFDCSetup.Insert();
        //22
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 10;
        FormatFDCSetup."Sub Orden" := 22;
        FormatFDCSetup."Primary Category" := 'EGRESOS FINANCIAMIENTO';
        FormatFDCSetup."Secondary category" := 'EGE JUNIN TULUMAYO IV S.A.C.';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Filter Posting Group" := '';
        FormatFDCSetup."Source No." := '20546151167';
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::Vendor;
        //FormatFDCSetup."Document Type" := FormatFDCSetup."Document Type"::Payment;
        FormatFDCSetup."Filter Dimension FCT" := '';
        FormatFDCSetup."Filter Dimension FE" := 'AF.010';
        FormatFDCSetup.Egreso := true;
        FormatFDCSetup."Review Bank" := true;
        FormatFDCSetup.Insert();
        //23
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 10;
        FormatFDCSetup."Sub Orden" := 23;
        FormatFDCSetup."Primary Category" := 'EGRESOS FINANCIAMIENTO';
        FormatFDCSetup."Secondary category" := 'EGE JUNIN TULUMAYO V S.A.C.';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Filter Posting Group" := '';
        FormatFDCSetup."Source No." := '20546360912';
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::Vendor;
        //FormatFDCSetup."Document Type" := FormatFDCSetup."Document Type"::Payment;
        FormatFDCSetup."Filter Dimension FCT" := '';
        FormatFDCSetup."Filter Dimension FE" := 'AF.010';
        FormatFDCSetup.Egreso := true;
        FormatFDCSetup."Review Bank" := true;
        FormatFDCSetup.Insert();
        //24
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 10;
        FormatFDCSetup."Sub Orden" := 24;
        FormatFDCSetup."Primary Category" := 'EGRESOS FINANCIAMIENTO';
        FormatFDCSetup."Secondary category" := 'HIDROELECTRICAS LIMA S.A.C.';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Filter Posting Group" := '';
        FormatFDCSetup."Source No." := '20544531591';
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::Vendor;
        //FormatFDCSetup."Document Type" := FormatFDCSetup."Document Type"::Payment;
        FormatFDCSetup."Filter Dimension FCT" := '';
        FormatFDCSetup."Filter Dimension FE" := 'AF.010';
        FormatFDCSetup.Egreso := true;
        FormatFDCSetup."Review Bank" := true;
        FormatFDCSetup.Insert();
        //25
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 10;
        FormatFDCSetup."Sub Orden" := 25;
        FormatFDCSetup."Primary Category" := 'EGRESOS FINANCIAMIENTO';
        FormatFDCSetup."Secondary category" := 'Confirming';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Filter Posting Group" := '';
        FormatFDCSetup."Source No." := '';
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::" ";
        //FormatFDCSetup."Document Type" := FormatFDCSetup."Document Type"::Payment;
        FormatFDCSetup."Filter Dimension FCT" := 'P.CONFIRMING';
        FormatFDCSetup."Filter Dimension FE" := 'AF.007';
        FormatFDCSetup.Egreso := true;
        FormatFDCSetup."Review Bank" := true;
        FormatFDCSetup.Insert();
        //26
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 10;
        FormatFDCSetup."Sub Orden" := 26;
        FormatFDCSetup."Primary Category" := 'EGRESOS FINANCIAMIENTO';
        FormatFDCSetup."Secondary category" := 'Otros Intereses y Gastos Financieros';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Filter Posting Group" := '';
        FormatFDCSetup."Source No." := '';
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::" ";
        //FormatFDCSetup."Document Type" := FormatFDCSetup."Document Type"::Payment;
        FormatFDCSetup."Filter Dimension FCT" := '';
        FormatFDCSetup."Filter Dimension FE" := 'AF.007';
        FormatFDCSetup.Egreso := true;
        FormatFDCSetup."Review Bank" := true;
        FormatFDCSetup.Insert();
        //27
        FormatFDCSetup.Init();
        FormatFDCSetup.Orden := 10;
        FormatFDCSetup."Sub Orden" := 27;
        FormatFDCSetup."Primary Category" := 'EGRESOS FINANCIAMIENTO';
        FormatFDCSetup."Secondary category" := 'MUTUO LIBRES, OPERADOR Y OTROS';
        FormatFDCSetup."Filter Account" := '10*';
        FormatFDCSetup."Filter Cod.Origen" := '';
        FormatFDCSetup."Filter Posting Group" := '';
        FormatFDCSetup."Source No." := '';
        FormatFDCSetup."Source Type" := FormatFDCSetup."Source Type"::" ";
        //FormatFDCSetup."Document Type" := FormatFDCSetup."Document Type"::Payment;
        FormatFDCSetup."Filter Dimension FCT" := '';
        FormatFDCSetup."Filter Dimension FE" := 'AI.010';
        FormatFDCSetup.Egreso := true;
        FormatFDCSetup."Review Bank" := true;
        FormatFDCSetup.Insert();
        CurrPage.Update();
    end;
}