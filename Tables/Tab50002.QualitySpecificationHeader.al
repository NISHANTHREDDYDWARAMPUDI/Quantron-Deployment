table 50002 "Quality Specification Header"
{
    Caption = 'Quality Document Header';
    DataClassification = ToBeClassified;
    LookupPageId = "Quality Specification List";
    DrillDownPageId = "Quality Specification List";

    fields
    {
        field(1; "Spec ID"; Code[20])
        {
            Caption = 'Spec ID';
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(4; Active; Boolean)
        {
            Caption = 'Active';
            DataClassification = ToBeClassified;
        }
        field(5; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            DataClassification = CustomerContent;
        }
        field(6; "Specification Type"; Enum SpecificationType)
        {
            Caption = 'Specification Type';
            DataClassification = ToBeClassified;
        }
        field(7; "Time (Hours)"; Decimal)
        {
            Caption = 'Time (Hours)';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Spec ID")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        ManufacturingSetup.GET();
        ManufacturingSetup.TESTFIELD("Quality Spec Nos.");
        if "Spec ID" = '' then
            NoSeriesMgt.InitSeries(ManufacturingSetup."Quality Spec Nos.", xRec."No. Series", 0D, "Spec ID", "No. Series");
    end;

    trigger OnRename()
    begin
        Error(RenameErr);
    end;

    procedure AssistEdit(OldSpec: Record "Quality Specification Header"): Boolean
    begin
        Spec := Rec;
        ManufacturingSetup.GET();
        ManufacturingSetup.TESTFIELD("Quality Spec Nos.");
        if NoSeriesMgt.SelectSeries(ManufacturingSetup."Quality Spec Nos.", OldSpec."No. Series", Spec."No. Series") then begin
            NoSeriesMgt.SetSeries(Spec."Spec ID");
            Rec := Spec;
            exit(true);
        end;
    end;

    var
        ManufacturingSetup: Record "Manufacturing Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Spec: Record "Quality Specification Header";
        RenameErr: Label 'Cannot rename.';
}
