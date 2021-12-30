tableextension 51073 "Ubigeo Location" extends Location
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
        Location: Record Location;
}