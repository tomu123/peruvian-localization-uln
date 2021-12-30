query 51000 "ULN Get Last Transaction CUO"
{
    QueryType = Normal;

    elements
    {
        dataitem(ULN_CUO_Entry; "ULN CUO Entry")
        {
            column(CUO_Transaction_No_; "CUO Transaction No.")
            {
                Method = Max;
            }
        }
    }
}