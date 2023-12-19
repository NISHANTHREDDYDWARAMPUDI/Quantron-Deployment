tableextension 50043 SaleLine extends "Sales Line"
{
    fields
    {
        //QTD-00002>>
        field(50001; Inventory; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("No."),
                                                                  "Location Code" = FIELD("Location Code"),
                                                                  "Variant Code" = field("Variant Code")));
            Caption = 'Inventory';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(50002; Revision; Code[20])
        {
            Editable = false;
            DataClassification = ToBeClassified;
            Caption = 'Revision';
        }
        //QTD-00002<<
    }
}