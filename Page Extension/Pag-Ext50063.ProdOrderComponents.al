pageextension 50063 ProdOrderComponents extends "Prod. Order Components"
{
    layout
    {
        addafter(Description)
        {
            field("Description 2"; Rec."Description 2")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Description 2 field.';
            }
            field(Revision; Rec.Revision)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Revision field.';
            }
        }
        addbefore("Location Code")
        {
            field("Transfer-from Location Code"; Rec."Transfer-from Location Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Transfer-from Location Code field.';
            }
            field("Transfer-from Bin Code"; Rec."Transfer-from Bin Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Transfer-from Bin Code field.';
            }
        }
        modify("Location Code")
        {
            Visible = true;
        }
        addbefore("Expected Quantity")
        {
            field("Transfered Qty"; Rec."Transfered Qty")
            {
                Editable = false;
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Transfered Quantity field.';
            }
        }
        addafter("Description 2")
        {
            field(TrackingExist; TrackingExist)
            {
                ApplicationArea = All;
                Caption = 'Tracking Exist';
                Editable = false;
            }
        }
    }
    actions
    {
        addafter("&Print")
        {
            action(Transfer)
            {
                ApplicationArea = All;
                Caption = '&Transfer Material';
                Ellipsis = true;
                Image = PostDocument;

                trigger OnAction()
                begin
                    Rec.ProcessMaterialTransfer();
                end;
            }
        }
        addafter(ItemTrackingLines)
        {
            action(ItemTrackingLinesFromLocation)
            {
                ApplicationArea = ItemTracking;
                Caption = 'Item &Tracking Lines From Location';
                Image = ItemTrackingLines;
                ToolTip = 'View or edit serial numbers and lot numbers that are assigned to the item on the document or journal line.';

                trigger OnAction()
                begin
                    Rec.OpenItemTrackingFromLocation(Rec);
                end;
            }
        }
        addafter("&Print_Promoted")
        {
            actionref(Transfer_Promoted; Transfer)
            {
            }
        }
        addafter(ItemTrackingLines_Promoted)
        {
            actionref(ItemTrackingLinesFromLocation_Promoted; ItemTrackingLinesFromLocation)
            {

            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if not ItemGrec.Get(Rec."Item No.") then
            Clear(ItemGrec);
        TrackingExist := ItemGrec."Item Tracking Code" <> '';

    end;

    var
        TrackingExist: Boolean;
        ItemGrec: Record Item;

}
