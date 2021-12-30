tableextension 51074 "Ubigeo Order Address" extends "Order Address"
{
    fields
    {
        // Add changes to table fields here
        modify(County)
        {
            TableRelation = Ubigeo."District Code" where("Province Code" = field(City), "Departament Code" = field("Post Code"));
        }
    }

    var
        Ubigeo: Record Ubigeo;
}