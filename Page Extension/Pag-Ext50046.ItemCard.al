pageextension 50046 ItemCard extends "Item Card"
{
    layout
    {
        modify(Blocked)
        {
            Editable = EditItemBlock;
        }
        modify("Unit Volume")
        {
            Visible = false;
        }
        modify("Order Tracking Policy")
        {
            Visible = false;
        }
        modify(Description)
        {
            Caption = 'Title';
        }
        modify("Description 2")
        {
            Caption = 'Description';
        }
        modify("Replenishment System")
        {
            trigger OnAfterValidate()
            var
                Msg: Label 'There is an inventory against this item so user cannot change the replenishment system';
            begin
                Rec.CalcFields(Inventory);
                if Rec.Inventory > 0 then
                    Error(Msg);

            end;
        }


        addafter(Purchase)
        {
            group(VendorandManufacturer)
            {
                Caption = 'Vendor and Manufacturer';
                field("Manufacturer Item No."; Rec."Manufacturer Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Manufacturer Item No. field.';
                }
                field("Manufacturer Name"; Rec."Manufacturer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Manufacturer Name field.';
                }
            }
        }
        movefirst(VendorandManufacturer; "Vendor No.", "Vendor Item No.", "Manufacturer Code")

        addafter("Vendor Item No.")
        {
            field("Vendor Name"; Rec."Vendor Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Vendor Name field.';
            }

        }
        addbefore("Over-Receipt Code")
        {
            field("Unit Volume1"; Rec."Unit Volume1")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Unit Volume field.';
            }
        }

        addlast(content)
        {
            group(QualityCheck)
            {
                Caption = 'Quality Check';
                field("Quality Check"; Rec."Quality Check")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Quality Check field.';
                }
                field("Quality Spec ID"; Rec."Quality Spec ID")
                {
                    Editable = Rec."Quality Check";
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Quality Spec ID field.';
                }

            }
        }

        addlast(content)
        {
            group(PLM)
            {
                Caption = 'PLM';

                field(lifecyclestatus; Rec.lifecyclestatus)
                {
                    ApplicationArea = All;
                }
                field(Revision; Rec.Revision)
                {
                    ApplicationArea = All;
                }
                field(ComponentResponsible; Rec.ComponentResponsible)
                {
                    ApplicationArea = all;
                }
                field(ppaprequired; Rec.ppaprequired)
                {
                    ApplicationArea = all;
                }
                field(isirrequired; Rec.isirrequired)
                {
                    ApplicationArea = all;
                }
                field(homologationrequired; Rec.homologationrequired)
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    var
                        ItemTrackingCodeLre: Record "Item Tracking Code";
                    begin
                        ItemTrackingCodeLre.Reset();
                        if ItemTrackingCodeLre.FindFirst() then
                            if rec.homologationrequired then
                                rec."Item Tracking Code" := ItemTrackingCodeLre.Code
                            else
                                rec."Item Tracking Code" := '';
                    end;
                }
                field(criticality; Rec.criticality)
                {
                    ApplicationArea = all;
                }
                field(HomologationCerCompLevel; Rec.HomologationCerCompLevel)
                {
                    ApplicationArea = all;
                }
                field(HomologationCerSysLevel; Rec.HomologationCerSysLevel)
                {
                    ApplicationArea = all;
                }
                field(cocrequired; Rec.cocrequired)
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    var
                        ItemTrackingCodeLre: Record "Item Tracking Code";
                    begin
                        ItemTrackingCodeLre.Reset();
                        if ItemTrackingCodeLre.FindFirst() then
                            if rec.cocrequired then
                                rec."Item Tracking Code" := ItemTrackingCodeLre.Code
                            else
                                rec."Item Tracking Code" := '';



                    end;
                }
                field(weight; Rec.weight)
                {
                    ApplicationArea = all;
                    Caption = 'Weight(in KG)';
                }
                field(weightuom; Rec.weightuom)
                {
                    ApplicationArea = all;
                    visible = false;
                }
                field(enditem; Rec.enditem)
                {
                    ApplicationArea = all;
                }
                field("Maturity State"; Rec."Maturity State")
                {
                    ApplicationArea = all;
                }

            }
        }

        //CHB2B07SEP2023<<

        modify("Lead Time Calculation")
        {
            trigger OnAfterValidate()
            begin

                if not format(rec."Lead Time Calculation").Contains('D') then
                    Error(Text000);

            end;
        }
        //CHB2B07SEP2023>>


    }


    actions
    {
        addbefore(Attachments)
        {
            action(PrintLabel_Q)
            {
                ApplicationArea = All;
                Caption = 'Print Label';
                Image = Print;

                trigger OnAction()
                var
                    ItemRec: Record Item;
                begin
                    ItemRec.Reset();
                    ItemRec.SetRange("No.", Rec."No.");
                    Report.RunModal(Report::"Item Label", true, false, ItemRec);
                end;
            }
        }
        addbefore(Attachments_Promoted)
        {
            actionref(PrintLabel_Promoted; PrintLabel_Q)
            {
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        EditItemBlock := false;
        if not UsersetupRec.Get(UserId) then
            Clear(UsersetupRec);
        EditItemBlock := UsersetupRec."Item Block";
    end;

    trigger OnOpenPage()
    begin
        EditItemBlock := false;
        if not UsersetupRec.Get(UserId) then
            Clear(UsersetupRec);
        EditItemBlock := UsersetupRec."Item Block";
    end;

    var
        EditItemBlock: Boolean;
        UsersetupRec: record "User Setup";
        Text000: Label 'Enter Only Days';

}
