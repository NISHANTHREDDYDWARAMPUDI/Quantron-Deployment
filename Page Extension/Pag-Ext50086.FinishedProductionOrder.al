pageextension 50086 FinishedProductionOrder extends "Finished Production Order"
{
    actions
    {
        addafter("Co&mments")
        {
            group("Internal Shipment")
            {
                Caption = 'Internal Shipment';
                Image = Document;
                action("Create Internal Shipment")
                {
                    ApplicationArea = All;
                    Caption = 'Create Internal Shipment';
                    Image = NewDocument;
                    Enabled = Rec."Order Type" = Rec."Order Type"::Internal;

                    trigger OnAction()
                    var
                        ConfirmLbl: Label 'Do you want to create the internal shipment document?.';
                    begin
                        if not Confirm(ConfirmLbl) then
                            exit;
                        Rec.CreateInternalShipDoc();
                    end;
                }
                action("Open Internal Shipment")
                {
                    ApplicationArea = All;
                    Caption = 'Open Internal Shipment';
                    Image = OpenWorksheet;
                    Enabled = Rec."Order Type" = Rec."Order Type"::Internal;
                    RunObject = page "Posted Direct Transfers";
                    RunPageLink = "Prod. Order No." = field("No.");
                }
            }
        }
    }
}
