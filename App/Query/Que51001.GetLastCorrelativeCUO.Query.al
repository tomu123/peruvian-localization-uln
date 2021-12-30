query 51001 "ULN Get Last Correlative CUO"
{
    QueryType = Normal;

    elements
    {
        dataitem(ULN_CUO_Entry; "ULN CUO Entry")
        {
            column(Last__used_CUO_Correlative; "Last. used CUO Correlative")
            {

            }
            filter(CUO_Transaction_No_Filter; "CUO Transaction No.") { }
        }
    }
}