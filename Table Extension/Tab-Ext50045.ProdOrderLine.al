tableextension 50045 ProdOrderLine extends "Prod. Order Line"
{
    fields
    {
        field(50000; "SO Line No."; Integer)
        {
            Caption = 'Sales Order Line No.';
            DataClassification = ToBeClassified;
        }
        field(50001; Revision; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Revision';
        }
    }
}
