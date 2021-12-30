report 51006 "Import Costing"
{
    Caption = 'Import Costing', Comment = 'Costeo Importación';
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC; // if Word use WordLayout property
    RDLCLayout = './App/Report/RDLC/MyRDLImportacionCosting.rdl';
    dataset
    {
        dataitem(ItemLedgerEntry; "Item Ledger Entry")
        {
            DataItemTableView = SORTING("Entry No.") ORDER(Ascending);
            RequestFilterFields = "Importation No.", "Document No.";
            column(FORMAT_TODAY_0_4_; DateToday)
            {

            }
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(USERID; USERID)
            {
            }
            column(filtro; filtro)
            {

            }
            column(Item_Ledger_Entry__N__de_importación_; "Importation No.")
            {
            }
            column(Item_Ledger_Entry__Item_No__; "Item No.")
            {
            }
            column(Item_Ledger_Entry__Posting_Date_; "Posting Date")
            {
            }
            column(Item_Description; Item.Description)
            {
            }
            column(Item_Ledger_Entry_Quantity; Quantity)
            {
            }
            column(Item_Ledger_Entry_Nationalization; Nationalization)
            {
            }
            column(Item_Ledger_Entry__Cost_Amount__Actual__; "Cost Amount (Actual)")
            {
            }
            column(Item_Ledger_Entry__Document_No__; "Document No.")
            {
            }
            column(Item_Ledger_Entry__Cost_Amount__Actual___ACY__; "Cost Amount (Actual) (ACY)")
            {
            }
            column(Item_Ledger_Entry__Cost_Amount__Actual___Control1000000020; "Cost Amount (Actual)")
            {
            }

            column(Item_Ledger_Entry__Cost_Amount__Actual___ACY___Control1000000040; "Cost Amount (Actual) (ACY)")
            {
            }
            column(Item_Ledger_EntryCaption; Item_Ledger_EntryCaptionLbl)
            {

            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {

            }
            column(Item_Ledger_Entry__Item_No__Caption; FIELDCAPTION("Item No."))
            {

            }
            column(Item_Ledger_Entry__Posting_Date_Caption; FIELDCAPTION("Posting Date"))
            {

            }
            column(Item_DescriptionCaption; Item_DescriptionCaptionLbl)
            {

            }
            column(Item_Ledger_Entry_QuantityCaption; FIELDCAPTION(Quantity))
            {
            }
            column(Item_Ledger_Entry_NationalizationCaption; FIELDCAPTION(Nationalization))
            {
            }
            column(Value_Entry__Document_Type_Caption; "Value Entry".FIELDCAPTION("Document Type"))
            {

            }
            column(Value_Entry__Cost_per_Unit_Caption; "Value Entry".FIELDCAPTION("Cost per Unit"))
            {

            }
            column(Value_Entry__Cost_Posted_to_G_L_Caption; "Value Entry".FIELDCAPTION("Cost Posted to G/L"))
            {

            }
            column(Value_Entry__Document_No__Caption; "Value Entry".FIELDCAPTION("Document No."))
            {

            }
            column(Item_Ledger_Entry__Cost_Amount__Actual___ACY__Caption; FIELDCAPTION("Cost Amount (Actual) (ACY)"))
            {
            }
            column(Item_Ledger_Entry__N__de_importación_Caption; FIELDCAPTION("Importation No."))
            {
            }
            column(Total_Importacion__DL_Caption; Total_Importacion__DL_CaptionLbl)
            {
            }
            column(Total_Importacion_USDCaption; Total_Importacion_USDCaptionLbl)
            {
            }
            column(Item_Ledger_Entry_Entry_No_; "Entry No.")
            {
            }
            column(companypicture; gCompanyInfo.Picture)
            {
            }
            dataitem("Value Entry"; "Value Entry")
            {
                DataItemLink = "Item Ledger Entry No." = FIELD("Entry No.");
                column(Value_Entry__Item_No__; "Item No.")
                {
                }
                column(Value_Entry_Description; Description)
                {
                }
                column(Value_Entry__Document_Type_; "Document Type")
                {
                }
                column(Value_Entry__Posting_Date_; "Posting Date")
                {

                }
                column(Value_Entry__Cost_per_Unit_; "Cost per Unit")
                {

                }
                column(Value_Entry__Cost_Posted_to_G_L_; "Cost Posted to G/L")
                {

                }
                column(Value_Entry__Document_No__; "Document No.")
                {

                }
                column(Value_Entry__Cost_Amount__Actual___ACY__; "Cost Amount (Actual) (ACY)")
                {

                }
                column(Value_Entry_Entry_No_; "Entry No.")
                {

                }
                column(Value_Entry_Item_Ledger_Entry_No_; "Item Ledger Entry No.")
                {

                }
                trigger OnPreDataItem()
                begin
                    SetFilter("Value Entry"."Cost Posted to G/L", '<>%1', 0);
                end;

                trigger OnAfterGetRecord()
                begin
                    if "Value Entry".Description = '' then begin
                        "Value Entry".Description := Item.Description;
                    end;

                    IF Detalle = FALSE THEN CurrReport.SKIP;
                end;

            }
            trigger OnPreDataItem()
            begin

                LastFieldNo := FIELDNO("Entry No.");
                filtro := "ItemLedgerEntry".GETFILTERS;
                IF filtro = '' THEN
                    ERROR(ULN0001);
            end;

            trigger OnAfterGetRecord()
            begin
                DateToday := FORMAT(TODAY, 0, 4);
                Item.GET("ItemLedgerEntry"."Item No.");
            end;
        }
    }
    requestpage
    {
        SaveValues = true;
        ContextSensitiveHelpPage = 'my-feature';
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    field(Detalle; Detalle)
                    {
                        Caption = 'View Detail', Comment = 'Ver Detalle';
                    }

                }

            }

        }
        trigger OnInit()
        begin
            Detalle := TRUE;
        end;


    }
    trigger OnPreReport()
    begin
        gCompanyInfo.GET;
        gCompanyInfo.CALCFIELDS(Picture);
    end;

    var
        DateToday: Text;
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        filtro: Text[200];
        Item: Record Item;
        Detalle: Boolean;
        gCompanyInfo: Record "Company Information";
        Item_Ledger_EntryCaptionLbl: Label 'Item Ledger Entry', Comment = 'ESM="Mov. Producto"';
        CurrReport_PAGENOCaptionLbl: Label 'Page', Comment = 'ESM="Pagina"';
        Total_Importacion__DL_CaptionLbl: Label 'Total Importation (LCY)', Comment = 'ESM="Total Importación (DL)"';
        Total_Importacion_USDCaptionLbl: Label 'Total Importation USD', Comment = 'ESM="Total Importación USD"';
        ULN0001: Label 'Enter Import No.', Comment = 'ESM="Ingrese N° Importación"';
        Item_DescriptionCaptionLbl: Label 'Label1000000018';
}