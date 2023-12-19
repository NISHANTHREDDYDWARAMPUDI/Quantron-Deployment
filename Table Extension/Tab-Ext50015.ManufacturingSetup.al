tableextension 50015 ManufacturingSetup extends "Manufacturing Setup"
{
    fields
    {
        field(50000; "Quality Spec Nos."; Code[20])
        {
            Caption = 'Quality Spec Nos.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50001; "Sales Team Email"; Text[250])
        {
            Caption = 'Sales Team Email';
            DataClassification = ToBeClassified;
        }
        field(50002; "Account Team Email"; Text[250])
        {
            Caption = 'Account Team Email';
            DataClassification = ToBeClassified;
        }
        field(50003; "Inter Ship Transfer From"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Internal Shipment Transfer From';
            TableRelation = Location;
        }
        field(50004; "Inter Ship Transfer To"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Internal Shipment Transfer To';
            TableRelation = Location;
        }
        field(50005; "Int Ship Cust No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Internal Shipment Customer No.';
            TableRelation = Customer;
        }
        field(50006; "Def. Pick List Transfer From"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Default Pick List Transfer From Code';
            TableRelation = Location;
        }
        field(50007; "Def. Pick List Bin Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Default Pick List Bin Code';
            TableRelation = Bin.Code WHERE("Location Code" = FIELD("Def. Pick List Transfer From"));
        }

    }
}
