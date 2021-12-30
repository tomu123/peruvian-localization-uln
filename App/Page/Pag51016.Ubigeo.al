page 51016 "Ubigeo List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Ubigeo;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Departament Code"; "Departament Code")
                {
                    ApplicationArea = All;
                    Caption = 'No.';
                    Visible = ShowDepartament;
                }
                field(Departament; Departament)
                {
                    ApplicationArea = All;
                    Caption = 'Departament';
                    Visible = ShowDepartament;
                }
                field("Province Code"; "Province Code")
                {
                    ApplicationArea = All;
                    Caption = 'No.';
                    Visible = ShowProvince;
                }
                field(Province; Province)
                {
                    ApplicationArea = All;
                    Caption = 'Province';
                    Visible = ShowProvince;
                }
                field("District Code"; "District Code")
                {
                    ApplicationArea = All;
                    Caption = 'No.';
                    Visible = ShowDistrict;
                }
                field(District; District)
                {
                    ApplicationArea = All;
                    Caption = 'District';
                    Visible = ShowDistrict;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                }

            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if (not ShowDepartament) and (Not ShowProvince) and (Not ShowDistrict) then begin
            ShowDepartament := true;
            ShowProvince := true;
            ShowDistrict := true;
        end;
    end;

    procedure SetShowDepartament()
    begin
        ShowDepartament := true;
    end;

    procedure SetShowProvince()
    begin
        ShowProvince := true;
    end;

    procedure SetShowDistrict()
    begin
        ShowDistrict := true;
    end;

    var
        ShowDepartament: Boolean;
        ShowProvince: Boolean;
        ShowDistrict: Boolean;
}