tableextension 50052 ServiceItemLine extends "Service Item Line"
{
    fields
    {
        field(50001; Mileage; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Mileage';
            trigger OnValidate()
            var
                serviceitemRec: Record "Service Item";
            begin
                serviceitemRec.Reset();
                serviceitemRec.SetRange("No.", "Service Item No.");
                if serviceitemRec.FindFirst() then begin
                    if (serviceitemRec."KM-Status" < Mileage) then begin
                        serviceitemRec.Validate("KM-Status", Mileage);
                        serviceitemRec.Modify();
                    end;
                end;
            end;

        }

    }

    var
        myInt: Integer;
}