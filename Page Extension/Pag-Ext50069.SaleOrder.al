pageextension 50069 "Sales Order" extends "Sales Order"
{
    layout
    {
        addafter("Package Tracking No.")
        {
            field("Total Gross Weight"; Rec."Total Gross Weight")
            {
                ApplicationArea = All;
            }
            field("Total Measurements"; Rec."Total Measurements")
            {
                ApplicationArea = All;
            }
        }
    }
    //B2BDNR
    trigger OnOpenPage()
    var
        SaleHeaderRec: Record "Sales Header";
    begin
        if SaleHeaderRec.Get(rec."Document Type", Rec."No.") then begin
            if SaleHeaderRec.Status = SaleHeaderRec.Status::Released then
                if (SaleHeaderRec."Posting Date" <> Today) Or (SaleHeaderRec."Shipment Date" <> Today) then
                    if Confirm(Txt0001, false, SaleHeaderRec."No.", true) then begin
                        SaleHeaderRec.Status := SaleHeaderRec.Status::Open;
                        SaleHeaderRec.validate("Posting Date", Today);
                        SaleHeaderRec.validate("Shipment Date", Today);
                        SaleHeaderRec.Status := SaleHeaderRec.Status::Released;
                        SaleHeaderRec.Modify();
                    end;
        end;
    end;
    //B2BDNR

    Var
        Txt0001: Label 'Do you want to change Shipment Date and Posting Date of %1 to Today?';
}