tableextension 50019 PurchCrMemoLine extends "Purch. Cr. Memo Line"
{
    fields
    {
        field(50010; "Quality Check"; Boolean)
        {
            Editable = false;
            Caption = 'Quality Check';
            DataClassification = ToBeClassified;
        }
        field(50011; "Quality Spec ID"; Code[20])
        {
            Editable = false;
            Caption = 'Quality Spec ID';
            DataClassification = ToBeClassified;
            TableRelation = "Quality Specification Header"."Spec ID" where(Active = const(true), "Specification Type" = const(Incoming));
        }
        field(50012; "Quality Check Completed"; Boolean)
        {
            Caption = 'Quality Check Completed';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(50013; "New Location Code"; Code[10])
        {
            Caption = 'New Location Code';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
            Editable = false;
        }
        field(50015; Revision; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Revision';
        }
    }
}
