pageextension 50041 ProductionOrderExt extends "Released Production Order"
{
    layout
    {
        addafter("Last Date Modified")
        {
            group("Work Description")
            {
                Caption = 'Work Description';
                field(WorkDescription; WorkDescription)
                {
                    ApplicationArea = all;
                    Importance = Additional;
                    MultiLine = true;
                    ShowCaption = false;
                    ToolTip = 'Specifies the products or service being offered.';
                    Editable = false;
                }
            }
        }
        addlast(General)
        {

            field("Order Type"; Rec."Order Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Order Type field.';
            }
        }
    }
    actions
    {
        addafter("&Print")
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
    trigger OnAfterGetRecord()
    begin
        WorkDescription := Rec.GetWorkDescription();
    end;

    var
        WorkDescription: Text;


}

