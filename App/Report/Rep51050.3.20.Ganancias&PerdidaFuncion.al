report 51050 "Ganancias y Perdida Funcion"
{
    //LIBRO 3.20
    // Identify  Nro.  yyyy.MM.dd  Version   Description
    // -----------------------------------------------------
    // ULN::PC   001   2021.07.05    V.1     Peruvian Books (Copy From MT )
    DefaultLayout = RDLC;
    RDLCLayout = './App/Report/RDLC/Ganancias y Perdida Funcion.rdl';
    Caption = 'Account Schedule', Comment = 'ESM="Ganancias y Perdida Funcion"';

    dataset
    {
        dataitem(AccScheduleName; "Acc. Schedule Name")
        {
            DataItemTableView = SORTING(Name);
            column(empresa; CompanyInfo.Name)
            {
            }
            column(AccScheduleName_Name; Name)
            {
            }
            column(Ejercicio; Gejercicio)
            {
            }
            dataitem(Heading; Integer)
            {
                DataItemTableView = SORTING(Number)
                                    WHERE(Number = CONST(1));
                column(ColumnLayoutName; ColumnLayoutName)
                {
                }
                column(FiscalStartDate; FORMAT(FiscalStartDate))
                {
                }
                column(PeriodText; PeriodText)
                {
                }
                column(COMPANYNAME; COMPANYNAME)
                {
                }
                column(AccScheduleName_Description; AccScheduleName.Description)
                {
                }
                column(AnalysisView_Code; AnalysisView.Code)
                {
                }
                column(AnalysisView_Name; AnalysisView.Name)
                {
                }
                column(HeaderText; HeaderText)
                {
                }
                column(AccScheduleLineTABLECAPTION_AccSchedLineFilter; "Acc. Schedule Line".TABLECAPTION + ': ' + AccSchedLineFilter)
                {
                }
                column(AccSchedLineFilter; AccSchedLineFilter)
                {
                }
                column(ShowAccSchedSetup; ShowAccSchedSetup)
                {
                }
                column(ColumnLayoutNameCaption; ColumnLayoutNameCaptionLbl)
                {
                }
                column(AccScheduleName_Name_Caption; AccScheduleName_Name_CaptionLbl)
                {
                }
                column(FiscalStartDateCaption; FiscalStartDateCaptionLbl)
                {
                }
                column(PeriodTextCaption; PeriodTextCaptionLbl)
                {
                }
                column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
                {
                }
                column(Account_ScheduleCaption; Account_ScheduleCaptionLbl)
                {
                }
                column(AnalysisView_CodeCaption; AnalysisView_CodeCaptionLbl)
                {
                }
                column(RUC; CompanyInfo."VAT Registration No.")
                {
                }
                dataitem(AccSchedLineSpec; "Acc. Schedule Line")
                {
                    DataItemLink = "Schedule Name" = FIELD(Name);
                    DataItemLinkReference = AccScheduleName;
                    DataItemTableView = SORTING("Schedule Name", "Line No.");
                    column(AccSchedLineSpec_Show; Show)
                    {
                    }
                    column(AccSchedLineSpec__Totaling_Type_; "Totaling Type")
                    {
                    }
                    column(AccSchedLineSpec_Totaling; Totaling)
                    {
                    }
                    column(AccSchedLineSpec_Description; Description)
                    {
                    }
                    column(AccSchedLineSpec__Row_No__; "Row No.")
                    {
                    }
                    column(AccSchedLineSpec__Row_Type_; "Row Type")
                    {
                    }
                    column(AccSchedLineSpec__Amount_Type_; "Amount Type")
                    {
                    }
                    column(Bold_format; FORMAT(Bold))
                    {
                    }
                    column(Italic_format; FORMAT(Italic))
                    {
                    }
                    column(Underline_format; FORMAT(Underline))
                    {
                    }
                    column(ShowOppSign_format; FORMAT("Show Opposite Sign"))
                    {
                    }
                    column(NewPage_format; FORMAT("New Page"))
                    {
                    }
                    column(AnalysisView__Dimension_1_Code_; AnalysisView."Dimension 1 Code")
                    {
                    }
                    column(AccSchedLineSpec__Dimension_1_Totaling_; "Dimension 1 Totaling")
                    {
                    }
                    column(AnalysisView__Dimension_2_Code_; AnalysisView."Dimension 2 Code")
                    {
                    }
                    column(AccSchedLineSpec__Dimension_2_Totaling_; "Dimension 2 Totaling")
                    {
                    }
                    column(AnalysisView__Dimension_3_Code_; AnalysisView."Dimension 3 Code")
                    {
                    }
                    column(AccSchedLineSpec__Dimension_3_Totaling_; "Dimension 3 Totaling")
                    {
                    }
                    column(AnalysisView__Dimension_4_Code_; AnalysisView."Dimension 4 Code")
                    {
                    }
                    column(AccSchedLineSpec__Dimension_4_Totaling_; "Dimension 4 Totaling")
                    {
                    }
                    column(AccSchedLineSpec_Schedule_Name; "Schedule Name")
                    {
                    }
                    column(SetupLineShadowed; LineShadowed)
                    {
                    }
                    column(AccSchedLineSpec__Show_Opposite_Sign_Caption; AccSchedLineSpec__Show_Opposite_Sign_CaptionLbl)
                    {
                    }
                    column(AccSchedLineSpec_UnderlineCaption; AccSchedLineSpec_UnderlineCaptionLbl)
                    {
                    }
                    column(AccSchedLineSpec_ItalicCaption; AccSchedLineSpec_ItalicCaptionLbl)
                    {
                    }
                    column(AccSchedLineSpec_BoldCaption; AccSchedLineSpec_BoldCaptionLbl)
                    {
                    }
                    column(AccSchedLineSpec_ShowCaption; AccSchedLineSpec_ShowCaptionLbl)
                    {
                    }
                    column(AccSchedLineSpec__New_Page_Caption; AccSchedLineSpec__New_Page_CaptionLbl)
                    {
                    }
                    column(AccSchedLineSpec__Totaling_Type_Caption; AccSchedLineSpec__Totaling_Type_CaptionLbl)
                    {
                    }
                    column(AccSchedLineSpec_TotalingCaption; AccSchedLineSpec_TotalingCaptionLbl)
                    {
                    }
                    column(AnalysisView__Dimension_1_Code_Caption; AnalysisView__Dimension_1_Code_CaptionLbl)
                    {
                    }
                    column(AccSchedLineSpec__Row_Type_Caption; AccSchedLineSpec__Row_Type_CaptionLbl)
                    {
                    }
                    column(AccSchedLineSpec__Amount_Type_Caption; AccSchedLineSpec__Amount_Type_CaptionLbl)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        IF "Row No." <> '' THEN
                            LineShadowed := NOT LineShadowed
                        ELSE
                            LineShadowed := FALSE;
                    end;

                    trigger OnPreDataItem()
                    begin
                        IF NOT ShowAccSchedSetup THEN
                            CurrReport.BREAK;

                        NextPageGroupNo += 1;
                    end;
                }
                dataitem(PageBreak; Integer)
                {
                    DataItemTableView = SORTING(Number)
                                        WHERE(Number = CONST(1));

                    trigger OnAfterGetRecord()
                    begin
                        CurrReport.NEWPAGE;
                    end;

                    trigger OnPreDataItem()
                    begin
                        IF NOT ShowAccSchedSetup THEN
                            CurrReport.BREAK;
                    end;
                }
                dataitem("Acc. Schedule Line"; "Acc. Schedule Line")
                {
                    DataItemLink = "Schedule Name" = FIELD(Name);
                    DataItemLinkReference = AccScheduleName;
                    DataItemTableView = SORTING("Schedule Name", "Line No.");
                    PrintOnlyIfDetail = true;
                    column(NextPageGroupNo; NextPageGroupNo)
                    {
                        //OptionCaption = 'None,Division by Zero,Period Error,Both';
                    }
                    column(Acc__Schedule_Line_Description; Description)
                    {
                    }
                    column(Acc__Schedule_Line__Row_No; "Row No.")
                    {
                    }
                    column(Acc__Schedule_Line_Line_No; "Line No.")
                    {
                    }
                    column(Bold_control; Bold_control)
                    {
                    }
                    column(Italic_control; Italic_control)
                    {
                    }
                    column(Underline_control; Underline_control)
                    {
                    }
                    column(LineShadowed; LineShadowed)
                    {
                    }
                    dataitem("Column Layout"; "Column Layout")
                    {
                        column(ColumnNo; "Column No.")
                        {
                        }
                        column(Header; Header)
                        {
                        }
                        column(RoundingHeader; RoundingHeader)
                        {
                            AutoCalcField = false;
                        }
                        column(ColumnValuesAsText; ColumnValuesAsText)
                        {
                            AutoCalcField = false;
                        }
                        column(LineSkipped; LineSkipped)
                        {
                        }
                        column(LineNo_ColumnLayout; "Line No.")
                        {
                        }
                        column(Orientacion_linea; FORMAT("Acc. Schedule Line".Orientation))
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            IF Show = Show::Never THEN
                                CurrReport.SKIP;

                            Header := "Column Header";
                            RoundingHeader := '';

                            IF "Rounding Factor" IN ["Rounding Factor"::"1000", "Rounding Factor"::"1000000"] THEN
                                CASE "Rounding Factor" OF
                                    "Rounding Factor"::"1000":
                                        RoundingHeader := Text000;
                                    "Rounding Factor"::"1000000":
                                        RoundingHeader := Text001;
                                END;

                            ColumnValuesAsText := '';

                            ColumnValuesDisplayed := AccSchedManagement.CalcCell("Acc. Schedule Line", "Column Layout", UseAmtsInAddCurr);
                            IF AccSchedManagement.GetDivisionError THEN BEGIN
                                IF ShowError IN [ShowError::"Division by Zero", ShowError::Both] THEN
                                    ColumnValuesAsText := Text002;
                            END ELSE
                                IF AccSchedManagement.GetPeriodError THEN BEGIN
                                    IF ShowError IN [ShowError::"Period Error", ShowError::Both] THEN
                                        ColumnValuesAsText := Text004;
                                END ELSE BEGIN
                                    ColumnValuesAsText :=
                                      AccSchedManagement.FormatCellAsText("Column Layout", ColumnValuesDisplayed, FALSE);

                                    IF "Acc. Schedule Line"."Totaling Type" = "Acc. Schedule Line"."Totaling Type"::Formula THEN
                                        CASE "Acc. Schedule Line".Show OF
                                            "Acc. Schedule Line".Show::"When Positive Balance":
                                                IF ColumnValuesDisplayed < 0 THEN
                                                    ColumnValuesAsText := '';
                                            "Acc. Schedule Line".Show::"When Negative Balance":
                                                IF ColumnValuesDisplayed > 0 THEN
                                                    ColumnValuesAsText := '';
                                            "Acc. Schedule Line".Show::"If Any Column Not Zero":
                                                IF ColumnValuesDisplayed = 0 THEN
                                                    ColumnValuesAsText := '';
                                        END;
                                END;

                            IF (ColumnValuesAsText <> '') OR ("Acc. Schedule Line".Show = "Acc. Schedule Line".Show::Yes) THEN
                                LineSkipped := FALSE;
                        end;

                        trigger OnPostDataItem()
                        begin
                            IF LineSkipped THEN
                                LineShadowed := NOT LineShadowed;
                        end;

                        trigger OnPreDataItem()
                        begin
                            SETRANGE("Column Layout Name", ColumnLayoutName);
                            LineSkipped := TRUE;
                        end;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        IF (Show = Show::No) OR NOT ShowLine(Bold, Italic) THEN
                            CurrReport.SKIP;

                        Bold_control := Bold;
                        Italic_control := Italic;
                        Underline_control := Underline;
                        PageGroupNo := NextPageGroupNo;
                        IF "New Page" THEN
                            NextPageGroupNo := PageGroupNo + 1;

                        IF "Row No." <> '' THEN
                            LineShadowed := NOT LineShadowed
                        ELSE
                            LineShadowed := FALSE;
                    end;

                    trigger OnPreDataItem()
                    begin
                        PageGroupNo := NextPageGroupNo;

                        SETFILTER("Date Filter", DateFilter);
                        SETFILTER("G/L Budget Filter", GLBudgetFilter);
                        SETFILTER("Cost Budget Filter", CostBudgetFilter);
                        SETFILTER("Business Unit Filter", BusinessUnitFilter);
                        SETFILTER("Dimension 1 Filter", Dim1Filter);
                        SETFILTER("Dimension 2 Filter", Dim2Filter);
                        SETFILTER("Dimension 3 Filter", Dim3Filter);
                        SETFILTER("Dimension 4 Filter", Dim4Filter);
                        SETFILTER("Cost Center Filter", CostCenterFilter);
                        SETFILTER("Cost Object Filter", CostObjectFilter);
                        SETFILTER("Cash Flow Forecast Filter", CashFlowFilter);
                    end;
                }
            }

            trigger OnAfterGetRecord()
            begin

                CurrReport.PAGENO := 1;
                GLSetup.GET;
                IF "Analysis View Name" <> '' THEN BEGIN
                    AnalysisView.GET("Analysis View Name");
                END ELSE BEGIN
                    AnalysisView.INIT;
                    AnalysisView."Dimension 1 Code" := GLSetup."Global Dimension 1 Code";
                    AnalysisView."Dimension 2 Code" := GLSetup."Global Dimension 2 Code";
                END;

                IF UseAmtsInAddCurr THEN
                    HeaderText := STRSUBSTNO(Text003, GLSetup."Additional Reporting Currency")
                ELSE
                    IF GLSetup."LCY Code" <> '' THEN
                        HeaderText := STRSUBSTNO(Text003, GLSetup."LCY Code")
                    ELSE
                        HeaderText := '';
            end;

            trigger OnPreDataItem()
            begin
                SETRANGE(Name, AccSchedName);

                PageGroupNo := 1;
                NextPageGroupNo := 1;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options', Comment = 'ESM="Opciones"';
                    group(Layout)
                    {
                        Caption = 'Layout', Comment = 'ESM="Disposición"';
                        field(AccSchedNam; AccSchedName)
                        {
                            Caption = 'Acc. Schedule Name', Comment = 'ESM="Nombre Estructura de Cuentas"';
                            Editable = false;
                            Lookup = true;
                            TableRelation = "Acc. Schedule Name";

                            trigger OnLookup(var Text: Text): Boolean
                            begin
                                //EXIT(AccSchedManagement.LookupName(AccSchedName,Text));
                            end;

                            trigger OnValidate()
                            begin
                                //ValidateAccSchedName
                            end;
                        }
                        field(ColumnLayoutNames; ColumnLayoutName)
                        {
                            Caption = 'Column Layout Name', Comment = 'ESM="Nombre plantilla columna"';
                            Editable = false;
                            Lookup = true;
                            TableRelation = "Column Layout Name".Name;

                            trigger OnLookup(var Text: Text): Boolean
                            begin
                                EXIT(AccSchedManagement.LookupColumnName(ColumnLayoutName, Text));
                            end;

                            trigger OnValidate()
                            begin
                                IF ColumnLayoutName = '' THEN
                                    ERROR(Text006);
                                AccSchedManagement.CheckColumnName(ColumnLayoutName);
                            end;
                        }
                        field(DateFilters; DateFilter)
                        {
                            Caption = 'Date Filter', Comment = 'ESM="Filtro fecha"';

                            trigger OnValidate()
                            var
                                ApplicationManagement: Codeunit "Filter Tokens";
                            begin

                                ApplicationManagement.MakeDateFilter(DateFilter);
                                "Acc. Schedule Line".SETFILTER("Date Filter", DateFilter);
                                DateFilter := "Acc. Schedule Line".GETFILTER("Date Filter");
                            end;
                        }
                        field(UseAmtsInAddCurr; UseAmtsInAddCurr)
                        {
                            Caption = 'Show Amounts in Add. Reporting Currency', Comment = 'ESM="Muestra importes en div.-adic."';
                            MultiLine = true;
                        }
                        field(Gejercicio; Gejercicio)
                        {
                            Caption = 'Ejercicio', Comment = 'ESM="Ejercicio"';
                        }
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            AccSchedName := '320';
            ColumnLayoutName := 'SALDO-A';
        end;

        trigger OnOpenPage()
        begin
            GLSetup.GET;
            //IF AccSchedName <> '' THEN
            //  ValidateAccSchedName;
            AccSchedName := '320';
            ColumnLayoutName := 'SALDO-A';
        end;
    }

    labels
    {
        AccSchedLineSpec_DescriptionCaptionLbl = 'Description';
        AccSchedLineSpec__Row_No__CaptionLbl = 'Row No.';
    }

    trigger OnInitReport()
    begin
        AccSchedName := '320';
        ColumnLayoutName := 'SALDO-A';
    end;

    trigger OnPreReport()
    begin
        TransferValues;
        UpdateFilters;
        InitAccSched;
        CompanyInfo.GET;
    end;

    var
        Text000: Label '(Thousands)';
        Text001: Label '(Millions)';
        Text002: Label '* ERROR *';
        Text003: Label 'All amounts are in %1.';
        AnalysisView: Record "Analysis View";
        GLSetup: Record "General Ledger Setup";
        AccSchedManagement: Codeunit "AccSchedManagement";
        gCuAccountigPeriodMgt: Codeunit "Accounting Period Mgt.";
        AccSchedName: Code[10];
        AccSchedNameHidden: Code[10];
        ColumnLayoutName: Code[10];
        ColumnLayoutNameHidden: Code[10];
        EndDate: Date;
        ShowError: Option "None","Division by Zero","Period Error",Both;
        DateFilter: Text[30];
        UseHiddenFilters: Boolean;
        DateFilterHidden: Text[30];
        GLBudgetFilter: Text[30];
        GLBudgetFilterHidden: Text[30];
        CostBudgetFilter: Text[30];
        CostBudgetFilterHidden: Text[30];
        BusinessUnitFilter: Text[30];
        BusinessUnitFilterHidden: Text[30];
        Dim1Filter: Text[250];
        Dim1FilterHidden: Text[250];
        Dim2Filter: Text[250];
        Dim2FilterHidden: Text[250];
        Dim3Filter: Text[250];
        Dim3FilterHidden: Text[250];
        Dim4Filter: Text[250];
        Dim4FilterHidden: Text[250];
        CostCenterFilter: Text[250];
        CostObjectFilter: Text[250];
        CashFlowFilter: Text[250];
        FiscalStartDate: Date;
        ColumnValuesDisplayed: Decimal;
        ColumnValuesAsText: Text[30];
        PeriodText: Text[30];
        AccSchedLineFilter: Text[250];
        Header: Text[30];
        RoundingHeader: Text[30];
        UseAmtsInAddCurr: Boolean;
        ShowAccSchedSetup: Boolean;
        HeaderText: Text[100];
        Text004: Label 'Not Available';
        Text005: Label '1,6,,Dimension %1 Filter';
        Bold_control: Boolean;
        Italic_control: Boolean;
        Underline_control: Boolean;
        PageGroupNo: Integer;
        NextPageGroupNo: Integer;
        Text006: Label 'Enter the Column Layout Name.';
        [InDataSet]
        Dim1FilterEnable: Boolean;
        [InDataSet]
        Dim2FilterEnable: Boolean;
        [InDataSet]
        Dim3FilterEnable: Boolean;
        [InDataSet]
        Dim4FilterEnable: Boolean;
        LineShadowed: Boolean;
        LineSkipped: Boolean;
        ColumnLayoutNameCaptionLbl: Label 'Column Layout';
        AccScheduleName_Name_CaptionLbl: Label 'Account Schedule';
        FiscalStartDateCaptionLbl: Label 'Fiscal Start Date';
        PeriodTextCaptionLbl: Label 'Period';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Account_ScheduleCaptionLbl: Label 'Account Schedule';
        AnalysisView_CodeCaptionLbl: Label 'Analysis View';
        AccSchedLineSpec__Show_Opposite_Sign_CaptionLbl: Label 'Show Opposite Sign';
        AccSchedLineSpec_UnderlineCaptionLbl: Label 'Underline';
        AccSchedLineSpec_ItalicCaptionLbl: Label 'Italic';
        AccSchedLineSpec_BoldCaptionLbl: Label 'Bold';
        AccSchedLineSpec_ShowCaptionLbl: Label 'Show';
        AccSchedLineSpec__New_Page_CaptionLbl: Label 'New Page';
        AccSchedLineSpec__Totaling_Type_CaptionLbl: Label 'Totaling Type';
        AccSchedLineSpec_TotalingCaptionLbl: Label 'Totaling';
        AnalysisView__Dimension_1_Code_CaptionLbl: Label 'Dimension Code';
        AccSchedLineSpec__Row_Type_CaptionLbl: Label 'Row Type';
        AccSchedLineSpec__Amount_Type_CaptionLbl: Label 'Amount Type';
        CompanyInfo: Record "Company Information";
        Gejercicio: Text[20];

    procedure InitAccSched()
    begin
        AccScheduleName.SETRANGE(Name, AccSchedName);
        "Acc. Schedule Line".SETFILTER("Date Filter", DateFilter);
        "Acc. Schedule Line".SETFILTER("G/L Budget Filter", GLBudgetFilter);
        "Acc. Schedule Line".SETFILTER("Cost Budget Filter", CostBudgetFilter);
        "Acc. Schedule Line".SETFILTER("Business Unit Filter", BusinessUnitFilter);
        "Acc. Schedule Line".SETFILTER("Dimension 1 Filter", Dim1Filter);
        "Acc. Schedule Line".SETFILTER("Dimension 2 Filter", Dim2Filter);
        "Acc. Schedule Line".SETFILTER("Dimension 3 Filter", Dim3Filter);
        "Acc. Schedule Line".SETFILTER("Dimension 4 Filter", Dim4Filter);
        "Acc. Schedule Line".SETFILTER("Cost Center Filter", CostCenterFilter);
        "Acc. Schedule Line".SETFILTER("Cost Object Filter", CostObjectFilter);
        "Acc. Schedule Line".SETFILTER("Cash Flow Forecast Filter", CashFlowFilter);

        EndDate := "Acc. Schedule Line".GETRANGEMAX("Date Filter");
        FiscalStartDate := gCuAccountigPeriodMgt.FindFiscalYear(EndDate);

        AccSchedLineFilter := "Acc. Schedule Line".GETFILTERS;
        PeriodText := "Acc. Schedule Line".GETFILTER("Date Filter");
    end;

    procedure SetAccSchedName(NewAccSchedName: Code[10])
    begin
        AccSchedNameHidden := NewAccSchedName;
    end;

    procedure SetColumnLayoutName(ColLayoutName: Code[10])
    begin
        ColumnLayoutNameHidden := ColLayoutName;
    end;

    procedure SetFilters(NewDateFilter: Text[30]; NewBudgetFilter: Text[30]; NewCostBudgetFilter: Text[30]; NewBusUnitFilter: Text[30]; NewDim1Filter: Text[250]; NewDim2Filter: Text[250]; NewDim3Filter: Text[250]; NewDim4Filter: Text[250])
    begin
        DateFilterHidden := NewDateFilter;
        GLBudgetFilterHidden := NewBudgetFilter;
        CostBudgetFilterHidden := NewCostBudgetFilter;
        BusinessUnitFilterHidden := NewBusUnitFilter;
        Dim1FilterHidden := NewDim1Filter;
        Dim2FilterHidden := NewDim2Filter;
        Dim3FilterHidden := NewDim3Filter;
        Dim4FilterHidden := NewDim4Filter;
        UseHiddenFilters := TRUE;
    end;

    procedure ShowLine(Bold: Boolean; Italic: Boolean): Boolean
    begin
        IF "Acc. Schedule Line"."Totaling Type" = "Acc. Schedule Line"."Totaling Type"::"Set Base For Percent" THEN
            EXIT(FALSE);
        IF "Acc. Schedule Line".Show = "Acc. Schedule Line".Show::No THEN
            EXIT(FALSE);
        IF "Acc. Schedule Line".Bold <> Bold THEN
            EXIT(FALSE);
        IF "Acc. Schedule Line".Italic <> Italic THEN
            EXIT(FALSE);

        EXIT(TRUE);
    end;

    local procedure FormLookUpDimFilter(Dim: Code[20]; var Text: Text[1024]): Boolean
    var
        DimVal: Record "Dimension Value";
        DimValList: Page "Dimension Value List";
    begin
        IF Dim = '' THEN
            EXIT(FALSE);
        DimValList.LOOKUPMODE(TRUE);
        DimVal.SETRANGE("Dimension Code", Dim);
        DimValList.SETTABLEVIEW(DimVal);
        IF DimValList.RUNMODAL = ACTION::LookupOK THEN BEGIN
            DimValList.GETRECORD(DimVal);
            Text := DimValList.GetSelectionFilter;
            EXIT(TRUE);
        END;
        EXIT(FALSE)
    end;

    local procedure FormGetCaptionClass(DimNo: Integer): Text[250]
    begin
        CASE DimNo OF
            1:
                BEGIN
                    IF AnalysisView."Dimension 1 Code" <> '' THEN
                        EXIT('1,6,' + AnalysisView."Dimension 1 Code");
                    EXIT(STRSUBSTNO(Text005, DimNo));
                END;
            2:
                BEGIN
                    IF AnalysisView."Dimension 2 Code" <> '' THEN
                        EXIT('1,6,' + AnalysisView."Dimension 2 Code");
                    EXIT(STRSUBSTNO(Text005, DimNo));
                END;
            3:
                BEGIN
                    IF AnalysisView."Dimension 3 Code" <> '' THEN
                        EXIT('1,6,' + AnalysisView."Dimension 3 Code");
                    EXIT(STRSUBSTNO(Text005, DimNo));
                END;
            4:
                BEGIN
                    IF AnalysisView."Dimension 4 Code" <> '' THEN
                        EXIT('1,6,' + AnalysisView."Dimension 4 Code");
                    EXIT(STRSUBSTNO(Text005, DimNo));
                END;
        END;
    end;

    local procedure TransferValues()
    begin
        GLSetup.GET;
        IF AccSchedNameHidden <> '' THEN
            AccSchedName := AccSchedNameHidden;
        IF ColumnLayoutNameHidden <> '' THEN
            ColumnLayoutName := ColumnLayoutNameHidden;

        IF AccSchedName <> '' THEN
            IF NOT AccScheduleName.GET(AccSchedName) THEN
                AccSchedName := '';
        IF AccSchedName = '' THEN
            IF AccScheduleName.FINDFIRST THEN
                AccSchedName := AccScheduleName.Name;

        IF AccScheduleName."Analysis View Name" <> '' THEN
            AnalysisView.GET(AccScheduleName."Analysis View Name")
        ELSE BEGIN
            AnalysisView."Dimension 1 Code" := GLSetup."Global Dimension 1 Code";
            AnalysisView."Dimension 2 Code" := GLSetup."Global Dimension 2 Code";
        END;
    end;

    local procedure UpdateFilters()
    begin
        IF UseHiddenFilters THEN BEGIN
            DateFilter := DateFilterHidden;
            GLBudgetFilter := GLBudgetFilterHidden;
            CostBudgetFilter := CostBudgetFilterHidden;
            BusinessUnitFilter := BusinessUnitFilterHidden;
            Dim1Filter := Dim1FilterHidden;
            Dim2Filter := Dim2FilterHidden;
            Dim3Filter := Dim3FilterHidden;
            Dim4Filter := Dim4FilterHidden;
        END;

        IF ColumnLayoutName = '' THEN
            IF AccScheduleName.FINDFIRST THEN
                ColumnLayoutName := AccScheduleName."Default Column Layout";
    end;

    procedure ValidateAccSchedName()
    begin
        AccSchedManagement.CheckName(AccSchedName);
        AccScheduleName.GET(AccSchedName);
        IF AccScheduleName."Default Column Layout" <> '' THEN
            ColumnLayoutName := AccScheduleName."Default Column Layout";
        IF AccScheduleName."Analysis View Name" <> '' THEN
            AnalysisView.GET(AccScheduleName."Analysis View Name")
        ELSE BEGIN
            CLEAR(AnalysisView);
            AnalysisView."Dimension 1 Code" := GLSetup."Global Dimension 1 Code";
            AnalysisView."Dimension 2 Code" := GLSetup."Global Dimension 2 Code";
        END;
        Dim1FilterEnable := AnalysisView."Dimension 1 Code" <> '';
        Dim2FilterEnable := AnalysisView."Dimension 2 Code" <> '';
        Dim3FilterEnable := AnalysisView."Dimension 3 Code" <> '';
        Dim4FilterEnable := AnalysisView."Dimension 4 Code" <> '';
    end;
}

