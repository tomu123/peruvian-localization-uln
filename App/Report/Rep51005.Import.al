report 51005 Import
{
    Caption = 'Importacion', Comment = 'ESM="Importación"';
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC; // if Word use WordLayout property
    RDLCLayout = './App/Report/RDLC/MyRDLImportacion.rdl';

    dataset
    {
        dataitem(Importation; Importation)
        {
            RequestFilterFields = "No.";
            column(No_Importacion; "No.")
            {
            }
            column(Descripcion_Importacion; Description)
            {
            }
            column(FechaImportacion_Importacion; "Import Date")
            {
            }
            column(ResponsableImportacion_Importacion; "Import Manager")
            {
            }
            dataitem(PurchInvLine; "Purch. Inv. Line")
            {
                //DataItemLinkReference = Importation;
                DataItemLink = "Importation No." = field("No.");
                column(LineAmount_PurchInvLine; "Line Amount")
                {
                    IncludeCaption = true;
                }
                column(Ndeimportación_PurchInvLine; "Importation No.")
                {
                    IncludeCaption = true;
                }
                column(DocumentNo_PurchInvLine; "Document No.")
                {
                    IncludeCaption = true;
                }
                column(ExtDocNo_PurchInv; PurchInvHeader."Vendor Invoice No.")
                {
                }
                column(Type_PurchInvLine; Type)
                {
                    IncludeCaption = true;
                }
                column(No_PurchInvLine; "No.")
                {
                    IncludeCaption = true;
                }
                column(PostingGroup_PurchInvLine; "Posting Group")
                {
                    IncludeCaption = true;
                }
                column(LocationCode_PurchInvLine; "Location Code")
                {
                    IncludeCaption = true;
                }
                column(Description_PurchInvLine; Description)
                {
                    IncludeCaption = true;
                }
                column(Quantity_PurchInvLine; Quantity)
                {
                    IncludeCaption = true;
                }
                column(UnitofMeasure_PurchInvLine; "Unit of Measure")
                {
                    IncludeCaption = true;
                }
                column(BuyfromVendorNo_PurchInvLine; "Buy-from Vendor No.")
                {
                    IncludeCaption = true;
                }
                column(ImporteLineDL; ImporteLineDL)
                {

                }
                column(ImporteLineDL2; ImporteLineDL2)
                {

                }
                column(ImporteLineDA; ImporteLineDA)
                {

                }
                column(ImporteLineDA2; ImporteLineDA2)
                {

                }
                trigger OnAfterGetRecord()
                begin
                    ImporteLineDL := 0;
                    ImporteLineDA := 0;
                    ImporteLineDA2 := 0;
                    ImporteLineDL2 := 0;
                    PurchInvHeader.GET("Document No.");
                    if PurchInvHeader."Currency Code" = '' Then
                        ImporteLineDL := "Line Amount"
                    else
                        ImporteLineDL := ROUND("Line Amount" / PurchInvHeader."Currency Factor", 0.01);

                    CurrExchRate.SetRange("Starting Date", "Posting Date");
                    CurrExchRate.SetRange(CurrExchRate."Currency Code", 'USD');
                    CurrExchRate.FindSet();
                    ImporteLineDA := Round(ImporteLineDL / CurrExchRate."Relational Exch. Rate Amount", 0.01);

                    if PurchInvHeader."Currency Code" <> '' Then
                        ImporteLineDA := "Line Amount";

                    if Type = Type::"Charge (Item)" Then begin
                        ImporteLineDA2 := ImporteLineDA;
                        ImporteLineDL2 := ImporteLineDL;
                    end;
                end;
            }
            dataitem("ItemLedgerEntry"; "Item Ledger Entry")
            {

                DataItemLink = "Importation No." = field("No.");
                column(CostAmountActual_ItemLedgerEntry; "Cost Amount (Actual)")
                {
                    IncludeCaption = true;
                }
                column(Ndeimportación_ItemLedgerEntry; "Importation No.")
                {
                    IncludeCaption = true;
                }
                column(ItemNo_ItemLedgerEntry; "Item No.")
                {
                    IncludeCaption = true;
                }
                column(PostingDate_ItemLedgerEntry; "Posting Date")
                {
                    IncludeCaption = true;
                }
                column(EntryType_ItemLedgerEntry; "Entry Type")
                {
                    IncludeCaption = true;
                }
                column(DocumentNo_ItemLedgerEntry; "Document No.")
                {
                    IncludeCaption = true;
                }
                column(LocationCode_ItemLedgerEntry; "Location Code")
                {
                    IncludeCaption = true;
                }
                column(Quantity_ItemLedgerEntry; Quantity)
                {
                    IncludeCaption = true;
                }
                column(CostAmountActualACY_ItemLedgerEntry; "Cost Amount (Actual) (ACY)")
                {
                    IncludeCaption = true;
                }
                column(Descripcion_Producto; Item.Description)
                {
                    IncludeCaption = true;
                }
                trigger OnAfterGetRecord()
                begin
                    Item.Get("ItemLedgerEntry"."Item No.");
                    ItemLedgerEntry.CalcFields("Cost Amount (Actual)", "Cost Amount (Actual) (ACY)");
                end;
            }
        }
    }
    var
        Item: Record Item;
        ImporteLineDL: Decimal;
        PurchInvHeader: Record "Purch. Inv. Header";
        ImporteLineDA: Decimal;
        CurrExchRate: Record "Currency Exchange Rate";
        ImporteLineDA2: Decimal;
        ImporteLineDL2: Decimal;
        ExternalDocumentNo: Code[20];
}