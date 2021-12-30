enum 51020 "ULN Type Control Filter CUO"
{
    //Caption = 'Type Control Filter CUO', Comment = 'ESM="Tipo de control para filtro (CUO)"';
    Extensible = true;

    value(1; "Only Document No.")
    {
        Caption = 'Olny Document No.', Comment = 'ESM="Solo por N° Documento"';
    }
    value(2; "Filter DocNo & Pstg. Date")
    {
        Caption = 'Document No. & Posting Date', Comment = 'ESM="Por N° Documento y Fecha registro"';
    }
    value(3; "Filter DocNo & Pstg. Date & Transaction No.")
    {
        Caption = 'Document No. & Posting Date & Transaction No.', Comment = 'ESM="Por N° Documento - Fecha registro y N° Asiento"';
    }
}