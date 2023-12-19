tableextension 50025 ServiceItem extends "Service Item"
{
    fields
    {
        field(50015; "Prod. Order No."; Code[20])
        {
            Caption = 'Prod. Order No.';
            DataClassification = ToBeClassified;
        }
        field(50016; "Prod. Order Line No."; Integer)
        {
            Caption = 'Prod. Order Line No.';
            DataClassification = ToBeClassified;
        }
    }
}
