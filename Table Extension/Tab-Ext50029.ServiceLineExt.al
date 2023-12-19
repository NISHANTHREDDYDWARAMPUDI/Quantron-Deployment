tableextension 50029 "Service LineExt" extends "Service Line"
{
    fields
    {
        field(50000; "Shipment Date"; Date)
        {
            Caption = 'Shipment Date';
            DataClassification = CustomerContent;
            FieldClass = Normal;
        }
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
        //QTD-00002<<
        //QTD-00006>>
        field(50002; "Print On Order"; Boolean)
        {
            Caption = 'Print On Invoice';
            DataClassification = ToBeClassified;
        }
        //QTD-00006<<

    }
    //B2BDNROn12May2023>>
    trigger OnAfterInsert()
    var
        ServiceHeaderG: Record "Service Header";
    begin
        //"Print On Order" := true;
        ServiceHeaderG.Reset();
        ServiceHeaderG.SetRange("No.", "Document No.");
        if ServiceHeaderG.FindFirst() then
            "Shipment Date" := ServiceHeaderG."Shipment date";
    end;
    //B2BDNROn12May2023<<

}
