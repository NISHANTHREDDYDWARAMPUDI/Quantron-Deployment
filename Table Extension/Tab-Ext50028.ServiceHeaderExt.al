tableextension 50028 ServiceHeaderExt extends "Service Header"
{
    fields
    {
        field(50000; "Shipment date"; Date)
        {
            Caption = 'Shipment Date';
            DataClassification = CustomerContent;
            //B2BDNROn12May2023>>
            trigger OnValidate()
            var
                ServicelineG: Record "Service Line";
                ConfirmLbl: Label 'Do you want to update the Shipment date in service lines?';
            begin
                if xRec."Shipment date" = Rec."Shipment date" then
                    exit;
                if Confirm(ConfirmLbl, true, false) then begin
                    ServicelineG.Reset();
                    ServicelineG.SetRange("Document No.", "No.");
                    if ServicelineG.FindFirst() then
                        repeat
                            if ServicelineG."Shipment Date" = 0D then
                                ServicelineG."Shipment Date" := "Shipment date";
                            ServicelineG.Modify();
                        until ServicelineG.Next = 0;
                end;
            end;
            //B2BDNROn12May2023<<
        }
        field(50002; "Package Tracking No"; Text[30])
        {
            Caption = 'Package Tracking No.';
        }
    }
}
